/// Orientation Progress Indicator Tests
/// Tests for OrientationProgressIndicator widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/widgets/orientation_progress_indicator.dart';

void main() {
  group('OrientationProgressIndicator', () {
    // Suppress Flutter engine layer compositing errors that occur in test
    // environment with SVG + AnimatedContainer rendering.
    late void Function(FlutterErrorDetails)? originalOnError;

    setUp(() {
      originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        final message = details.exceptionAsString();
        if (message.contains('_debugWasUsedAsOldLayer')) {
          // Known Flutter engine issue in test environment — ignore.
          return;
        }
        // Forward other errors to the original handler.
        originalOnError?.call(details);
      };
    });

    tearDown(() {
      FlutterError.onError = originalOnError;
    });
    testWidgets('should render correct number of step icons (4 SVG icons)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.sexualOrientation,
            ),
          ),
        ),
      );

      // Should have 4 SVG icons (SexualOrientation, DatingPreference, DatingGoal, Complete/Thankyou)
      expect(find.byType(SvgPicture), findsNWidgets(4));
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

    testWidgets('first step should show correct SVG states', (tester) async {
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

      final svgWidgets = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
      expect(svgWidgets.length, equals(4));

      // SexualOrientation = inprogress
      final soKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(soKey, contains('SexualOrientationIcon/inprogress'));

      // DatingPreference = incomplete
      final dpKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(dpKey, contains('DatingPreferenceIcon/incomplete'));

      // DatingGoal = incomplete
      final dgKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(dgKey, contains('DatingGoalIcon/incomplete'));
    });

    testWidgets('should show correct SVG states for datingPreference step',
        (tester) async {
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

      final svgWidgets = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // SexualOrientation = completed
      final soKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(soKey, contains('SexualOrientationIcon/completed'));

      // DatingPreference = inprogress
      final dpKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(dpKey, contains('DatingPreferenceIcon/inprogress'));

      // DatingGoal = incomplete
      final dgKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(dgKey, contains('DatingGoalIcon/incomplete'));
    });

    testWidgets('should show correct SVG states for datingGoals step',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrientationProgressIndicator(
              currentStep: OrientationStep.datingGoals,
            ),
          ),
        ),
      );

      await tester.pump();

      final svgWidgets = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // SexualOrientation = completed
      final soKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(soKey, contains('SexualOrientationIcon/completed'));

      // DatingPreference = completed
      final dpKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(dpKey, contains('DatingPreferenceIcon/completed'));

      // DatingGoal = inprogress
      final dgKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(dgKey, contains('DatingGoalIcon/inprogress'));
    });

    testWidgets('complete step should show all completed SVGs', (tester) async {
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

      final svgWidgets = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();

      // SexualOrientation = completed
      final soKey = (svgWidgets[0].key as ValueKey<String>).value;
      expect(soKey, contains('SexualOrientationIcon/completed'));

      // DatingPreference = completed
      final dpKey = (svgWidgets[1].key as ValueKey<String>).value;
      expect(dpKey, contains('DatingPreferenceIcon/completed'));

      // DatingGoal = completed
      final dgKey = (svgWidgets[2].key as ValueKey<String>).value;
      expect(dgKey, contains('DatingGoalIcon/completed'));

      // Complete step = ThankyouIcon
      final thankyouKey = (svgWidgets[3].key as ValueKey<String>).value;
      expect(thankyouKey, contains('ThankyouIcon'));
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

    testWidgets('step icons should have consistent container size',
        (tester) async {
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
  });
}
