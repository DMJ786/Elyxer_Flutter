/// Gender Identity Selection Panel
/// Slides in from the right to show sub-options for the selected gender
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/feedback_dialog.dart';

/// Shows the gender identity selection panel sliding in from the right.
/// Uses [showGeneralDialog] so the overlay is visible to GoRouter's
/// back-button and deep-link handling (no raw Navigator.push).
Future<void> showGenderIdentitySheet(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Gender Identity',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _GenderIdentityPanel();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // Slide from right
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class _GenderIdentityPanel extends ConsumerStatefulWidget {
  const _GenderIdentityPanel();

  @override
  ConsumerState<_GenderIdentityPanel> createState() =>
      _GenderIdentityPanelState();
}

class _GenderIdentityPanelState extends ConsumerState<_GenderIdentityPanel> {
  List<String> _selectedOptionIds = [];

  @override
  void initState() {
    super.initState();
    _selectedOptionIds = List<String>.from(
        ref.read(onboardingDataProvider).genderIdentityOptionIds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onboardingData = ref.watch(onboardingDataProvider);
    final gender = onboardingData.gender;

    if (gender == null) return const SizedBox.shrink();

    final options = gender.identityOptions;

    return Material(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.x4),

                // Header with back button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.chevron_left,
                          size: 28,
                          color: AppColors.interactive500,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          'Select Gender Identity',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.interactive500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Spacer to balance the back button
                      const SizedBox(width: 36),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x6),

                // Options list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x5),
                    itemCount:
                        options.length + 1, // +1 for "Are we missing something?"
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.x3),
                    itemBuilder: (context, index) {
                      if (index < options.length) {
                        final option = options[index];
                        final isSelected = _selectedOptionIds.contains(option.id);
                        return _IdentityOptionTile(
                          label: option.label,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedOptionIds.remove(option.id);
                              } else {
                                _selectedOptionIds.add(option.id);
                              }
                            });
                          },
                        );
                      } else {
                        // "Are we missing something?" row
                        return _AreMissingSomethingTile(
                          onTap: () async {
                            final feedback =
                                await FeedbackDialog.show(context);
                            if (feedback != null && context.mounted) {
                              await ThankYouDialog.show(context);
                            }
                          },
                        );
                      }
                    },
                  ),
                ),

                // Save and close button
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x5,
                    AppSpacing.x4,
                    AppSpacing.x5,
                    AppSpacing.x5,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius:
                            BorderRadius.circular(AppRadius.large),
                        boxShadow: AppShadows.defaultShadow,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(onboardingDataProvider.notifier)
                              .updateGenderIdentityOptions(
                                  _selectedOptionIds);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.large),
                          ),
                        ),
                        child: Text(
                          'Save and close',
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

/// A single identity option tile with a radio circle
class _IdentityOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _IdentityOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: isSelected
                ? AppColors.brandDark
                : AppColors.interactive100,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.interactive500,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            // Radio circle
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandDark
                      : AppColors.interactive200,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.brandGradient,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// "Are we missing something?" tile with a chevron
class _AreMissingSomethingTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AreMissingSomethingTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: AppColors.interactive100,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Are we missing something?',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.interactive300,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.interactive300,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
