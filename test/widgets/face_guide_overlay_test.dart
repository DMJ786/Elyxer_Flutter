/// Structural test for FaceGuideOverlay (no golden — pixel-perfect
/// goldens are deferred since CI runs Linux and dev runs Windows; the
/// painter is small enough that structural assertions catch
/// regressions).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/widgets/face_guide_overlay.dart';

void main() {
  testWidgets('default size is 240x300', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Center(child: FaceGuideOverlay())),
    ));
    final size = tester.getSize(find.byType(FaceGuideOverlay));
    expect(size.width, 240);
    expect(size.height, 300);
  });

  testWidgets('respects custom width/height', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: FaceGuideOverlay(width: 200, height: 250),
        ),
      ),
    ));
    final size = tester.getSize(find.byType(FaceGuideOverlay));
    expect(size.width, 200);
    expect(size.height, 250);
  });

  testWidgets('renders a CustomPaint inside', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Center(child: FaceGuideOverlay())),
    ));
    expect(
      find.descendant(
        of: find.byType(FaceGuideOverlay),
        matching: find.byType(CustomPaint),
      ),
      findsAtLeastNWidgets(1),
    );
  });
}
