/// SelfieConfirmationView — state 3 of the selfie verification flow.
///
/// Shown after a captured selfie passes validation. User reviews their
/// own photo and chooses Submit (saves it as the final selfie) or
/// Retake (returns to capture state).
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/app_theme.dart';

class SelfieConfirmationView extends StatelessWidget {
  /// The validated selfie file the user is reviewing.
  final XFile selfieFile;

  /// Tap Retake → caller resets to capture state.
  final VoidCallback onRetake;

  /// Tap Submit → caller saves selfie + closes the sheet.
  final VoidCallback onSubmit;

  const SelfieConfirmationView({
    super.key,
    required this.selfieFile,
    required this.onRetake,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.x14),
              Text(
                'Confirm your selfie',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 32 / 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Please review your photo and submit to proceed.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x6),

              // Preview — large, rounded, centered
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    child: Image.file(
                      File(selfieFile.path),
                      width: 280,
                      height: 360,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x4),
              Text(
                'This photo will be visible on your profile.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white60,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x4),

              Row(
                children: [
                  Expanded(
                    child: _OutlinedAction(
                      label: 'Retake',
                      onTap: onRetake,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _GradientAction(
                      label: 'Submit',
                      onTap: onSubmit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x6),
            ],
          ),
        ),
      ),
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
