/// SelfieGridSlot — sixth cell in the AddPhotoScreen grid.
/// Empty: dashed brand-light border + camera icon + Playfair "Add a
/// selfie" + Inter Italic "Unlock your badge" (Figma `SelfieAddSpace`).
/// Filled: Image.file of the selfie. Tap re-opens the SelfieFlowSheet.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'platform_image.dart';

class SelfieGridSlot extends StatelessWidget {
  /// Local file path of the selfie, or null for the empty state.
  final String? selfiePath;

  /// Called when the slot is tapped (opens SelfieFlowSheet either way).
  final VoidCallback onTap;

  const SelfieGridSlot({
    super.key,
    required this.selfiePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 160,
        height: 160,
        child: selfiePath == null
            ? const _EmptySelfieSlot()
            : _FilledSelfieSlot(path: selfiePath!),
      ),
    );
  }
}

class _EmptySelfieSlot extends StatelessWidget {
  const _EmptySelfieSlot();

  @override
  Widget build(BuildContext context) {
    // Figma uses a dashed brand-light border with a faint cream-overlay
    // interior — the dashed effect needs CustomPainter since Flutter's
    // BorderSide doesn't have a dashed style natively.
    const overlayBg = Color(0x089B631C); // 3% brand-dark on cream

    return CustomPaint(
      painter: _DashedRoundedRectPainter(
        color: AppColors.brandLight,
        radius: AppRadius.medium,
        strokeWidth: 1,
        dashLength: 6,
        gapLength: 4,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: overlayBg,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: AppSpacing.x4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 32,
              color: AppColors.brandDark,
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              'Add a selfie',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.brandDark,
                height: 1.2,
              ),
            ),
            Text(
              'Unlock your badge',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.brandDark,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilledSelfieSlot extends StatelessWidget {
  final String path;
  const _FilledSelfieSlot({required this.path});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PlatformImage(path: path, fit: BoxFit.cover),
          // Soft brand-tint overlay to signal the selfie is "earned" /
          // distinct from regular photos.
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.brandLight,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for a dashed rounded-rect border. Flutter doesn't ship
/// dashed BorderSides; this is a small purpose-built painter.
class _DashedRoundedRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  const _DashedRoundedRectPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final path = Path()..addRRect(rrect);
    final dashed = _dashedPath(path, dashLength, gapLength);
    canvas.drawPath(dashed, paint);
  }

  Path _dashedPath(Path source, double dashLen, double gapLen) {
    final result = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final length = draw ? dashLen : gapLen;
        final next = (distance + length).clamp(0.0, metric.length);
        if (draw) {
          result.addPath(metric.extractPath(distance, next), Offset.zero);
        }
        distance = next;
        draw = !draw;
      }
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth ||
      old.dashLength != dashLength ||
      old.gapLength != gapLength;
}
