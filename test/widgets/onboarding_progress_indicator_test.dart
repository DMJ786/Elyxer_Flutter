/// Onboarding Progress Indicator Tests
/// Tests for OnboardingProgressIndicator widget (Module 1: Age, Gender, Pronoun)
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/widgets/onboarding_progress_indicator.dart';

void main() {
  group('OnboardingProgressIndicator', () {
    testWidgets('should render 4 steps (3 SVG icons + 1 check icon)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.age,
            ),
          ),
        ),
      );

      // Should have 3 SVG icons (Age, Gender, Pronoun) + 1 Material check icon
      expect(find.byType(SvgPicture), findsNWidgets(3));
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

      // Should have exactly 1 Material icon (check only)
      final icons = find.byType(Icon);
      expect(icons, findsNWidgets(1));

      // Should have 3 SVG icons
      expect(find.byType(SvgPicture), findsNWidgets(3));
    });

    testWidgets('age step should show inprogress SVG on age step',
        (tester) async {
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

      // First SVG should be the inprogress Age icon
      final svgWidgets = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
      expect(svgWidgets.length, equals(3));

      // Age icon should be inprogress (active, not completed)
      final ageKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(ageKey, contains('AgeIcon/inprogress'));

      // Gender and Pronoun should be incomplete
      final genderKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(genderKey, contains('GenderIcon/incomplete'));

      final pronounKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(pronounKey, contains('PronounIcon/incomplete'));
    });

    testWidgets('should show correct SVG states for gender step',
        (tester) async {
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

      final svgWidgets = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // Age = completed, Gender = inprogress, Pronoun = incomplete
      final ageKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(ageKey, contains('AgeIcon/completed'));

      final genderKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(genderKey, contains('GenderIcon/inprogress'));

      final pronounKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(pronounKey, contains('PronounIcon/incomplete'));
    });

    testWidgets('should show correct SVG states for pronoun step',
        (tester) async {
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

      final svgWidgets = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // Age = completed, Gender = completed, Pronoun = inprogress
      final ageKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(ageKey, contains('AgeIcon/completed'));

      final genderKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(genderKey, contains('GenderIcon/completed'));

      final pronounKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(pronounKey, contains('PronounIcon/inprogress'));
    });

    testWidgets('all steps complete should show completed SVGs',
        (tester) async {
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

      final svgWidgets = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // All 3 SVGs should be completed
      final ageKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(ageKey, contains('AgeIcon/completed'));

      final genderKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(genderKey, contains('GenderIcon/completed'));

      final pronounKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(pronounKey, contains('PronounIcon/completed'));

      // Check icon should also be present and active
      expect(find.byIcon(Icons.check), findsOneWidget);
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

    testWidgets('step icons should have consistent container size',
        (tester) async {
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

      // All step icons should be wrapped in consistently-sized SizedBox
      // In test env (800px width): containerSize = (800 * 0.15).clamp(48, 70) = 70
      final expectedSize = (800.0 * 0.15).clamp(48.0, 70.0);
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));

      // Should have at least 4 SizedBoxes of containerSize (one for each icon)
      final iconContainers = sizedBoxes.where((box) {
        return box.width == expectedSize && box.height == expectedSize;
      });

      expect(iconContainers.length, greaterThanOrEqualTo(4));
    });

    testWidgets('should not contain orientation module icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingProgressIndicator(
              currentStep: OnboardingStep.complete,
            ),
          ),
        ),
      );

      // Should NOT have Module 2 (orientation) icons
      expect(find.byIcon(Icons.favorite_outline), findsNothing);
      expect(find.byIcon(Icons.people_outline), findsNothing);
      expect(find.byIcon(Icons.flag_outlined), findsNothing);
    });
  });
}
