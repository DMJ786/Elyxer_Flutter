/// FaceGuideOverlay — instructional dashed-oval guide shown during the
/// selfie capture state. With native camera UI (no live preview), this
/// oval is shown *before* the user taps Capture so they know roughly
/// where to position their face when the OS camera opens.
///
/// Geometry per Figma: 240×300 oval, 60px border-radius (matches the
/// oval ratio when overlaid on the centered area).
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FaceGuideOverlay extends StatelessWidget {
  final double width;
  final double height;

  const FaceGuideOverlay({
    super.key,
    this.width = 240,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _FaceOvalPainter(),
      ),
    );
  }
}

class _FaceOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Inner oval — solid 1.5px brand-light stroke.
    final innerPaint = Paint()
      ..color = AppColors.brandLight
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final innerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawOval(innerRect, innerPaint);

    // Outer dashed oval — 8px outside the inner, slightly heavier feel.
    final outerRect = innerRect.inflate(8);
    final outerPath = Path()..addOval(outerRect);
    final dashed = _dashedPath(outerPath, dashLen: 6, gapLen: 4);
    final outerPaint = Paint()
      ..color = AppColors.brandLight
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawPath(dashed, outerPaint);
  }

  Path _dashedPath(Path source, {required double dashLen, required double gapLen}) {
    final out = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final length = draw ? dashLen : gapLen;
        final next = (distance + length).clamp(0.0, metric.length);
        if (draw) {
          out.addPath(metric.extractPath(distance, next), Offset.zero);
        }
        distance = next;
        draw = !draw;
      }
    }
    return out;
  }

  @override
  bool shouldRepaint(covariant _FaceOvalPainter oldDelegate) => false;
}
