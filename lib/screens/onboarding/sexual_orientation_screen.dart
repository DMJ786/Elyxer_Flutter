/// Sexual Orientation Screen
/// User selects their sexual orientation
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';

class SexualOrientationScreen extends ConsumerWidget {
  const SexualOrientationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingData = ref.watch(onboardingDataProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'What is your Sexual Orientation?',
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x4),

          // Orientation Selection List
          Expanded(
            child: ListView.separated(
              itemCount: SexualOrientation.values.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.x3),
              itemBuilder: (context, index) {
                final orientation = SexualOrientation.values[index];
                final isSelected = onboardingData.sexualOrientation == orientation;

                return _OrientationTile(
                  orientation: orientation,
                  isSelected: isSelected,
                  onTap: () {
                    ref.read(onboardingDataProvider.notifier)
                        .updateSexualOrientation(orientation);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

          // Show on profile checkbox
          Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Checkbox(
                  value: onboardingData.showSexualOrientationOnProfile,
                  onChanged: (value) {
                    ref.read(onboardingDataProvider.notifier)
                        .toggleShowSexualOrientationOnProfile();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Show on your profile',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),

          // Info Banner
          Container(
            padding: const EdgeInsets.all(AppSpacing.x4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.brandDark),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.x2),
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.pressedShadow,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text(
                    'This helps us find better matches for you. You can change this anytime.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }
}

class _OrientationTile extends StatelessWidget {
  final SexualOrientation orientation;
  final bool isSelected;
  final VoidCallback onTap;

  const _OrientationTile({
    required this.orientation,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.brandDark : AppColors.interactive100,
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
          children: [
            Expanded(
              child: Text(
                orientation.displayName,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.brandDark : AppColors.interactive400,
                ),
              ),
            ),
            // Radio button indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.brandDark : AppColors.interactive200,
                  width: 2,
                ),
                gradient: isSelected ? AppColors.brandGradient : null,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.white,
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
