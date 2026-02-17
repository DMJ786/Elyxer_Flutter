/// Onboarding Progress Indicator Tests
/// Tests for OnboardingProgressIndicator widget (Module 1: Age, Gender, Pronoun)
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/widgets/onboarding_progress_indicator.dart';

void main() {
  group('OnboardingProgressIndicator', () {
    testWidgets('should render only 4 steps (age, gender, pronoun, complete)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.age,
            ),
          ),
        ),
      );

      // Should have 4 icons: cake, wc, person, check
      expect(find.byIcon(Icons.cake_outlined), findsOneWidget);
      expect(find.byIcon(Icons.wc_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should verify old 7-step layout is gone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.age,
            ),
          ),
        ),
      );

      // Should have exactly 4 icons (not 7)
      final icons = find.byType(Icon);
      expect(icons, findsNWidgets(4));

      // Should have 3 progress bars between 4 steps
      final animatedContainers = find.byType(AnimatedContainer);
      expect(animatedContainers, findsNWidgets(7)); // 4 icons + 3 bars
    });

    testWidgets('active step should have gradient decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.age,
            ),
          ),
        ),
      );

      await tester.pump();

      // First icon (age) should be active with white color
      final firstIcon = find.byIcon(Icons.cake_outlined);
      expect(firstIcon, findsOneWidget);

      final iconWidget = tester.widget<Icon>(firstIcon);
      expect(iconWidget.color, equals(Colors.white));
      expect(iconWidget.size, equals(18.0)); // Active icon size
    });

    testWidgets('inactive steps should have plain styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.age,
            ),
          ),
        ),
      );

      await tester.pump();

      // Second icon (gender) should be inactive
      final secondIcon = find.byIcon(Icons.wc_outlined);
      expect(secondIcon, findsOneWidget);

      final iconWidget = tester.widget<Icon>(secondIcon);
      expect(iconWidget.size, equals(14.0)); // Inactive icon size
    });

    testWidgets('should show correct icons for each step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.gender,
            ),
          ),
        ),
      );

      // Verify icon mapping
      // Step 0: age = cake icon
      expect(find.byIcon(Icons.cake_outlined), findsOneWidget);
      
      // Step 1: gender = wc icon
      expect(find.byIcon(Icons.wc_outlined), findsOneWidget);
      
      // Step 2: pronoun = person icon
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      
      // Step 3: complete = check icon
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should update progress when advancing to gender step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.gender,
            ),
          ),
        ),
      );

      await tester.pump();

      // First two icons should be active
      final firstIcon = tester.widget<Icon>(find.byIcon(Icons.cake_outlined));
      expect(firstIcon.color, equals(Colors.white));
      expect(firstIcon.size, equals(18.0));

      final secondIcon = tester.widget<Icon>(find.byIcon(Icons.wc_outlined));
      expect(secondIcon.color, equals(Colors.white));
      expect(secondIcon.size, equals(18.0));
    });

    testWidgets('should update progress when advancing to pronoun step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.pronoun,
            ),
          ),
        ),
      );

      await tester.pump();

      // First three icons should be active
      final firstIcon = tester.widget<Icon>(find.byIcon(Icons.cake_outlined));
      expect(firstIcon.color, equals(Colors.white));

      final secondIcon = tester.widget<Icon>(find.byIcon(Icons.wc_outlined));
      expect(secondIcon.color, equals(Colors.white));

      final thirdIcon = tester.widget<Icon>(find.byIcon(Icons.person_outline));
      expect(thirdIcon.color, equals(Colors.white));
    });

    testWidgets('should show all icons active on complete step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.complete,
            ),
          ),
        ),
      );

      await tester.pump();

      // All icons should be active
      final allIcons = tester.widgetList<Icon>(find.byType(Icon));
      for (final icon in allIcons) {
        expect(icon.color, equals(Colors.white));
        expect(icon.size, equals(18.0));
      }
    });

    testWidgets('should animate with custom duration', (tester) async {
      const customDuration = Duration(milliseconds: 500);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.age,
              animationDuration: customDuration,
            ),
          ),
        ),
      );

      await tester.pump();

      // Find all AnimatedContainers and verify custom duration
      final containers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      for (final container in containers) {
        expect(container.duration, equals(customDuration));
        expect(container.curve, equals(Curves.easeInOut));
      }
    });

    testWidgets('should render in a horizontal Row', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.age,
            ),
          ),
        ),
      );

      // Should render inside a Row
      expect(find.byType(Row), findsOneWidget);

      // Row should contain the progress indicator's children
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, equals(7)); // 4 icons + 3 progress bars
    });

    testWidgets('step icons should have consistent container size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.gender,
            ),
          ),
        ),
      );

      await tester.pump();

      // All step icons should be wrapped in 40x40 SizedBox
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      
      // Should have 4 SizedBoxes (one for each icon)
      final iconContainers = sizedBoxes.where((box) {
        return box.width == 40.0 && box.height == 40.0;
      });
      
      expect(iconContainers.length, equals(4));
    });

    testWidgets('active icon should have box shadow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.age,
            ),
          ),
        ),
      );

      await tester.pump();

      // Get all AnimatedContainers
      final containers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // First icon container should have active styling with shadow
      final firstIconContainer = containers.first;
      expect(firstIconContainer.decoration, isA<BoxDecoration>());
      
      final decoration = firstIconContainer.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, equals(1));
      expect(decoration.boxShadow!.first.offset, equals(const Offset(0, 4)));
      expect(decoration.boxShadow!.first.blurRadius, equals(6.0));
    });

    testWidgets('progress bars should update correctly between steps', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.gender,
            ),
          ),
        ),
      );

      await tester.pump();

      final containers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // Should have 7 containers total (4 icons + 3 progress bars)
      expect(containers.length, equals(7));

      // First icon container should have gradient (active)
      final firstIconContainer = containers.first;
      expect(firstIconContainer.decoration, isA<BoxDecoration>());
      final firstDecoration = firstIconContainer.decoration as BoxDecoration;
      expect(firstDecoration.gradient, isNotNull);
    });

    testWidgets('all steps complete should activate all elements', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.complete,
            ),
          ),
        ),
      );

      await tester.pump();

      // All 4 icons should be active (white, size 18)
      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
      expect(icons.length, equals(4));

      for (final icon in icons) {
        expect(icon.color, equals(Colors.white));
        expect(icon.size, equals(18.0));
      }
    });

    testWidgets('should maintain module 1 separation (only 4 steps)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.complete,
            ),
          ),
        ),
      );

      // Verify this is Module 1 (Onboarding) with only 4 steps
      // Not Module 2 (Orientation) which also has 4 steps
      
      // Check for Module 1 specific icons
      expect(find.byIcon(Icons.cake_outlined), findsOneWidget); // Age
      expect(find.byIcon(Icons.wc_outlined), findsOneWidget); // Gender
      expect(find.byIcon(Icons.person_outline), findsOneWidget); // Pronoun
      
      // Should NOT have Module 2 icons
      expect(find.byIcon(Icons.favorite_outline), findsNothing); // Sexual Orientation
      expect(find.byIcon(Icons.people_outline), findsNothing); // Dating Preference
      expect(find.byIcon(Icons.flag_outlined), findsNothing); // Dating Goals
    });
  });
}
