/// DiscoverScreen widget coverage (issue #62): renders the browse deck and a
/// happy-path interaction (the filter funnel opens the filter sheet).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dating_app_verification/providers/discovery_provider.dart';
import 'package:dating_app_verification/screens/discovery/discover_screen.dart';
import 'package:dating_app_verification/services/discovery_repository.dart';

import 'support/tab_test_support.dart';

Widget _app() => ProviderScope(
      overrides: [
        discoveryRepositoryProvider.overrideWithValue(MockDiscoveryRepository()),
      ],
      child: const MaterialApp(home: DiscoverScreen()),
    );

void main() {
  testWidgets('renders the lead profile and the header', (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(_app());
    await settleIgnoringOverflow(tester);

    expect(find.textContaining('Maya'), findsWidgets); // "Maya, 28" name card
    expect(find.text('Magic Search'), findsOneWidget);
  });

  testWidgets('the funnel opens the filter sheet', (tester) async {
    useTallViewport(tester);
    await tester.pumpWidget(_app());
    await settleIgnoringOverflow(tester);

    await tester.tap(find.byIcon(Icons.tune));
    await settleIgnoringOverflow(tester);

    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Looking for'), findsOneWidget);
  });
}
