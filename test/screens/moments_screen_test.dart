/// MomentsScreen widget coverage (issue #62): renders the feed (incl. own
/// cards) and a happy-path interaction (Share-a-moment opens the composer).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dating_app_verification/providers/moments_provider.dart';
import 'package:dating_app_verification/screens/moments/moments_screen.dart';
import 'package:dating_app_verification/screens/moments/widgets/moment_widgets.dart';
import 'package:dating_app_verification/services/moments_repository.dart';

import 'support/tab_test_support.dart';

GoRouter _router() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const MomentsScreen()),
        GoRoute(
          path: '/share-moment',
          builder: (_, _) => const Scaffold(body: Text('composer screen')),
        ),
        GoRoute(
          path: '/moment-author',
          builder: (_, _) => const Scaffold(body: Text('author preview')),
        ),
      ],
    );

Widget _app() => ProviderScope(
      overrides: [
        momentsRepositoryProvider.overrideWithValue(MockMomentsRepository()),
      ],
      child: MaterialApp.router(routerConfig: _router()),
    );

void main() {
  testWidgets("renders the feed with the user's own moment", (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(_app());
    await settleIgnoringOverflow(tester);

    expect(find.text('Moments'), findsOneWidget);
    expect(find.byType(MomentCard), findsWidgets);
    expect(find.text('You'), findsWidgets); // own moments render as "You"
  });

  testWidgets('tapping Share a moment opens the composer', (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(_app());
    await settleIgnoringOverflow(tester);

    await tester.tap(find.byType(ShareMomentBar));
    await settleIgnoringOverflow(tester);

    expect(find.text('composer screen'), findsOneWidget);
  });
}
