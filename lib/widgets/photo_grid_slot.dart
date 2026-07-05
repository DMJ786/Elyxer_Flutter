/// PhotoGridSlot — single 160×160 cell in the AddPhotoScreen 2×3 grid.
/// Empty: cream-overlay bg + brand-overlay border + plus icon (Figma
/// `PhotoAddSpace`). Filled: Image.file + × delete top-right.
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'platform_image.dart';

class PhotoGridSlot extends StatelessWidget {
  /// Local file path of the photo, or null for the empty state.
  final String? imagePath;

  /// Called when the empty slot is tapped (open picker).
  final VoidCallback onTap;

  /// Called when the × button on a filled slot is tapped.
  final VoidCallback onRemove;

  const PhotoGridSlot({
    super.key,
    required this.imagePath,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) return _EmptySlot(onTap: onTap);
    return _FilledSlot(imagePath: imagePath!, onRemove: onRemove);
  }
}

class _EmptySlot extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptySlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Figma color tokens (rgba(155,99,28,…)) are slightly different from
    // brandDark — these are the explicit overlay tokens for empty slots.
    const overlayBg = Color(0x089B631C); // brandDark @ 3.1%
    const overlayBorder = Color(0x149B631C); // brandDark @ 8%

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: overlayBg,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: overlayBorder, width: 1),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.add,
          size: 24,
          color: AppColors.brandDark,
        ),
      ),
    );
  }
}

class _FilledSlot extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRemove;

  const _FilledSlot({required this.imagePath, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: PlatformImage(
            path: imagePath,
            width: 160,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: AppSpacing.x1,
          right: AppSpacing.x1,
          child: GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
