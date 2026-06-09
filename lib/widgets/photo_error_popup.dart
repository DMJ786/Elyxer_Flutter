/// PhotoErrorPopUp — dialog shown when an uploaded photo fails our
/// guidelines check (file too large, decode failure, format
/// unsupported). Single OK gradient button to dismiss.
///
/// Triggered from AddPhotoScreen after file validation. NSFW filtering
/// is a future enhancement — would also dispatch to this popup.
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

Future<void> showPhotoErrorPopUp(BuildContext context, {String? message}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _PhotoErrorDialog(message: message),
  );
}

class _PhotoErrorDialog extends StatelessWidget {
  final String? message;
  const _PhotoErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x6,
          AppSpacing.x6,
          AppSpacing.x6,
          AppSpacing.x5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Some photos did not meet our guidelines and were removed',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.interactive500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              message ?? 'Please upload a different photo to continue.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.interactive400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x6),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                boxShadow: AppShadows.defaultShadow,
              ),
              child: SizedBox(
                width: 130,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.x3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  child: Text(
                    'Ok',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
