/// Interests → Chat wiring (issue #59): accepting an invite / vibing back and
/// choosing "Chat Now" opens a real 1:1 conversation (via
/// ChatRepository.openOrCreateDirectChannel), not the chat list.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dating_app_verification/models/chat_models.dart';
import 'package:dating_app_verification/models/discovery_models.dart';
import 'package:dating_app_verification/models/interest_models.dart';
import 'package:dating_app_verification/providers/chat_provider.dart';
import 'package:dating_app_verification/screens/interests/profile_preview_screen.dart';
import 'package:dating_app_verification/services/chat_repository.dart';
import 'package:dating_app_verification/services/discovery_repository.dart';

GoRouter _router(Widget preview) => GoRouter(
      initialLocation: '/preview',
      routes: [
        GoRoute(path: '/preview', builder: (_, _) => preview),
        GoRoute(
          path: '/conversation',
          builder: (_, GoRouterState state) {
            final channel = state.extra as ChatChannel;
            return Scaffold(
              body: Center(
                child: Text('conversation with ${channel.otherUser.id}'),
              ),
            );
          },
        ),
        // Present so a "Later"/list navigation wouldn't blow up the router.
        GoRoute(
          path: '/chats',
          builder: (_, _) => const Scaffold(body: Text('chats list')),
        ),
      ],
    );

void main() {
  testWidgets('accepting an invite + Chat Now opens the 1:1 conversation',
      (tester) async {
    // maya — from the shared Discovery seed the Interests mock also uses.
    final profile = MockDiscoveryRepository.seedProfiles.first;
    final invite = ReceivedInvite(
      id: 'ri-test',
      from: profile,
      type: InviteType.coffee,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Force the in-memory chat backend (no Sendbird SDK in tests).
          chatRepositoryProvider.overrideWithValue(MockChatRepository()),
        ],
        child: MaterialApp.router(
          routerConfig: _router(ProfilePreviewScreen.invite(invite)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();
    expect(find.text('Invite Accepted!'), findsOneWidget);

    await tester.tap(find.text('Chat Now'));
    await tester.pumpAndSettle();

    // Landed on a real 1:1 thread with maya, not the chats list.
    expect(find.text('conversation with ${profile.id}'), findsOneWidget);
    expect(find.text('chats list'), findsNothing);
  });
}
