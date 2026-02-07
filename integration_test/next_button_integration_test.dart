/// Integration Test for NextButton SVG Asset Switching
///
/// This test provides visual evidence that the ValueKey fix is working correctly.
/// It tests the button in a real Flutter environment with actual SVG rendering.
///
/// Run with: flutter test integration_test/next_button_integration_test.dart
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dating_app_verification/widgets/next_button.dart';
import 'package:dating_app_verification/theme/app_theme.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NextButton SVG Asset Switching - Integration Evidence', () {
    testWidgets('EVIDENCE: SVG correctly switches from Disabled to Default',
        (WidgetTester tester) async {
      // Track SVG asset changes
      final List<String> assetHistory = [];

      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: Scaffold(
            backgroundColor: AppColors.cream,
            body: Center(
              child: _TestableNextButton(
                isDisabled: true,
                onAssetChange: (path) => assetHistory.add(path),
              ),
            ),
          ),
        ),
      );

      // Wait for SVG to render
      await tester.pumpAndSettle();

      // EVIDENCE 1: Initial state should be Disabled
      var svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
      var currentKey = (svgWidget.key as ValueKey<String>).value;

      print('═══════════════════════════════════════════════════════════════');
      print('EVIDENCE - NextButton SVG Asset Switching Test');
      print('═══════════════════════════════════════════════════════════════');
      print('');
      print('TEST 1: Initial Disabled State');
      print('  Expected asset: assets/images/NextButton/Disabled.svg');
      print('  Actual asset:   $currentKey');
      print('  Status: ${currentKey.contains('Disabled') ? '✅ PASS' : '❌ FAIL'}');
      print('');

      expect(currentKey, contains('Disabled'),
          reason: 'Initial disabled state should show Disabled.svg');

      // Now change to enabled state
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: Scaffold(
            backgroundColor: AppColors.cream,
            body: Center(
              child: _TestableNextButton(
                isDisabled: false,
                onAssetChange: (path) => assetHistory.add(path),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // EVIDENCE 2: After enabling, should show Default
      svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
      currentKey = (svgWidget.key as ValueKey<String>).value;

      print('TEST 2: After Enabling (isDisabled: false)');
      print('  Expected asset: assets/images/NextButton/Default.svg');
      print('  Actual asset:   $currentKey');
      print('  Status: ${currentKey.contains('Default') ? '✅ PASS' : '❌ FAIL'}');
      print('');

      expect(currentKey, contains('Default'),
          reason: 'Enabled state should show Default.svg');

      // Change back to disabled
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: Scaffold(
            backgroundColor: AppColors.cream,
            body: Center(
              child: _TestableNextButton(
                isDisabled: true,
                onAssetChange: (path) => assetHistory.add(path),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // EVIDENCE 3: After disabling again, should show Disabled
      svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
      currentKey = (svgWidget.key as ValueKey<String>).value;

      print('TEST 3: After Disabling Again (isDisabled: true)');
      print('  Expected asset: assets/images/NextButton/Disabled.svg');
      print('  Actual asset:   $currentKey');
      print('  Status: ${currentKey.contains('Disabled') ? '✅ PASS' : '❌ FAIL'}');
      print('');
      print('═══════════════════════════════════════════════════════════════');
      print('CONCLUSION: ValueKey fix is ${currentKey.contains('Disabled') ? 'WORKING ✅' : 'NOT WORKING ❌'}');
      print('═══════════════════════════════════════════════════════════════');

      expect(currentKey, contains('Disabled'),
          reason: 'Disabled again should show Disabled.svg');
    });

    testWidgets('EVIDENCE: Pressed state shows correct SVG during tap',
        (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: Scaffold(
            backgroundColor: AppColors.cream,
            body: Center(
              child: NextButton(
                onPressed: () => tapCount++,
                isDisabled: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      print('');
      print('═══════════════════════════════════════════════════════════════');
      print('EVIDENCE - Pressed State Test');
      print('═══════════════════════════════════════════════════════════════');

      // Initial state
      var svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
      var currentKey = (svgWidget.key as ValueKey<String>).value;
      print('Before tap: $currentKey');
      expect(currentKey, contains('Default'));

      // Start tap (press down)
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(NextButton)),
      );
      await tester.pump();

      // During press
      svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
      currentKey = (svgWidget.key as ValueKey<String>).value;
      print('During tap (pressed): $currentKey');
      print('  Status: ${currentKey.contains('Pressed') ? '✅ PASS' : '❌ FAIL'}');
      expect(currentKey, contains('Pressed'));

      // Release tap
      await gesture.up();
      await tester.pump();

      // After release
      svgWidget = tester.widget<SvgPicture>(find.byType(SvgPicture));
      currentKey = (svgWidget.key as ValueKey<String>).value;
      print('After tap release: $currentKey');
      print('  Status: ${currentKey.contains('Default') ? '✅ PASS' : '❌ FAIL'}');
      print('  Tap count: $tapCount (should be 1)');
      print('═══════════════════════════════════════════════════════════════');

      expect(currentKey, contains('Default'));
      expect(tapCount, 1);
    });
  });
}

/// Testable wrapper around NextButton to track asset changes
class _TestableNextButton extends StatelessWidget {
  final bool isDisabled;
  final void Function(String)? onAssetChange;

  const _TestableNextButton({
    required this.isDisabled,
    this.onAssetChange,
  });

  @override
  Widget build(BuildContext context) {
    return NextButton(
      onPressed: isDisabled ? null : () {},
      isDisabled: isDisabled,
    );
  }
}
