/// Background Progress Indicator Tests
/// Tests for BackgroundProgressIndicator widget (Education, Profession, Location, Complete)
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/widgets/background_progress_indicator.dart';

void main() {
  group('BackgroundProgressIndicator', () {
    testWidgets('should render 4 step icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      // Should have 4 Icon widgets (school, work, location, check)
      expect(find.byType(Icon), findsNWidgets(4));
    });

    testWidgets('should show correct icons for each step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      // Education = school icon
      expect(find.byIcon(Icons.school_outlined), findsOneWidget);
      // Profession = work icon
      expect(find.byIcon(Icons.work_outline), findsOneWidget);
      // Location = location icon
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
      // Complete = check icon
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

      // Root widget should be a Row
      final rowFinder = find.descendant(
        of: find.byType(BackgroundProgressIndicator),
        matching: find.byType(Row),
      );
      expect(rowFinder, findsOneWidget);
    });

    testWidgets('should have 3 progress bars between steps', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BackgroundProgressIndicator(
              currentStep: BackgroundStep.education,
            ),
          ),
        ),
      );

      // 3 Expanded widgets for progress bars
      expect(find.byType(Expanded), findsNWidgets(3));
    });

    testWidgets('education step should highlight only first icon', (tester) async {
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

      // Education icon (index 0) should be active (white color)
      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
      expect(icons[0].color, equals(Colors.white));

      // Other icons should be inactive
      expect(icons[1].color, isNot(equals(Colors.white)));
      expect(icons[2].color, isNot(equals(Colors.white)));
      expect(icons[3].color, isNot(equals(Colors.white)));
    });

    testWidgets('profession step should highlight first two icons', (tester) async {
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

      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();

      // Education (completed) and Profession (current) should be white
      expect(icons[0].color, equals(Colors.white));
      expect(icons[1].color, equals(Colors.white));

      // Location and Complete should be inactive
      expect(icons[2].color, isNot(equals(Colors.white)));
      expect(icons[3].color, isNot(equals(Colors.white)));
    });

    testWidgets('location step should highlight first three icons', (tester) async {
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

      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();

      // Education, Profession, Location should be white
      expect(icons[0].color, equals(Colors.white));
      expect(icons[1].color, equals(Colors.white));
      expect(icons[2].color, equals(Colors.white));

      // Complete should be inactive
      expect(icons[3].color, isNot(equals(Colors.white)));
    });

    testWidgets('complete step should highlight all four icons', (tester) async {
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

      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();

      // All icons should be white (active)
      for (final icon in icons) {
        expect(icon.color, equals(Colors.white));
      }
    });

    testWidgets('completed steps should show check icon instead of original',
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

      // Education (index 0) and Profession (index 1) are completed but not current,
      // so they should display check icons instead of their original icons.
      // The AnimatedSwitcher uses Icons.check when isCompleted && !isCurrent.
      // We should find multiple check icons: 2 for completed steps + 1 for the
      // complete step icon itself = 3 total check icons
      expect(find.byIcon(Icons.check), findsNWidgets(3));
    });

    testWidgets('current step icon should be larger', (tester) async {
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

      // Current step icon should be 24px, others 18px
      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();

      // Education (completed, not current) = 18
      expect(icons[0].size, equals(18));
      // Profession (current) = 24
      expect(icons[1].size, equals(24));
      // Location (not active) = 18
      expect(icons[2].size, equals(18));
      // Complete (not active) = 18
      expect(icons[3].size, equals(18));
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

      // Should have AnimatedContainers for step circles + progress bars
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

      // All AnimatedContainers should use the custom duration
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

    testWidgets('should use AnimatedSwitcher for icon transitions',
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

      // Should have AnimatedSwitcher widgets for icon transitions
      expect(find.byType(AnimatedSwitcher), findsNWidgets(4));
    });
  });
}
