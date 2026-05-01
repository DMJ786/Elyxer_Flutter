/// Widget tests for SelfieCaptureView — copy + callback dispatch.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/screens/photos_verification/selfie_capture_view.dart';
import 'package:dating_app_verification/widgets/face_guide_overlay.dart';

void main() {
  setUp(() {
    // Capture view is laid out for full phone screens (face guide
    // 300px + Spacers + capture button stack >600px). Default test
    // viewport is 800x600 — set a taller phone-shaped surface.
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUpAll(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.implicitView!;
    view.physicalSize = const Size(400, 900);
    view.devicePixelRatio = 1.0;
  });

  tearDownAll(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.implicitView!;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  Widget host({
    required VoidCallback onCapture,
    required VoidCallback onAddLater,
    required VoidCallback onClose,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SelfieCaptureView(
          onCapture: onCapture,
          onAddLater: onAddLater,
          onClose: onClose,
        ),
      ),
    );
  }

  testWidgets('renders heading, conditions, and face guide', (tester) async {
    await tester.pumpWidget(host(
      onCapture: () {},
      onAddLater: () {},
      onClose: () {},
    ));
    expect(find.text('Take a clear selfie'), findsOneWidget);
    expect(find.text('This unlocks your verified badge.'), findsOneWidget);
    expect(find.byType(FaceGuideOverlay), findsOneWidget);
    expect(
      find.text(
          'Use good lighting · Center your face · Avoid sunglasses'),
      findsOneWidget,
    );
    expect(find.text('Add later'), findsOneWidget);
  });

  testWidgets('tapping the capture button dispatches onCapture',
      (tester) async {
    var captures = 0;
    await tester.pumpWidget(host(
      onCapture: () => captures++,
      onAddLater: () {},
      onClose: () {},
    ));
    await tester.tap(find.byIcon(Icons.camera_alt));
    expect(captures, 1);
  });

  testWidgets('Add later dispatches onAddLater', (tester) async {
    var skips = 0;
    await tester.pumpWidget(host(
      onCapture: () {},
      onAddLater: () => skips++,
      onClose: () {},
    ));
    await tester.tap(find.text('Add later'));
    expect(skips, 1);
  });

  testWidgets('close button dispatches onClose', (tester) async {
    var closes = 0;
    await tester.pumpWidget(host(
      onCapture: () {},
      onAddLater: () {},
      onClose: () => closes++,
    ));
    await tester.tap(find.byIcon(Icons.close));
    expect(closes, 1);
  });
}
