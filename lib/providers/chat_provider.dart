/// Chat providers (Chat Module — Phase A)
///
/// Riverpod wiring over [ChatRepository]. Defaults to [MockChatRepository]
/// so the UI runs with no Sendbird App ID; swap the one line in
/// [chatRepository] to `SendbirdChatRepository(...)` once the SDK impl lands.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/chat_models.dart';
import '../services/chat_repository.dart';

part 'chat_provider.g.dart';

/// The active repository impl. Mock today; Sendbird next.
///
/// keepAlive because the connection + channel handlers must outlive any
/// single screen. Disposed explicitly when the user leaves the chat feature.
@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  final repo = MockChatRepository();
  ref.onDispose(repo.dispose);
  return repo;
}

/// Drives the deferred connect/disconnect that controls Sendbird MAU + PCC
/// billing. Call `enterChat(userId)` when the user opens the chat feature
/// (and only if matched), `leaveChat()` when they leave / background.
///
/// **Do not call this at app launch or login** — connecting bills a MAU.
@Riverpod(keepAlive: true)
class ChatSession extends _$ChatSession {
  @override
  ChatConnectionState build() {
    final repo = ref.watch(chatRepositoryProvider);
    final sub = repo.connectionState().listen((s) => state = s);
    ref.onDispose(sub.cancel);
    return ChatConnectionState.disconnected;
  }

  Future<void> enterChat(String userId) =>
      ref.read(chatRepositoryProvider).connect(userId);

  Future<void> leaveChat() =>
      ref.read(chatRepositoryProvider).disconnect();
}

/// Live conversation list for the ChatsScreen.
@riverpod
Stream<List<ChatChannel>> chatChannels(Ref ref) {
  return ref.watch(chatRepositoryProvider).channels();
}

/// Live message history for one conversation.
@riverpod
Stream<List<ChatMessage>> channelMessages(Ref ref, String channelUrl) {
  return ref.watch(chatRepositoryProvider).messages(channelUrl);
}

/// Whether the partner is typing in a conversation (drives the `•••` bubble).
@riverpod
Stream<bool> partnerTyping(Ref ref, String channelUrl) {
  return ref.watch(chatRepositoryProvider).partnerTyping(channelUrl);
}
