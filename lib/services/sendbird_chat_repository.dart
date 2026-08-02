/// Sendbird-backed [ChatRepository] — the real chat data layer.
///
/// Wraps `sendbird_chat_sdk` (v4) and maps its types into our vendor-agnostic
/// models so the UI never sees a Sendbird class. Registers one group-channel
/// handler + one connection handler and fans their events into per-channel
/// broadcast streams.
///
/// Cost discipline: [connect] is the only place a websocket opens (the
/// MAU-billing moment) and it is called lazily on entering chat; [disconnect]
/// releases it on leave (controls Peak Concurrent Connections).
library;

import 'dart:async';

import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart' as sb;

import '../core/config/env.dart';
import '../models/chat_models.dart';
import 'chat_repository.dart';

class SendbirdChatRepository implements ChatRepository {
  SendbirdChatRepository({String? appId})
      : _appId = appId ?? Env.sendbirdAppId;

  final String _appId;

  static const String _handlerId = 'elyxer_chat';

  String _meId = '';
  bool _initialised = false;

  final _connection = StreamController<ChatConnectionState>.broadcast();
  final _channelsCtrl = StreamController<List<ChatChannel>>.broadcast();
  final Map<String, StreamController<List<ChatMessage>>> _messageCtrls = {};
  final Map<String, StreamController<bool>> _typingCtrls = {};

  /// Live Sendbird channel objects by url — needed to send/type/mark on them.
  final Map<String, sb.GroupChannel> _channelCache = {};

  /// In-memory message lists per channel, kept in sync from the handler +
  /// initial query, re-emitted to [messages] subscribers.
  final Map<String, List<ChatMessage>> _messages = {};

  // --- connection ----------------------------------------------------------

  @override
  Stream<ChatConnectionState> connectionState() => _connection.stream;

  @override
  Future<void> connect(String userId) async {
    _meId = userId;
    if (!_initialised) {
      await sb.SendbirdChat.init(appId: _appId);
      sb.SendbirdChat.addChannelHandler(_handlerId, _ChannelHandler(this));
      sb.SendbirdChat.addConnectionHandler(
          _handlerId, _ConnectionHandler(this));
      _initialised = true;
    }

    _connection.add(ChatConnectionState.connecting);
    // For the trial we connect with just the user id. Production passes a
    // server-minted session token: connect(userId, accessToken: token).
    await sb.SendbirdChat.connect(userId);
    _connection.add(ChatConnectionState.connected);

    await _loadChannels();
  }

  @override
  Future<void> disconnect() async {
    await sb.SendbirdChat.disconnect();
    _connection.add(ChatConnectionState.disconnected);
  }

  // --- channels ------------------------------------------------------------

  @override
  Stream<List<ChatChannel>> channels() async* {
    yield _channelCache.values.map(_toChannel).toList()
      ..sort(_byRecency);
    yield* _channelsCtrl.stream;
  }

  Future<void> _loadChannels() async {
    final query = sb.GroupChannelListQuery()
      ..limit = 50
      ..order = sb.GroupChannelListQueryOrder.latestLastMessage;
    final list = await query.next();
    for (final c in list) {
      _channelCache[c.channelUrl] = c;
    }
    _emitChannels();
  }

  @override
  Future<ChatChannel> openOrCreateDirectChannel(String otherUserId) async {
    final params = sb.GroupChannelCreateParams()
      ..userIds = [_meId, otherUserId]
      ..isDistinct = true;
    final channel = await sb.GroupChannel.createChannel(params);
    _channelCache[channel.channelUrl] = channel;
    _messages.putIfAbsent(channel.channelUrl, () => []);
    _emitChannels();
    return _toChannel(channel);
  }

  // --- messages ------------------------------------------------------------

  @override
  Stream<List<ChatMessage>> messages(String channelUrl) async* {
    // Load history on first subscribe if we don't have it yet.
    if (!_messages.containsKey(channelUrl)) {
      await _loadMessages(channelUrl);
    }
    yield List.unmodifiable(_messages[channelUrl] ?? const <ChatMessage>[]);
    yield* _messageCtrl(channelUrl).stream;
  }

  Future<void> _loadMessages(String channelUrl) async {
    final query = sb.PreviousMessageListQuery(
      channelType: sb.ChannelType.group,
      channelUrl: channelUrl,
    )
      ..limit = 50
      ..reverse = false;
    final loaded = await query.next();
    _messages[channelUrl] = loaded.map(_toMessage).toList();
    _emitMessages(channelUrl);
  }

  @override
  Future<ChatMessage> sendText(String channelUrl, String text) async {
    final channel = await _channel(channelUrl);
    final params = sb.UserMessageCreateParams(message: text);

    final completer = Completer<ChatMessage>();
    final pending = channel.sendUserMessage(
      params,
      handler: (sb.UserMessage msg, sb.SendbirdException? e) {
        final mapped = _toMessage(msg).copyWith(
          status: e != null
              ? ChatMessageStatus.failed
              : _statusOf(msg.sendingStatus),
        );
        _replaceOrAppend(channelUrl, mapped);
      },
    );

    final pendingModel = _toMessage(pending)
        .copyWith(status: ChatMessageStatus.sending);
    _replaceOrAppend(channelUrl, pendingModel);
    if (!completer.isCompleted) completer.complete(pendingModel);
    return pendingModel;
  }

  @override
  Future<ChatMessage> sendVirtualDateInvite(
    String channelUrl, {
    required Map<String, Object?> data,
  }) async {
    final channel = await _channel(channelUrl);
    final params = sb.UserMessageCreateParams(message: '')
      ..customType = ChatMessageType.virtualDateInvite.wireCustomType
      ..data = _encode(data);

    final pending = channel.sendUserMessage(
      params,
      handler: (sb.UserMessage msg, sb.SendbirdException? e) {
        _replaceOrAppend(channelUrl, _toMessage(msg));
      },
    );
    final model = _toMessage(pending);
    _replaceOrAppend(channelUrl, model);
    return model;
  }

  @override
  Future<void> markRead(String channelUrl) async {
    final channel = await _channel(channelUrl);
    await channel.markAsRead();
  }

  // --- typing --------------------------------------------------------------

  @override
  Stream<bool> partnerTyping(String channelUrl) =>
      _typingCtrl(channelUrl).stream;

  @override
  void startTyping(String channelUrl) {
    _channelCache[channelUrl]?.startTyping();
  }

  @override
  void stopTyping(String channelUrl) {
    _channelCache[channelUrl]?.endTyping();
  }

  // --- moderation ----------------------------------------------------------

  @override
  Future<void> blockUser(String userId) async {
    await sb.SendbirdChat.blockUser(userId);
  }

  @override
  Future<void> reportUser(String userId, {required String reason}) async {
    // Sendbird report goes through the channel/message report APIs; wired in
    // the moderation PR. No-op here so the Report popup doesn't throw.
  }

  @override
  void dispose() {
    sb.SendbirdChat.removeChannelHandler(_handlerId);
    sb.SendbirdChat.removeConnectionHandler(_handlerId);
    _connection.close();
    _channelsCtrl.close();
    for (final c in _messageCtrls.values) {
      c.close();
    }
    for (final c in _typingCtrls.values) {
      c.close();
    }
  }

  // --- handler callbacks (invoked by the SDK handlers) ---------------------

  void _onMessageReceived(String channelUrl, ChatMessage message) {
    _replaceOrAppend(channelUrl, message);
    final cached = _channelCache[channelUrl];
    if (cached != null) _emitChannels();
  }

  void _onTypingUpdated(String channelUrl, bool isTyping) {
    _typingCtrl(channelUrl).add(isTyping);
  }

  void _onReadStatusUpdated(String channelUrl) {
    // Partner read our messages — bump our sent messages to `read`.
    final list = _messages[channelUrl];
    if (list == null) return;
    var changed = false;
    for (var i = 0; i < list.length; i++) {
      final m = list[i];
      if (m.senderId == _meId && m.status == ChatMessageStatus.sent) {
        list[i] = m.copyWith(status: ChatMessageStatus.read);
        changed = true;
      }
    }
    if (changed) _emitMessages(channelUrl);
  }

  void _onChannelChanged(sb.GroupChannel channel) {
    _channelCache[channel.channelUrl] = channel;
    _emitChannels();
  }

  void _onConnectionState(ChatConnectionState s) => _connection.add(s);

  // --- mapping + helpers ---------------------------------------------------

  ChatChannel _toChannel(sb.GroupChannel c) {
    final other = c.members.where((m) => m.userId != _meId).firstOrNull;
    final last = c.lastMessage;
    return ChatChannel(
      url: c.channelUrl,
      otherUser: ChatUser(
        id: other?.userId ?? '',
        name: (other?.nickname.isNotEmpty ?? false)
            ? other!.nickname
            : (other?.userId ?? 'Unknown'),
        avatarUrl: (other?.profileUrl.isNotEmpty ?? false)
            ? other!.profileUrl
            : null,
      ),
      lastMessage: last != null ? _toMessage(last) : null,
      unreadCount: c.unreadMessageCount,
      lastActivityAt: last != null
          ? DateTime.fromMillisecondsSinceEpoch(last.createdAt)
          : null,
    );
  }

  ChatMessage _toMessage(sb.BaseMessage m) {
    final customType = m.customType;
    final type = ChatMessageType.fromWire(
        (customType == null || customType.isEmpty) ? null : customType);
    // Prefer the client requestId for messages I sent: it's stable across the
    // pending (messageId 0) → confirmed (real messageId) transition, so the
    // two collapse into one row. Received / historical messages carry no
    // requestId and key on messageId.
    final requestId = m.requestId;
    return ChatMessage(
      id: (requestId != null && requestId.isNotEmpty)
          ? 'req_$requestId'
          : m.messageId.toString(),
      channelUrl: m.channelUrl,
      senderId: m.sender?.userId ?? '',
      text: m.message,
      sentAt: DateTime.fromMillisecondsSinceEpoch(m.createdAt),
      type: type,
      status: _statusOf(m.sendingStatus),
      data: type == ChatMessageType.virtualDateInvite
          ? _decode(m.data)
          : null,
    );
  }

  ChatMessageStatus _statusOf(sb.SendingStatus? s) {
    switch (s) {
      case sb.SendingStatus.pending:
        return ChatMessageStatus.sending;
      case sb.SendingStatus.failed:
      case sb.SendingStatus.canceled:
        return ChatMessageStatus.failed;
      case sb.SendingStatus.succeeded:
      case sb.SendingStatus.none:
      case null:
        return ChatMessageStatus.sent;
    }
  }

  Future<sb.GroupChannel> _channel(String url) async {
    final cached = _channelCache[url];
    if (cached != null) return cached;
    final channel = await sb.GroupChannel.getChannel(url);
    _channelCache[url] = channel;
    return channel;
  }

  StreamController<List<ChatMessage>> _messageCtrl(String url) =>
      _messageCtrls.putIfAbsent(
          url, () => StreamController<List<ChatMessage>>.broadcast());

  StreamController<bool> _typingCtrl(String url) => _typingCtrls.putIfAbsent(
      url, () => StreamController<bool>.broadcast());

  void _replaceOrAppend(String url, ChatMessage message) {
    final list = _messages.putIfAbsent(url, () => []);
    // A pending message and its confirmed version share the same messageId
    // once the server assigns one; replace by id, else append.
    final i = list.indexWhere((m) => m.id == message.id);
    if (i >= 0) {
      list[i] = message;
    } else {
      list.add(message);
    }
    _emitMessages(url);
  }

  void _emitMessages(String url) {
    _messageCtrls[url]?.add(List.unmodifiable(_messages[url] ?? const []));
  }

  void _emitChannels() {
    final channels = _channelCache.values.map(_toChannel).toList()
      ..sort(_byRecency);
    _channelsCtrl.add(List.unmodifiable(channels));
  }

  int _byRecency(ChatChannel a, ChatChannel b) =>
      (b.lastActivityAt ?? DateTime(0))
          .compareTo(a.lastActivityAt ?? DateTime(0));

  String _encode(Map<String, Object?> data) =>
      data.entries.map((e) => '${e.key}=${e.value}').join('&');

  Map<String, Object?> _decode(String? data) {
    if (data == null || data.isEmpty) return {};
    return {
      for (final pair in data.split('&'))
        if (pair.contains('='))
          pair.split('=').first: pair.split('=').last,
    };
  }
}

// ---------------------------------------------------------------------------
// SDK handlers — thin adapters that push into the repository's streams.
// ---------------------------------------------------------------------------

class _ChannelHandler extends sb.GroupChannelHandler {
  _ChannelHandler(this._repo);
  final SendbirdChatRepository _repo;

  @override
  void onMessageReceived(sb.BaseChannel channel, sb.BaseMessage message) {
    _repo._onMessageReceived(channel.channelUrl, _repo._toMessage(message));
  }

  @override
  void onChannelChanged(sb.BaseChannel channel) {
    if (channel is sb.GroupChannel) _repo._onChannelChanged(channel);
  }

  @override
  void onTypingStatusUpdated(sb.GroupChannel channel) {
    final typers =
        channel.getTypingUsers().where((u) => u.userId != _repo._meId);
    _repo._onTypingUpdated(channel.channelUrl, typers.isNotEmpty);
  }

  @override
  void onReadStatusUpdated(sb.GroupChannel channel) {
    _repo._onReadStatusUpdated(channel.channelUrl);
  }
}

class _ConnectionHandler extends sb.ConnectionHandler {
  _ConnectionHandler(this._repo);
  final SendbirdChatRepository _repo;

  @override
  void onConnected(String userId) =>
      _repo._onConnectionState(ChatConnectionState.connected);

  @override
  void onDisconnected(String userId) =>
      _repo._onConnectionState(ChatConnectionState.disconnected);

  @override
  void onReconnectStarted() =>
      _repo._onConnectionState(ChatConnectionState.reconnecting);

  @override
  void onReconnectSucceeded() =>
      _repo._onConnectionState(ChatConnectionState.connected);

  @override
  void onReconnectFailed() =>
      _repo._onConnectionState(ChatConnectionState.disconnected);
}
