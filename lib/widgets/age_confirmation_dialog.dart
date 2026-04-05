/// Age Confirmation Dialog
/// Shows the user's calculated age and asks them to confirm before proceeding.
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Calculates age from [birthdate] relative to [now].
int calculateAge(DateTime birthdate, {DateTime? now}) {
  final today = now ?? DateTime.now();
  var age = today.year - birthdate.year;
  if (today.month < birthdate.month ||
      (today.month == birthdate.month && today.day < birthdate.day)) {
    age--;
  }
  return age;
}

/// Shows a confirmation dialog displaying the user's age.
/// Returns `true` if the user taps **Confirm**, `false` or `null` otherwise.
Future<bool?> showAgeConfirmationDialog(
  BuildContext context, {
  required int age,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _AgeConfirmationDialog(age: age),
  );
}

class _AgeConfirmationDialog extends StatelessWidget {
  const _AgeConfirmationDialog({required this.age});

  final int age;

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
            // Title
            Text(
              'Confirm your age',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.interactive500,
              ),
            ),
            const SizedBox(height: AppSpacing.x5),

            // Age display
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.interactive400,
                ),
                children: [
                  const TextSpan(text: 'You are '),
                  TextSpan(
                    text: '$age',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.interactive500,
                    ),
                  ),
                  const TextSpan(text: ' years old'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x6),

            // Buttons row
            Row(
              children: [
                // Cancel button (outlined)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
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

                // Confirm button (gold gradient)
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius:
                          BorderRadius.circular(AppRadius.medium),
                      boxShadow: AppShadows.defaultShadow,
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
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
                        'Confirm',
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
