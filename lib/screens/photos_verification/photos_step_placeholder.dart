/// Photos Step Placeholder (PR A scope)
/// Temporary screen shown while PR B implements the real AddPhotoScreen,
/// camera/gallery flow, and 3-state selfie verification.
///
/// This file will be deleted in PR B.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class PhotosStepPlaceholder extends StatelessWidget {
  const PhotosStepPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_camera_outlined,
            size: 64,
            color: AppColors.interactive300,
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Photos & Selfie Verification',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Coming in the next update — '
            'add up to 5 photos and a verified selfie to unlock your badge.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.interactive300,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
