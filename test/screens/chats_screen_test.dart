/// ChatsScreen widget coverage (issue #62): connects the mock chat backend,
/// renders connections + conversations, and opens a thread on tap.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dating_app_verification/providers/chat_provider.dart';
import 'package:dating_app_verification/screens/chat/chats_screen.dart';
import 'package:dating_app_verification/services/chat_repository.dart';

import 'support/tab_test_support.dart';

GoRouter _router() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const ChatsScreen()),
        GoRoute(
          path: '/conversation',
          builder: (_, _) => const Scaffold(body: Text('conversation screen')),
        ),
      ],
    );

Widget _app() => ProviderScope(
      overrides: [
        // Default is real Sendbird; force the in-memory mock in tests.
        chatRepositoryProvider.overrideWithValue(MockChatRepository()),
      ],
      child: MaterialApp.router(routerConfig: _router()),
    );

void main() {
  testWidgets('connects and renders seeded connections', (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(_app());
    await tester.pump(); // run the initState microtask (enterChat -> connect)
    await tester.pump(const Duration(milliseconds: 400)); // mock seeds channels
    await settleIgnoringOverflow(tester);

    expect(find.text('Chats'), findsOneWidget);
    // Mock seeds Asha (with history) + Ravi.
    expect(find.text('Asha'), findsWidgets);
  });

  testWidgets('tapping a connection opens the conversation thread',
      (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(_app());
    await tester.pump(); // run the initState microtask (enterChat -> connect)
    await tester.pump(const Duration(milliseconds: 400)); // mock seeds channels
    await settleIgnoringOverflow(tester);

    await tester.tap(find.text('Asha').first);
    await settleIgnoringOverflow(tester);

    expect(find.text('conversation screen'), findsOneWidget);
  });
}
