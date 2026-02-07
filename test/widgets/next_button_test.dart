/// NextButton Widget Tests
///
/// These tests verify the NextButton SVG asset switching behavior.
///
/// ## Bug Fixed (PR #2)
/// Flutter's widget reconciliation was caching SvgPicture.asset widgets.
/// When the `_assetPath` changed (e.g., from Disabled.svg to Default.svg),
/// Flutter didn't rebuild because the widget type remained identical.
///
/// ## Solution
/// Added `ValueKey(_assetPath)` to force widget reconstruction when the
/// asset path changes. This ensures the correct SVG is displayed for each
/// button state (Default, Disabled, Pressed).
///
/// ## Test Coverage
/// 1. Default state shows Default.svg
/// 2. Disabled state shows Disabled.svg
/// 3. Pressed state shows Pressed.svg
/// 4. State transitions trigger proper SVG asset changes
/// 5. Callback behavior (onPressed invoked when enabled, not when disabled)
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating_app_verification/widgets/next_button.dart';

void main() {
  group('NextButton Widget Tests', () {
    // Helper to wrap widget with MaterialApp for testing
    Widget createTestWidget({
      VoidCallback? onPressed,
      bool isDisabled = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: NextButton(
              onPressed: onPressed,
              isDisabled: isDisabled,
            ),
          ),
        ),
      );
    }

    group('SVG Asset Selection', () {
      testWidgets('displays Default.svg when enabled and not pressed',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onPressed: () {}));

        // Find the SvgPicture widget
        final svgFinder = find.byType(SvgPicture);
        expect(svgFinder, findsOneWidget);

        // Verify the ValueKey contains Default.svg path
        final svgWidget = tester.widget<SvgPicture>(svgFinder);
        expect(svgWidget.key, isA<ValueKey<String>>());
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Default.svg',
        );
      });

      testWidgets('displays Disabled.svg when isDisabled is true',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          onPressed: () {},
          isDisabled: true,
        ));

        final svgFinder = find.byType(SvgPicture);
        expect(svgFinder, findsOneWidget);

        final svgWidget = tester.widget<SvgPicture>(svgFinder);
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Disabled.svg',
        );
      });

      testWidgets('displays Disabled.svg when onPressed is null',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onPressed: null));

        final svgFinder = find.byType(SvgPicture);
        expect(svgFinder, findsOneWidget);

        final svgWidget = tester.widget<SvgPicture>(svgFinder);
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Disabled.svg',
        );
      });

      testWidgets('displays Pressed.svg during tap down',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onPressed: () {}));

        // Perform tap down (without releasing)
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(NextButton)),
        );
        await tester.pump();

        final svgFinder = find.byType(SvgPicture);
        final svgWidget = tester.widget<SvgPicture>(svgFinder);
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Pressed.svg',
        );

        // Clean up gesture
        await gesture.up();
        await tester.pump();
      });
    });

    group('State Transitions (ValueKey Fix Verification)', () {
      testWidgets(
          'SVG updates correctly when transitioning from disabled to enabled',
          (WidgetTester tester) async {
        // Start with disabled state
        await tester.pumpWidget(createTestWidget(
          onPressed: () {},
          isDisabled: true,
        ));

        var svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Disabled.svg',
          reason: 'Should show Disabled.svg initially',
        );

        // Transition to enabled state
        await tester.pumpWidget(createTestWidget(
          onPressed: () {},
          isDisabled: false,
        ));

        svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Default.svg',
          reason:
              'Should show Default.svg after enabling - ValueKey forces rebuild',
        );
      });

      testWidgets(
          'SVG updates correctly when transitioning from enabled to disabled',
          (WidgetTester tester) async {
        // Start with enabled state
        await tester.pumpWidget(createTestWidget(
          onPressed: () {},
          isDisabled: false,
        ));

        var svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Default.svg',
          reason: 'Should show Default.svg initially',
        );

        // Transition to disabled state
        await tester.pumpWidget(createTestWidget(
          onPressed: () {},
          isDisabled: true,
        ));

        svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Disabled.svg',
          reason:
              'Should show Disabled.svg after disabling - ValueKey forces rebuild',
        );
      });

      testWidgets('returns to Default.svg after tap is released',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onPressed: () {}));

        // Tap down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(NextButton)),
        );
        await tester.pump();

        var svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Pressed.svg',
          reason: 'Should show Pressed.svg during tap',
        );

        // Release tap
        await gesture.up();
        await tester.pump();

        svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Default.svg',
          reason: 'Should return to Default.svg after tap release',
        );
      });

      testWidgets('returns to Default.svg after tap is cancelled',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onPressed: () {}));

        // Tap down
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(NextButton)),
        );
        await tester.pump();

        // Cancel tap (e.g., drag away)
        await gesture.cancel();
        await tester.pump();

        final svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(
          (svgWidget.key as ValueKey<String>).value,
          'assets/images/NextButton/Default.svg',
          reason: 'Should return to Default.svg after tap cancel',
        );
      });
    });

    group('Callback Behavior', () {
      testWidgets('invokes onPressed callback when tapped and enabled',
          (WidgetTester tester) async {
        bool wasPressed = false;
        await tester.pumpWidget(createTestWidget(
          onPressed: () => wasPressed = true,
        ));

        await tester.tap(find.byType(NextButton));
        await tester.pump();

        expect(wasPressed, isTrue, reason: 'onPressed should be invoked');
      });

      testWidgets('does not invoke callback when disabled',
          (WidgetTester tester) async {
        bool wasPressed = false;
        await tester.pumpWidget(createTestWidget(
          onPressed: () => wasPressed = true,
          isDisabled: true,
        ));

        await tester.tap(find.byType(NextButton));
        await tester.pump();

        expect(wasPressed, isFalse,
            reason: 'onPressed should NOT be invoked when disabled');
      });

      testWidgets('does not invoke callback when onPressed is null',
          (WidgetTester tester) async {
        // This should not throw - just verifying graceful handling
        await tester.pumpWidget(createTestWidget(onPressed: null));

        await tester.tap(find.byType(NextButton));
        await tester.pump();

        // No exception means success
      });
    });

    group('Widget Properties', () {
      testWidgets('has correct dimensions (54x54)', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onPressed: () {}));

        final svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(svgWidget.width, 54);
        expect(svgWidget.height, 54);
      });

      testWidgets('uses BoxFit.contain', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onPressed: () {}));

        final svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect(svgWidget.fit, BoxFit.contain);
      });
    });
  });
}
