/// Background Progress Indicator Tests
/// Tests for BackgroundProgressIndicator widget (Education, Profession, Location, Complete)
/// Updated to match SVG-based implementation (same pattern as onboarding/orientation)
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/widgets/background_progress_indicator.dart';

void main() {
  group('BackgroundProgressIndicator', () {
    testWidgets('should render 3 SVG icons + 1 check icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      // 3 SVG icons (Education, Profession, Location) + 1 Material check icon
      expect(find.byType(SvgPicture), findsNWidgets(3));
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should render in a horizontal Row', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      final rowFinder = find.descendant(
        of: find.byType(BackgroundProgressIndicator),
        matching: find.byType(Row),
      );
      expect(rowFinder, findsOneWidget);
    });

    testWidgets('should have AnimatedContainers for progress bars and icons',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      // SVG step containers + check step container + progress bars
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('education step should show correct SVG states',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      await tester.pump();

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
      expect(svgWidgets.length, equals(3));

      // Education = inprogress (active, not completed)
      final eduKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(eduKey, contains('EducationIcon/inprogress'));

      // Profession = incomplete
      final profKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(profKey, contains('ProfessionIcon/incomplete'));

      // Location = incomplete
      final locKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(locKey, contains('LocationIcon/incomplete'));
    });

    testWidgets('profession step should show correct SVG states',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.profession,
            ),
          ),
        ),
      );

      await tester.pump();

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // Education = completed, Profession = inprogress, Location = incomplete
      final eduKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(eduKey, contains('EducationIcon/completed'));

      final profKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(profKey, contains('ProfessionIcon/inprogress'));

      final locKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(locKey, contains('LocationIcon/incomplete'));
    });

    testWidgets('location step should show correct SVG states',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.location,
            ),
          ),
        ),
      );

      await tester.pump();

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // Education = completed, Profession = completed, Location = inprogress
      final eduKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(eduKey, contains('EducationIcon/completed'));

      final profKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(profKey, contains('ProfessionIcon/completed'));

      final locKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(locKey, contains('LocationIcon/inprogress'));
    });

    testWidgets('complete step should show all completed SVGs',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.complete,
            ),
          ),
        ),
      );

      await tester.pump();

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // All 3 SVGs should be completed
      final eduKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(eduKey, contains('EducationIcon/completed'));

      final profKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(profKey, contains('ProfessionIcon/completed'));

      final locKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(locKey, contains('LocationIcon/completed'));

      // Check icon should also be present
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should use AnimatedContainer for smooth transitions',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('should respect custom animation duration', (tester) async {
      const customDuration = Duration(milliseconds: 500);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
              animationDuration: customDuration,
            ),
          ),
        ),
      );

      await tester.pump();

      final containers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      for (final container in containers) {
        expect(container.duration, equals(customDuration));
      }
    });

    testWidgets('default animation duration should be 300ms', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      await tester.pump();

      final containers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      for (final container in containers) {
        expect(container.duration, equals(const Duration(milliseconds: 300)));
      }
    });
  });
}
