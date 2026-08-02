/// Chat repository — the vendor-agnostic seam between the UI and the chat
/// backend.
///
/// The UI and providers depend ONLY on [ChatRepository]. Two impls exist:
///   - [MockChatRepository]      — in-memory, simulated realtime. Runs with
///                                 no SDK / no App ID. Used for dev, tests,
///                                 and design review.
///   - SendbirdChatRepository    — wraps `sendbird_chat_sdk` (added next).
///
/// Cost rule baked into the contract: [connect] is explicit and deferred.
/// Callers connect only when the user enters the chat feature (and is
/// matched) — never at app launch — because Sendbird bills a Monthly Active
/// User the moment the SDK opens a connection, message or not.
library;

import 'dart:async';

import '../models/chat_models.dart';

abstract class ChatRepository {
  /// Current connection lifecycle, for the connecting/reconnecting banner
  /// and to gate sending.
  Stream<ChatConnectionState> connectionState();

  /// Opens the backend connection for [userId]. **This is the MAU-billing
  /// moment** — call it lazily on entering chat, not at login. Idempotent.
  Future<void> connect(String userId);

  /// Closes the connection. Call on leaving the chat feature / backgrounding
  /// to release the websocket (controls Peak Concurrent Connections).
  Future<void> disconnect();

  /// Live list of the current user's 1:1 conversations, newest first.
  Stream<List<ChatChannel>> channels();

  /// Returns the existing 1:1 channel with [otherUserId], creating it if
  /// absent. Idempotent — the same matched pair always resolves to the same
  /// channel (Sendbird `isDistinct`).
  Future<ChatChannel> openOrCreateDirectChannel(String otherUserId);

  /// Live, ordered message history for a channel (oldest → newest).
  Stream<List<ChatMessage>> messages(String channelUrl);

  /// Sends a plain text message. Returns immediately with a `sending`
  /// message; its status transitions (sent/failed) arrive via [messages].
  Future<ChatMessage> sendText(String channelUrl, String text);

  /// Sends a Virtual Date invite as a custom-typed message. [data] is the
  /// card payload (invitee name, state, etc.).
  Future<ChatMessage> sendVirtualDateInvite(
    String channelUrl, {
    required Map<String, Object?> data,
  });

  /// Marks the channel read up to the latest message (clears unread badge,
  /// sends a read receipt to the partner).
  Future<void> markRead(String channelUrl);

  /// Whether the partner is currently typing in [channelUrl].
  Stream<bool> partnerTyping(String channelUrl);

  /// Tell the backend the current user started/stopped typing.
  void startTyping(String channelUrl);
  void stopTyping(String channelUrl);

  /// Blocks / reports the other participant (Block & Report popups).
  Future<void> blockUser(String userId);
  Future<void> reportUser(String userId, {required String reason});

  /// Releases handlers/streams. Call from a Riverpod onDispose.
  void dispose();
}

// ---------------------------------------------------------------------------
// Mock implementation — in-memory, simulated realtime.
// ---------------------------------------------------------------------------

/// A fully working in-memory [ChatRepository]. Seeds two conversations that
/// mirror the Figma (Asha + Ravi), echoes sent messages, simulates delivery
/// → read transitions and a partner typing burst, so the whole UI can be
/// built and demoed before the Sendbird SDK is wired.
class MockChatRepository implements ChatRepository {
  MockChatRepository({this.meId = 'me'});

  final String meId;

  final _connection =
      StreamController<ChatConnectionState>.broadcast();
  final _channelsCtrl =
      StreamController<List<ChatChannel>>.broadcast();
  final Map<String, StreamController<List<ChatMessage>>> _messageCtrls = {};
  final Map<String, StreamController<bool>> _typingCtrls = {};

  final Map<String, ChatChannel> _channels = {};
  final Map<String, List<ChatMessage>> _messages = {};

  var _seeded = false;
  var _counter = 0;
  var _disposed = false;

  String _nextId(String prefix) => '$prefix-${_counter++}';

  @override
  Stream<ChatConnectionState> connectionState() => _connection.stream;

  @override
  Future<void> connect(String userId) async {
    _connection.add(ChatConnectionState.connecting);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!_seeded) {
      _seed();
      _seeded = true;
    }
    _connection.add(ChatConnectionState.connected);
    _emitChannels();
  }

  @override
  Future<void> disconnect() async {
    _connection.add(ChatConnectionState.disconnected);
  }

  @override
  Stream<List<ChatChannel>> channels() async* {
    // Replay the current list to every new subscriber, then stream updates —
    // the ChatsScreen needs current state the moment it opens.
    yield _sortedChannels();
    yield* _channelsCtrl.stream;
  }

  @override
  Future<ChatChannel> openOrCreateDirectChannel(String otherUserId) async {
    final existing = _channels.values
        .where((c) => c.otherUser.id == otherUserId)
        .firstOrNull;
    if (existing != null) return existing;

    final url = 'mock_channel_$otherUserId';
    final channel = ChatChannel(
      url: url,
      otherUser: ChatUser(id: otherUserId, name: otherUserId),
    );
    _channels[url] = channel;
    _messages[url] = [];
    _emitChannels();
    return channel;
  }

  @override
  Stream<List<ChatMessage>> messages(String channelUrl) async* {
    // Snapshot first (so `.first` / an opening screen sees history
    // immediately), then live appends + status transitions.
    yield List.unmodifiable(_messages[channelUrl] ?? const <ChatMessage>[]);
    final ctrl = _messageCtrls.putIfAbsent(
      channelUrl,
      () => StreamController<List<ChatMessage>>.broadcast(),
    );
    yield* ctrl.stream;
  }

  @override
  Future<ChatMessage> sendText(String channelUrl, String text) async {
    final pending = ChatMessage(
      id: _nextId('msg'),
      channelUrl: channelUrl,
      senderId: meId,
      text: text,
      sentAt: _now(),
      status: ChatMessageStatus.sending,
    );
    _append(channelUrl, pending);

    // Simulate the network round-trip: sending → sent → delivered → read.
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      _updateStatus(channelUrl, pending.id, ChatMessageStatus.sent);
    });
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      _updateStatus(channelUrl, pending.id, ChatMessageStatus.delivered);
    });
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      _updateStatus(channelUrl, pending.id, ChatMessageStatus.read);
    });

    // Simulate the partner replying ONCE per sent message: a typing burst
    // (mirrors the Figma's ~1.8s delay) then a canned reply. Tied to send —
    // not to keystrokes — so it can't stack.
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (_disposed) return;
      _typingCtrls[channelUrl]?.add(true);
    });
    Future<void>.delayed(const Duration(milliseconds: 3400), () {
      if (_disposed) return;
      _typingCtrls[channelUrl]?.add(false);
      _append(
        channelUrl,
        ChatMessage(
          id: _nextId('reply'),
          channelUrl: channelUrl,
          senderId: _channels[channelUrl]?.otherUser.id ?? 'them',
          text: 'So happy to hear 🙂',
          sentAt: _now(),
        ),
      );
    });
    return pending;
  }

  @override
  Future<ChatMessage> sendVirtualDateInvite(
    String channelUrl, {
    required Map<String, Object?> data,
  }) async {
    final msg = ChatMessage(
      id: _nextId('vd'),
      channelUrl: channelUrl,
      senderId: meId,
      text: '',
      sentAt: _now(),
      type: ChatMessageType.virtualDateInvite,
      status: ChatMessageStatus.sent,
      data: data,
    );
    _append(channelUrl, msg);
    return msg;
  }

  @override
  Future<void> markRead(String channelUrl) async {
    final ch = _channels[channelUrl];
    if (ch != null && ch.unreadCount != 0) {
      _channels[channelUrl] = ch.copyWith(unreadCount: 0);
      _emitChannels();
    }
  }

  @override
  Stream<bool> partnerTyping(String channelUrl) {
    return _typingCtrls
        .putIfAbsent(
          channelUrl,
          () => StreamController<bool>.broadcast(),
        )
        .stream;
  }

  @override
  void startTyping(String channelUrl) {
    // No-op in the mock. The simulated partner reply is driven by [sendText]
    // (once per sent message) so it can't stack on per-keystroke calls. On
    // real Sendbird this sends a typing event to the partner.
  }

  @override
  void stopTyping(String channelUrl) {}

  @override
  Future<void> blockUser(String userId) async {}

  @override
  Future<void> reportUser(String userId, {required String reason}) async {}

  @override
  void dispose() {
    // Set first so any in-flight delayed callbacks (status transitions, the
    // simulated reply) short-circuit instead of adding to closed controllers.
    _disposed = true;
    _connection.close();
    _channelsCtrl.close();
    for (final c in _messageCtrls.values) {
      c.close();
    }
    for (final c in _typingCtrls.values) {
      c.close();
    }
  }

  // --- internals -----------------------------------------------------------

  /// Monotonic clock so mock timestamps order correctly without Date.now()
  /// nondeterminism in tests. Starts at a fixed epoch and ticks up.
  DateTime _now() =>
      DateTime.fromMillisecondsSinceEpoch(1700000000000 + (_counter * 1000));

  void _append(String channelUrl, ChatMessage msg) {
    if (_disposed) return;
    final list = _messages.putIfAbsent(channelUrl, () => []);
    list.add(msg);
    _messageCtrls[channelUrl]?.add(List.unmodifiable(list));
    final ch = _channels[channelUrl];
    if (ch != null) {
      _channels[channelUrl] =
          ch.copyWith(lastMessage: msg, lastActivityAt: msg.sentAt);
      _emitChannels();
    }
  }

  void _updateStatus(
    String channelUrl,
    String messageId,
    ChatMessageStatus status,
  ) {
    if (_disposed) return;
    final list = _messages[channelUrl];
    if (list == null) return;
    final i = list.indexWhere((m) => m.id == messageId);
    if (i < 0) return;
    list[i] = list[i].copyWith(status: status);
    _messageCtrls[channelUrl]?.add(List.unmodifiable(list));
  }

  List<ChatChannel> _sortedChannels() {
    final sorted = _channels.values.toList()
      ..sort((a, b) => (b.lastActivityAt ?? DateTime(0))
          .compareTo(a.lastActivityAt ?? DateTime(0)));
    return List.unmodifiable(sorted);
  }

  void _emitChannels() {
    if (_disposed) return;
    _channelsCtrl.add(_sortedChannels());
  }

  void _seed() {
    const asha = ChatUser(id: 'asha', name: 'Asha', isOnline: true);
    const ravi = ChatUser(id: 'ravi', name: 'Ravi');

    final ashaUrl = 'mock_channel_asha';
    final raviUrl = 'mock_channel_ravi';

    _messages[ashaUrl] = [
      ChatMessage(
        id: _nextId('seed'),
        channelUrl: ashaUrl,
        senderId: 'asha',
        text: 'I am here looking for a travel partner.',
        sentAt: _now(),
      ),
      ChatMessage(
        id: _nextId('seed'),
        channelUrl: ashaUrl,
        senderId: meId,
        text: 'I myself love travelling',
        sentAt: _now(),
        status: ChatMessageStatus.read,
      ),
    ];
    _channels[ashaUrl] = ChatChannel(
      url: ashaUrl,
      otherUser: asha,
      lastMessage: _messages[ashaUrl]!.last,
      unreadCount: 0,
      lastActivityAt: _messages[ashaUrl]!.last.sentAt,
    );

    // Ravi = empty "start a conversation" state.
    _messages[raviUrl] = [];
    _channels[raviUrl] = ChatChannel(
      url: raviUrl,
      otherUser: ravi,
      lastActivityAt: _now(),
    );
  }
}
