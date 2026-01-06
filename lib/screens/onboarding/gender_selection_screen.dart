/// Gender Selection Screen
/// User selects their gender identity
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';

class GenderSelectionScreen extends ConsumerWidget {
  const GenderSelectionScreen({super.key});

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
            'How do you describe your Gender?',
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x4),

          // Gender Selection Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GenderButton(
                gender: Gender.man,
                icon: Icons.male,
                label: 'Man',
                isSelected: onboardingData.gender == Gender.man,
                onTap: () {
                  ref.read(onboardingDataProvider.notifier)
                      .updateGender(Gender.man);
                },
              ),
              const SizedBox(width: AppSpacing.x4),
              _GenderButton(
                gender: Gender.woman,
                icon: Icons.female,
                label: 'Woman',
                isSelected: onboardingData.gender == Gender.woman,
                onTap: () {
                  ref.read(onboardingDataProvider.notifier)
                      .updateGender(Gender.woman);
                },
              ),
              const SizedBox(width: AppSpacing.x4),
              _GenderButton(
                gender: Gender.nonBinary,
                icon: Icons.transgender,
                label: 'Non-Binary',
                isSelected: onboardingData.gender == Gender.nonBinary,
                onTap: () {
                  ref.read(onboardingDataProvider.notifier)
                      .updateGender(Gender.nonBinary);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),

          // Add more about gender identity
          GestureDetector(
            onTap: () {
              // TODO: Show gender identity input
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add more about your gender identity',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.interactive200,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.interactive200,
                  size: 20,
                ),
              ],
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
                  value: onboardingData.showGenderOnProfile,
                  onChanged: (value) {
                    ref.read(onboardingDataProvider.notifier)
                        .toggleShowGenderOnProfile();
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

          const Spacer(),

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
                    'Helps represent you as you identify. You can change this anytime.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),

          // Footer Link
          GestureDetector(
            onTap: () {
              // TODO: Show learn more dialog
            },
            child: ShaderMask(
              shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
              child: Text(
                'Learn more',
                style: theme.textTheme.labelMedium?.copyWith(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final Gender gender;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.gender,
    required this.icon,
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
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.brandDark : AppColors.interactive100,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.interactive200,
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.interactive300,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.interactive300,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x4),
            // Radio button
            Container(
              width: 16,
              height: 16,
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
