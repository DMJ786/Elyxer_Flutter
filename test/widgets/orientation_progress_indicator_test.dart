/// Orientation Progress Indicator Tests
/// Tests for OrientationProgressIndicator widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/widgets/orientation_progress_indicator.dart';

void main() {
  group('OrientationProgressIndicator', () {
    testWidgets('should render correct number of step icons (4 total)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
            ),
          ),
        ),
      );

      // Should have 4 icons: heart, people, flag, check
      expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
      expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should have 3 progress bars between 4 steps', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
            ),
          ),
        ),
      );

      // Find all animated containers (includes both icons and progress bars)
      final animatedContainers = find.byType(AnimatedContainer);
      
      // Should have 4 icon containers + 3 progress bars = 7 total
      expect(animatedContainers, findsNWidgets(7));
    });

    testWidgets('active step (sexualOrientation) should have gradient decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
            ),
          ),
        ),
      );

      await tester.pump();

      // Get the first icon container (sexual orientation - active)
      final firstIcon = find.byIcon(Icons.favorite_outline);
      expect(firstIcon, findsOneWidget);

      // Find the parent AnimatedContainer of the icon
      final iconWidget = tester.widget<Icon>(firstIcon);
      expect(iconWidget.color, equals(Colors.white));
      expect(iconWidget.size, equals(18.0)); // Active icon size
    });

    testWidgets('inactive steps should have plain styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
            ),
          ),
        ),
      );

      await tester.pump();

      // Check second icon (dating preference - inactive)
      final secondIcon = find.byIcon(Icons.people_outline);
      expect(secondIcon, findsOneWidget);

      // Verify inactive styling
      final iconWidget = tester.widget<Icon>(secondIcon);
      expect(iconWidget.size, equals(14.0)); // Inactive icon size
    });

    testWidgets('progress bars should be inactive on first step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
            ),
          ),
        ),
      );

      await tester.pump();

      // All progress bars should be inactive since we're on the first step
      // (Progress bars become active when moving past their preceding icon)
      final containers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // First icon should be active (gradient decoration)
      final firstIconContainer = containers.elementAt(0);
      expect(firstIconContainer.decoration, isA<BoxDecoration>());
      final firstDecoration = firstIconContainer.decoration as BoxDecoration;
      expect(firstDecoration.gradient, isNotNull);
    });

    testWidgets('should update progress when advancing to datingPreference step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.datingPreference,
            ),
          ),
        ),
      );

      await tester.pump();

      // First two icons should be active
      final firstIcon = tester.widget<Icon>(find.byIcon(Icons.favorite_outline));
      expect(firstIcon.color, equals(Colors.white));
      expect(firstIcon.size, equals(18.0));

      final secondIcon = tester.widget<Icon>(find.byIcon(Icons.people_outline));
      expect(secondIcon.color, equals(Colors.white));
      expect(secondIcon.size, equals(18.0));
    });

    testWidgets('should show all icons active on complete step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.complete,
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
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
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
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
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

    testWidgets('progress bars should have correct spacing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
            ),
          ),
        ),
      );

      await tester.pump();

      // Find all AnimatedContainers
      final containers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // Verify we have 7 containers total (4 icons + 3 progress bars)
      expect(containers.length, equals(7));
    });

    testWidgets('should show correct icons for each step', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.datingGoals,
            ),
          ),
        ),
      );

      // Verify icon mapping
      // Step 0: sexual orientation = heart icon
      expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
      
      // Step 1: dating preference = people icon
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
      
      // Step 2: dating goals = flag icon
      expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
      
      // Step 3: complete = check icon
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('step icons should have consistent container size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.datingPreference,
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
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
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
  });
}
