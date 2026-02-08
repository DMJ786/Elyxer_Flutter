/// Feedback Dialog
/// Modal dialog for collecting user feedback
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FeedbackDialog extends StatefulWidget {
  final String? title;
  final String? hintText;
  final int maxLines;

  const FeedbackDialog({
    super.key,
    this.title = 'Share your feedback',
    this.hintText = 'Tell us what you think...',
    this.maxLines = 4,
  });

  /// Show the feedback dialog and return the submitted feedback (or null if cancelled)
  static Future<String?> show(
    BuildContext context, {
    String? title,
    String? hintText,
    int maxLines = 4,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => FeedbackDialog(
        title: title,
        hintText: hintText,
        maxLines: maxLines,
      ),
    );
  }

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;

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
      setState(() => _isSubmitting = true);
      Navigator.of(context).pop(feedback);
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x5,
        vertical: AppSpacing.x6,
      ),
      child: Container(
        width: size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: AppShadows.defaultShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x5,
                AppSpacing.x5,
                AppSpacing.x4,
                AppSpacing.x4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title ?? 'Share your feedback',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleCancel,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.x2),
                      decoration: BoxDecoration(
                        color: AppColors.interactive50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.interactive400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: AppColors.interactive100,
            ),

            // Text Input
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: TextField(
                controller: _controller,
                maxLines: widget.maxLines,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.interactive200,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(AppSpacing.x4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    borderSide: const BorderSide(
                      color: AppColors.interactive200,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    borderSide: const BorderSide(
                      color: AppColors.interactive200,
                      width: 1,
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
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x5,
                0,
                AppSpacing.x5,
                AppSpacing.x5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: _handleCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x5,
                        vertical: AppSpacing.x3,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.interactive400,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),

                  // Submit Button with gradient
                  GestureDetector(
                    onTap: _isSubmitting ? null : _handleSubmit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x5,
                        vertical: AppSpacing.x3,
                      ),
                      decoration: BoxDecoration(
                        gradient: _isSubmitting
                            ? null
                            : AppColors.brandGradient,
                        color: _isSubmitting
                            ? AppColors.interactive200
                            : null,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        boxShadow: _isSubmitting
                            ? null
                            : AppShadows.pressedShadow,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Submit',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
