/// AddPhotoUploadPopUp — modal bottom sheet shown when the user taps
/// an empty PhotoGridSlot. Presents two options: take a photo with the
/// camera, or upload one from the gallery.
///
/// Returns the selected source via the Future from showAddPhotoUploadPopUp.
/// Caller is responsible for dispatching to PhotoPickerService.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Source the user picked, or null if they dismissed the sheet.
enum AddPhotoSource { camera, gallery }

Future<AddPhotoSource?> showAddPhotoUploadPopUp(BuildContext context) {
  return showModalBottomSheet<AddPhotoSource>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: false,
    builder: (_) => const _AddPhotoUploadSheet(),
  );
}

class _AddPhotoUploadSheet extends StatelessWidget {
  const _AddPhotoUploadSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x6,
        AppSpacing.x6,
        AppSpacing.x6,
        AppSpacing.x8,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.x4),
              decoration: BoxDecoration(
                color: AppColors.interactive100,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Take a photo (gradient gold)
            _GradientButton(
              icon: Icons.camera_alt_outlined,
              label: 'Take a photo',
              onTap: () => Navigator.of(context).pop(AddPhotoSource.camera),
            ),
            const SizedBox(height: AppSpacing.x4),
            // Upload a photo (outlined)
            _OutlinedButton(
              icon: Icons.photo_library_outlined,
              label: 'Upload a photo',
              onTap: () => Navigator.of(context).pop(AddPhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GradientButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: [
            BoxShadow(
              color: const Color(0x80666666),
              offset: const Offset(0, 2),
              blurRadius: 3,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OutlinedButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cream,
          border: Border.all(color: AppColors.interactive500, width: 1),
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: [
            BoxShadow(
              color: const Color(0x80666666),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.interactive500, size: 20),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.interactive500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
