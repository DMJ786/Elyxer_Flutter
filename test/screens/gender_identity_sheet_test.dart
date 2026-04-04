/// Gender Identity Sheet Tests
/// Tests for the gender identity selection panel
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/models/gender_identity_models.dart';
import 'package:dating_app_verification/providers/onboarding_provider.dart';
import 'package:dating_app_verification/screens/onboarding/gender_identity_sheet.dart';

void main() {
  /// Helper to build test widget that triggers the identity panel
  Widget buildTestWidget(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showGenderIdentitySheet(context),
                child: const Text('Open Panel'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('GenderIdentitySheet - Man options', () {
    testWidgets('should display all man identity options', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      // Open panel
      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      // Verify header
      expect(find.text('Select Gender Identity'), findsOneWidget);

      // Verify all man identity options are visible
      for (final option in GenderIdentityOptions.man) {
        expect(find.text(option.label), findsOneWidget);
      }
    });

    testWidgets('should display "Are we missing something?" tile',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      expect(find.text('Are we missing something?'), findsOneWidget);
    });

    testWidgets('should display "Save and close" button', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      expect(find.text('Save and close'), findsOneWidget);
    });

    testWidgets('should display back chevron', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });
  });

  group('GenderIdentitySheet - Woman options', () {
    testWidgets('should display all woman identity options', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(onboardingDataProvider.notifier)
          .updateGender(Gender.woman);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      for (final option in GenderIdentityOptions.woman) {
        expect(find.text(option.label), findsOneWidget);
      }
    });
  });

  group('GenderIdentitySheet - Non-Binary options', () {
    testWidgets('should display non-binary identity options (visible subset)',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(onboardingDataProvider.notifier)
          .updateGender(Gender.nonBinary);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      // Verify the header is shown
      expect(find.text('Select Gender Identity'), findsOneWidget);

      // Verify first few visible options (above fold)
      expect(find.text('Agender'), findsOneWidget);
      expect(find.text('Bigender'), findsOneWidget);
      expect(find.text('Genderfluid'), findsOneWidget);
      expect(find.text('Genderqueer'), findsOneWidget);
    });

    testWidgets('should show correct count of non-binary options via model',
        (tester) async {
      // Verify via model that all 14 options exist
      expect(GenderIdentityOptions.nonBinary.length, equals(14));
      expect(
        Gender.nonBinary.identityOptions.length,
        equals(14),
      );
    });
  });

  group('GenderIdentitySheet - Selection', () {
    testWidgets('tapping an option should toggle its selection',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      // Tap on "Trans man"
      await tester.tap(find.text('Trans man'));
      await tester.pumpAndSettle();

      // Tap "Save and close"
      await tester.tap(find.text('Save and close'));
      await tester.pumpAndSettle();

      // Verify selection was saved
      final ids =
          container.read(onboardingDataProvider).genderIdentityOptionIds;
      expect(ids, contains('transgender_man'));
    });

    testWidgets('should support multi-select', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      // Select two options
      await tester.tap(find.text('Man'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cis man'));
      await tester.pumpAndSettle();

      // Save
      await tester.tap(find.text('Save and close'));
      await tester.pumpAndSettle();

      final ids =
          container.read(onboardingDataProvider).genderIdentityOptionIds;
      expect(ids.length, equals(2));
      expect(ids, contains('man'));
      expect(ids, contains('cisgender_man'));
    });

    testWidgets('tapping a selected option should unselect it',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);
      // Pre-select an option
      container
          .read(onboardingDataProvider.notifier)
          .updateGenderIdentityOptions(['transgender_man']);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      // Tap the pre-selected option to deselect
      await tester.tap(find.text('Trans man'));
      await tester.pumpAndSettle();

      // Save
      await tester.tap(find.text('Save and close'));
      await tester.pumpAndSettle();

      final ids =
          container.read(onboardingDataProvider).genderIdentityOptionIds;
      expect(ids, isNot(contains('transgender_man')));
    });

    testWidgets('should load existing selections on open', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);
      container
          .read(onboardingDataProvider.notifier)
          .updateGenderIdentityOptions(['man', 'cisgender_man']);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      // Save without changes — original selections should persist
      await tester.tap(find.text('Save and close'));
      await tester.pumpAndSettle();

      final ids =
          container.read(onboardingDataProvider).genderIdentityOptionIds;
      expect(ids.length, equals(2));
      expect(ids, contains('man'));
      expect(ids, contains('cisgender_man'));
    });
  });

  group('GenderIdentitySheet - Navigation', () {
    testWidgets('tapping back chevron should close the panel', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      // Open panel
      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();
      expect(find.text('Select Gender Identity'), findsOneWidget);

      // Tap back
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      // Panel should be closed
      expect(find.text('Select Gender Identity'), findsNothing);
    });

    testWidgets('Save and close should close panel and return to parent',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(onboardingDataProvider.notifier).updateGender(Gender.man);

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();
      expect(find.text('Select Gender Identity'), findsOneWidget);

      await tester.tap(find.text('Save and close'));
      await tester.pumpAndSettle();

      // Should be back to parent screen
      expect(find.text('Open Panel'), findsOneWidget);
      expect(find.text('Select Gender Identity'), findsNothing);
    });
  });

  group('GenderIdentitySheet - Empty state', () {
    testWidgets('should show nothing when gender is null', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Do not set any gender

      await tester.pumpWidget(buildTestWidget(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Panel'));
      await tester.pumpAndSettle();

      // The panel should render a SizedBox.shrink when gender is null
      // so it won't show the header or options list
      expect(find.text('Save and close'), findsNothing);
    });
  });
}
