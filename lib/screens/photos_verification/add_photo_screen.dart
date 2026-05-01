/// AddPhotoScreen — Module 5, Step 3 of 3.
///
/// 2-column grid hosting up to 5 regular photos and 1 selfie. User
/// must add at least kMinPhotos (4) regular photos to proceed.
/// Selfie is optional but unlocks the verified badge.
///
/// Reconciled against Figma node 3939:23980 (empty state) and
/// 3939:24587 (filled). Helper text and grid layout match Figma.
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/photos_verification_models.dart';
import '../../providers/photo_picker_provider.dart';
import '../../providers/photos_verification_provider.dart';
import '../../services/photo_picker_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/add_photo_upload_popup.dart';
import '../../widgets/photo_error_popup.dart';
import '../../widgets/photo_grid_slot.dart';
import '../../widgets/selfie_grid_slot.dart';

/// Maximum file size accepted from the picker (10 MB).
const int _kMaxBytes = 10 * 1024 * 1024;

class AddPhotoScreen extends ConsumerWidget {
  const AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(
      photosVerificationDataProvider.select((d) => d.photos),
    );
    final selfiePath = ref.watch(
      photosVerificationDataProvider.select((d) => d.selfiePhotoPath),
    );
    final showHelper = photos.length < kMinPhotos;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Add your best photos',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Candid and natural photos make the best impression.',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.interactive300,
              height: 16 / 14,
            ),
          ),
          const SizedBox(height: AppSpacing.x6),

          // 2×3 grid: indices 0..4 = photos, index 5 = selfie.
          Center(
            child: Wrap(
              spacing: AppSpacing.x4, // 16px column gap
              runSpacing: AppSpacing.x8, // 32px row gap
              children: [
                for (var i = 0; i < kMaxPhotos; i++)
                  PhotoGridSlot(
                    imagePath: i < photos.length ? photos[i] : null,
                    onTap: () => _onAddPhoto(context, ref),
                    onRemove: () => _onRemovePhoto(ref, i),
                  ),
                SelfieGridSlot(
                  selfiePath: selfiePath,
                  onTap: () => _onSelfieTap(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

          if (showHelper)
            Center(
              child: Text(
                'Minimum $kMinPhotos photos required to continue.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.brandDark,
                  height: 16 / 14,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Photo handlers
  // ---------------------------------------------------------------------------

  Future<void> _onAddPhoto(BuildContext context, WidgetRef ref) async {
    final source = await showAddPhotoUploadPopUp(context);
    if (source == null || !context.mounted) return;

    final picker = ref.read(photoPickerServiceProvider);
    final result = switch (source) {
      AddPhotoSource.camera => await picker.pickFromCamera(),
      AddPhotoSource.gallery => await picker.pickFromGallery(),
    };
    if (!context.mounted) return;

    switch (result) {
      case PhotoPickSuccess(:final file):
        final ok = await _validatePhotoFile(file);
        if (!context.mounted) return;
        if (ok) {
          ref
              .read(photosVerificationDataProvider.notifier)
              .addPhoto(file.path);
        } else {
          await showPhotoErrorPopUp(context);
        }
      case PhotoPickPermissionDenied(:final permanently):
        if (permanently) {
          _showOpenSettingsBanner(context, picker);
        }
      // Cancelled / Error → no toast needed for cancel; show error popup
      // for genuine errors.
      case PhotoPickError():
        await showPhotoErrorPopUp(context);
      case PhotoPickCancelled():
        break;
    }
  }

  void _onRemovePhoto(WidgetRef ref, int index) {
    ref.read(photosVerificationDataProvider.notifier).removePhotoAt(index);
  }

  Future<void> _onSelfieTap(BuildContext context) async {
    // TODO(module5-pr-b): wire SelfieFlowSheet — added in the next
    // commit. For now this is a no-op so the screen compiles.
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns true if the file is within size + decodable.
  Future<bool> _validatePhotoFile(XFile file) async {
    final size = await file.length();
    if (size > _kMaxBytes) return false;
    try {
      final bytes = await File(file.path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final img = frame.image;
      final ok = img.width > 0 && img.height > 0;
      img.dispose();
      codec.dispose();
      return ok;
    } catch (_) {
      return false;
    }
  }

  void _showOpenSettingsBanner(
      BuildContext context, PhotoPickerService picker) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Camera/photo permission is denied. Open Settings to allow.',
          ),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: picker.openSettings,
          ),
        ),
      );
  }
}
