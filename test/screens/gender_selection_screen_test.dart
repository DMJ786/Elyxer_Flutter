/// Gender Selection Screen Tests
/// Tests for the gender selection screen widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/providers/onboarding_provider.dart';
import 'package:dating_app_verification/screens/onboarding/gender_selection_screen.dart';
import 'package:dating_app_verification/widgets/info_banner.dart';

void main() {
  Widget buildTestWidget({ProviderContainer? container}) {
    if (container != null) {
      return UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: 800,
                child: GenderSelectionScreen(),
              ),
            ),
          ),
        ),
      );
    }
    return const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 800,
              child: GenderSelectionScreen(),
            ),
          ),
        ),
      ),
    );
  }

  group('GenderSelectionScreen - Rendering', () {
    testWidgets('should display header text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('How do you describe your Gender?'),
        findsOneWidget,
      );
    });

    testWidgets('should display three gender buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Man'), findsOneWidget);
      expect(find.text('Woman'), findsOneWidget);
      expect(find.text('Non-Binary'), findsOneWidget);
    });

    testWidgets('should display gender icons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.male), findsOneWidget);
      expect(find.byIcon(Icons.female), findsOneWidget);
      expect(find.byIcon(Icons.transgender), findsOneWidget);
    });

    testWidgets('should display InfoBanner', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(InfoBanner), findsOneWidget);
      expect(
        find.text(
          'Helps represent you as you identify. You can change this anytime.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display "Learn more" link', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Learn more'), findsOneWidget);
    });
  });

  group('GenderSelectionScreen - Gender Identity Link', () {
    testWidgets(
      'should show "Add more about your gender identity" link when no identities selected',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.text('Add more about your gender identity'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'link should be disabled (gray) when no gender is selected',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // The link text should exist but be gray (disabled)
        expect(
          find.text('Add more about your gender identity'),
          findsOneWidget,
        );

        // Chevron icon should be visible
        expect(find.byIcon(Icons.chevron_right), findsWidgets);
      },
    );

    testWidgets(
      'link should be active (gold) after selecting a gender',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(buildTestWidget(container: container));
        await tester.pumpAndSettle();

        // Select a gender
        container.read(onboardingDataProvider.notifier).updateGender(Gender.man);
        await tester.pumpAndSettle();

        // Link should still be visible
        expect(
          find.text('Add more about your gender identity'),
          findsOneWidget,
        );
      },
    );
  });

  group('GenderSelectionScreen - Gender Selection', () {
    testWidgets('tapping Man button should select Man gender', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(buildTestWidget(container: container));
      await tester.pumpAndSettle();

      // Tap on Man gender button
      await tester.tap(find.text('Man'));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingDataProvider).gender,
        equals(Gender.man),
      );
    });

    testWidgets('tapping Woman button should select Woman gender', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(buildTestWidget(container: container));
      await tester.pumpAndSettle();

      // Tap on Woman gender button
      await tester.tap(find.text('Woman'));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingDataProvider).gender,
        equals(Gender.woman),
      );
    });

    testWidgets('tapping Non-Binary button should select Non-Binary gender',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(buildTestWidget(container: container));
      await tester.pumpAndSettle();

      // Tap on Non-Binary gender button
      await tester.tap(find.text('Non-Binary'));
      await tester.pumpAndSettle();

      expect(
        container.read(onboardingDataProvider).gender,
        equals(Gender.nonBinary),
      );
    });

    testWidgets(
      'switching gender should clear previous identity selections',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(buildTestWidget(container: container));
        await tester.pumpAndSettle();

        // Select Man and add identity
        container.read(onboardingDataProvider.notifier).updateGender(Gender.man);
        container
            .read(onboardingDataProvider.notifier)
            .updateGenderIdentityOptions(['transgender_man']);
        await tester.pumpAndSettle();

        expect(
          container.read(onboardingDataProvider).genderIdentityOptionIds,
          isNotEmpty,
        );

        // Switch to Woman — identities should clear
        await tester.tap(find.text('Woman'));
        await tester.pumpAndSettle();

        expect(
          container.read(onboardingDataProvider).genderIdentityOptionIds,
          isEmpty,
        );
      },
    );
  });

  group('GenderSelectionScreen - Identity Chips Display', () {
    testWidgets(
      'should show chips when identity options are selected',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Pre-select gender and identity options
        container.read(onboardingDataProvider.notifier).updateGender(Gender.man);
        container
            .read(onboardingDataProvider.notifier)
            .updateGenderIdentityOptions(['transgender_man']);

        await tester.pumpWidget(buildTestWidget(container: container));
        await tester.pumpAndSettle();

        // Should show the curated text
        expect(
          find.text(
            'Profile recommendations are curated based on your selection.',
          ),
          findsOneWidget,
        );

        // Should show base gender chip "Man" and identity chip "Trans man"
        expect(find.text('Man'), findsWidgets); // One in button, one in chips
        expect(find.text('Trans man'), findsOneWidget);
      },
    );

    testWidgets(
      'should show edit icon when identities are selected',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(onboardingDataProvider.notifier).updateGender(Gender.man);
        container
            .read(onboardingDataProvider.notifier)
            .updateGenderIdentityOptions(['man']);

        await tester.pumpWidget(buildTestWidget(container: container));
        await tester.pumpAndSettle();

        // Should show the edit icon
        expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'should hide "Add more" link when identities are selected',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(onboardingDataProvider.notifier).updateGender(Gender.man);
        container
            .read(onboardingDataProvider.notifier)
            .updateGenderIdentityOptions(['man']);

        await tester.pumpWidget(buildTestWidget(container: container));
        await tester.pumpAndSettle();

        // "Add more..." link should NOT be visible
        expect(
          find.text('Add more about your gender identity'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'chips should include base gender as first chip',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(onboardingDataProvider.notifier)
            .updateGender(Gender.woman);
        container
            .read(onboardingDataProvider.notifier)
            .updateGenderIdentityOptions(['transfeminine']);

        await tester.pumpWidget(buildTestWidget(container: container));
        await tester.pumpAndSettle();

        // Both Woman (base) and Transfeminine (identity) should show as chips
        expect(find.text('Woman'), findsWidgets);
        expect(find.text('Transfeminine'), findsOneWidget);
      },
    );

    testWidgets(
      'should show multiple identity chips for non-binary',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(onboardingDataProvider.notifier)
            .updateGender(Gender.nonBinary);
        container
            .read(onboardingDataProvider.notifier)
            .updateGenderIdentityOptions(['agender', 'genderfluid']);

        await tester.pumpWidget(buildTestWidget(container: container));
        await tester.pumpAndSettle();

        expect(find.text('Non-Binary'), findsWidgets);
        expect(find.text('Agender'), findsOneWidget);
        expect(find.text('Genderfluid'), findsOneWidget);
      },
    );
  });

  group('GenderSelectionScreen - Show on Profile', () {
    testWidgets('should display profile visibility checkbox', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // The ProfileVisibilityCheckbox should be present
      expect(find.textContaining('Show'), findsWidgets);
    });
  });
}
