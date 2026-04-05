/// Feedback Dialog & Thank You Dialog
/// Modal dialogs for collecting user feedback and confirming submission.
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Feedback Dialog
// ---------------------------------------------------------------------------

class FeedbackDialog extends StatefulWidget {
  final String? title;
  final String? hintText;
  final int maxLines;

  const FeedbackDialog({
    super.key,
    this.title = 'Share your feedback',
    this.hintText = 'Add your Thoughts...',
    this.maxLines = 4,
  });

  /// Show the feedback dialog and return the submitted feedback text
  /// (or null if cancelled).
  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const FeedbackDialog(),
    );
  }

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final feedback = _controller.text.trim();
    if (feedback.isNotEmpty) {
      Navigator.of(context).pop(feedback);
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
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
            // Title
            Text(
              widget.title ?? 'Share your feedback',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.interactive500,
              ),
            ),
            const SizedBox(height: AppSpacing.x5),

            // Text Input
            TextField(
              controller: _controller,
              maxLines: widget.maxLines,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.interactive200,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(AppSpacing.x4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  borderSide: const BorderSide(
                    color: AppColors.interactive100,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  borderSide: const BorderSide(
                    color: AppColors.interactive100,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  borderSide: const BorderSide(
                    color: AppColors.brandDark,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x5),

            // Buttons row — Cancel | Submit
            Row(
              children: [
                // Cancel button (outlined)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.x3,
                      ),
                      side: const BorderSide(
                        color: AppColors.interactive200,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.medium),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.interactive500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),

                // Submit button (gradient)
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius:
                          BorderRadius.circular(AppRadius.medium),
                      boxShadow: AppShadows.defaultShadow,
                    ),
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
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
                        'Submit',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Thank-You Dialog — shown after feedback is submitted.
// Auto-dismisses after 2 seconds. Tap to dismiss earlier.
// ---------------------------------------------------------------------------

class ThankYouDialog extends StatelessWidget {
  const ThankYouDialog({super.key});

  /// Convenience method to display the dialog.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        // Auto-close after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        });
        return const ThankYouDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x8,
          vertical: AppSpacing.x8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gold-bordered checkmark circle
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.brandDark,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: AppColors.brandDark,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x5),

            // Heading
            Text(
              'Thank you',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.brandDark,
              ),
            ),
            const SizedBox(height: AppSpacing.x3),

            // Subtitle
            Text(
              'Your feedback helps us improve Elyxer.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.interactive300,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
