/// Dating Goals Screen
/// User selects up to 2 dating goals
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/info_banner.dart';

class DatingGoalsScreen extends ConsumerWidget {
  const DatingGoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingData = ref.watch(onboardingDataProvider);
    final maxReached = onboardingData.datingGoalIds.length >= 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'What are you looking for?',
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Select up to 2 options',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.interactive300,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

          // Goals Selection List
          Expanded(
            child: ListView.separated(
              itemCount: DatingGoal.all.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.x3),
              itemBuilder: (context, index) {
                final goal = DatingGoal.all[index];
                final isSelected = onboardingData.datingGoalIds.contains(goal.id);
                final isDisabled = maxReached && !isSelected;

                return _GoalTile(
                  goal: goal,
                  isSelected: isSelected,
                  isDisabled: isDisabled,
                  onTap: isDisabled
                      ? null
                      : () {
                          ref.read(onboardingDataProvider.notifier)
                              .toggleDatingGoal(goal.id);
                        },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

          // Selection counter
          if (onboardingData.datingGoalIds.isNotEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4,
                  vertical: AppSpacing.x2,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: Text(
                  '${onboardingData.datingGoalIds.length}/2 selected',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.x4),

          // Info Banner
          const InfoBanner(
            message: 'Your goals help us match you with people who want the same things.',
            iconStyle: InfoBannerIcon.gradientCircle,
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final DatingGoal goal;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _GoalTile({
    required this.goal,
    required this.isSelected,
    required this.isDisabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.interactive50
              : isSelected
                  ? AppColors.brandLight.withValues(alpha: 0.1)
                  : Colors.white,
          border: Border.all(
            color: isDisabled
                ? AppColors.interactive100
                : isSelected
                    ? AppColors.brandDark
                    : AppColors.interactive100,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandLight.withValues(alpha: 0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.small),
                border: Border.all(
                  color: isDisabled
                      ? AppColors.interactive100
                      : isSelected
                          ? AppColors.brandDark
                          : AppColors.interactive200,
                  width: 2,
                ),
                gradient: isSelected ? AppColors.brandGradient : null,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isDisabled
                          ? AppColors.interactive200
                          : isSelected
                              ? AppColors.brandDark
                              : AppColors.interactive500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    goal.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDisabled
                          ? AppColors.interactive200
                          : AppColors.interactive300,
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
