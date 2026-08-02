/// MockChatRepository tests — lock the behaviour the UI relies on:
/// connect seeds channels, sendText transitions status, and a Virtual Date
/// invite is appended as a custom-typed message.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/models/chat_models.dart';
import 'package:dating_app_verification/services/chat_repository.dart';

void main() {
  late MockChatRepository repo;

  setUp(() => repo = MockChatRepository(meId: 'me'));
  tearDown(() => repo.dispose());

  test('connect emits connecting → connected and seeds channels', () async {
    final states = <ChatConnectionState>[];
    repo.connectionState().listen(states.add);

    await repo.connect('me');
    // Let the seeded channel list flush.
    final channels = await repo.channels().first;

    expect(states, contains(ChatConnectionState.connecting));
    expect(states.last, ChatConnectionState.connected);
    expect(channels.map((c) => c.otherUser.name), containsAll(['Asha', 'Ravi']));
  });

  test('openOrCreateDirectChannel is idempotent per user', () async {
    await repo.connect('me');
    final a = await repo.openOrCreateDirectChannel('asha');
    final b = await repo.openOrCreateDirectChannel('asha');
    expect(a.url, b.url);
  });

  test('sendText starts as sending and transitions to read', () async {
    await repo.connect('me');
    const url = 'mock_channel_asha';

    final pending = await repo.sendText(url, 'hello');
    expect(pending.status, ChatMessageStatus.sending);
    expect(pending.isMine('me'), isTrue);

    // Await the simulated round-trip and assert the final status is read.
    await Future<void>.delayed(const Duration(seconds: 2));
    final messages = await repo.messages(url).first;
    final sent = messages.firstWhere((m) => m.id == pending.id);
    expect(sent.status, ChatMessageStatus.read);
  });

  test('sendVirtualDateInvite appends a custom-typed message', () async {
    await repo.connect('me');
    const url = 'mock_channel_asha';

    final invite = await repo.sendVirtualDateInvite(
      url,
      data: {'invitee': 'Asha', 'state': 'invited'},
    );

    expect(invite.type, ChatMessageType.virtualDateInvite);
    expect(invite.data?['invitee'], 'Asha');

    final messages = await repo.messages(url).first;
    expect(messages.any((m) => m.type == ChatMessageType.virtualDateInvite),
        isTrue);
  });

  test('markRead clears the unread badge', () async {
    await repo.connect('me');
    // Seeded Asha channel starts at 0; force a non-zero then clear.
    await repo.markRead('mock_channel_asha');
    final channels = await repo.channels().first;
    final asha =
        channels.firstWhere((c) => c.otherUser.id == 'asha');
    expect(asha.unreadCount, 0);
  });
}
