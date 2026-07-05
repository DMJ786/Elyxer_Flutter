/// SelfieRejectionView — state 2 of the selfie verification flow.
///
/// Shown when the captured selfie fails validation (ML Kit reasons or
/// generic file/picker errors). Reason-specific copy comes from
/// SelfieRejectionReason.displayMessage. The attempted photo is shown
/// blurred behind the rejection messaging.
library;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/selfie_validator_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/platform_image.dart';

class SelfieRejectionView extends StatelessWidget {
  /// The attempted selfie (may be null if the failure was a picker
  /// error before any file was returned).
  final XFile? attemptedFile;

  /// Specific reason — null when the failure was a picker/file error
  /// rather than an ML rejection. Shows generic copy when null.
  final SelfieRejectionReason? reason;

  /// Tap Retake → caller resets to capture state.
  final VoidCallback onRetake;

  /// Tap Add later → caller closes the sheet without saving.
  final VoidCallback onAddLater;

  const SelfieRejectionView({
    super.key,
    required this.attemptedFile,
    required this.reason,
    required this.onRetake,
    required this.onAddLater,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred attempted photo as background — falls through to a
        // black scrim if no file is available.
        if (attemptedFile != null)
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: PlatformImage(
              path: attemptedFile!.path,
              fit: BoxFit.cover,
            ),
          ),
        ColoredBox(color: Colors.black.withValues(alpha: 0.65)),

        // Foreground content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.x14),
                Text(
                  'We are unable to use this selfie',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.25,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  reason?.displayMessage ??
                      "Something went wrong. Let's try again.",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: _OutlinedAction(
                        label: 'Add later',
                        onTap: onAddLater,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _GradientAction(
                        label: 'Retake',
                        onTap: onRetake,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x6),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlinedAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
