/// InterestsScreen widget coverage (issue #62): renders received vibes,
/// toggles to invites, and shows the freemium paywall blur for free users.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dating_app_verification/providers/interests_provider.dart';
import 'package:dating_app_verification/screens/interests/interests_screen.dart';
import 'package:dating_app_verification/screens/interests/widgets/interest_widgets.dart';
import 'package:dating_app_verification/services/interests_repository.dart';

import 'support/tab_test_support.dart';

Widget _app({bool premium = true}) => ProviderScope(
      overrides: [
        interestsRepositoryProvider
            .overrideWithValue(MockInterestsRepository(isPremium: premium)),
      ],
      child: const MaterialApp(home: InterestsScreen()),
    );

void main() {
  testWidgets('renders received vibes and toggles to invites', (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(_app());
    await settleIgnoringOverflow(tester);

    expect(find.text('Interests'), findsOneWidget);
    expect(find.text('People who showed interest in you'), findsOneWidget);
    expect(find.byType(ReceivedVibeCard), findsWidgets);

    await tester.tap(find.text('Invites'));
    await settleIgnoringOverflow(tester);

    expect(find.byType(ReceivedInviteCard), findsWidgets);
  });

  testWidgets('free users see the paywall blur; premium users do not',
      (tester) async {
    useTallViewport(tester);

    // PaywallBlur wraps every card; only its `blurred` flag + the UnlockBanner
    // distinguish gated (free) from ungated (premium).
    final blurred = find.byWidgetPredicate((w) => w is PaywallBlur && w.blurred);

    await tester.pumpWidget(_app(premium: false));
    await settleIgnoringOverflow(tester);
    expect(blurred, findsWidgets);
    expect(find.byType(UnlockBanner), findsOneWidget);

    await tester.pumpWidget(_app(premium: true));
    await settleIgnoringOverflow(tester);
    expect(blurred, findsNothing);
    expect(find.byType(UnlockBanner), findsNothing);
  });
}
