/// SelfieCaptureView — state 1 of the selfie verification flow.
///
/// Shown before the user takes a selfie. Dark full-screen with the
/// face guide overlay, conditions text, and capture/cancel/skip
/// controls. Tapping Capture opens the native camera UI (image_picker)
/// — live preview behind the guide is deferred (V2).
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/face_guide_overlay.dart';

class SelfieCaptureView extends StatelessWidget {
  /// Tapped Capture — caller invokes the picker + validator.
  final VoidCallback onCapture;

  /// Tapped Add later — close the sheet without saving.
  final VoidCallback onAddLater;

  /// Tapped × — same as Add later (separate handler so caller can
  /// distinguish between explicit close and skip if needed).
  final VoidCallback onClose;

  const SelfieCaptureView({
    super.key,
    required this.onCapture,
    required this.onAddLater,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
          child: Column(
            children: [
              // Top bar — close button only
              Align(
                alignment: Alignment.topRight,
                child: _CloseButton(onTap: onClose),
              ),
              const SizedBox(height: AppSpacing.x4),

              // Heading
              Text(
                'Take a clear selfie',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 32 / 28,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'This unlocks your verified badge.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 16 / 14,
                ),
              ),

              const Spacer(),

              // Face guide oval — instructional, not live
              const FaceGuideOverlay(),

              const SizedBox(height: AppSpacing.x6),

              // Conditions
              Text(
                'Use good lighting · Center your face · Avoid sunglasses',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white60,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Capture button — large gradient circle
              _CaptureButton(onTap: onCapture),
              const SizedBox(height: AppSpacing.x4),

              // Add later
              TextButton(
                onPressed: onAddLater,
                child: Text(
                  'Add later',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CaptureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
          border: Border.all(color: Colors.white, width: 3),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
