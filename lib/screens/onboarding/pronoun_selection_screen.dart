/// Pronoun Selection Screen
/// User selects their pronouns
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/info_banner.dart';

class PronounSelectionScreen extends ConsumerWidget {
  const PronounSelectionScreen({super.key});

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
            'How do you describe your Pronouns?',
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x4),

          // Pronoun Selection Container
          Container(
            padding: const EdgeInsets.all(AppSpacing.x4),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.interactive200,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x4,
              children: [
                ...Pronouns.all.map(
                  (pronoun) => _PronounChip(
                    label: pronoun,
                    isSelected: onboardingData.pronouns.contains(pronoun),
                    onTap: () {
                      ref.read(onboardingDataProvider.notifier)
                          .togglePronoun(pronoun);
                    },
                  ),
                ),
                _PronounChip(
                  label: 'Other (self-describe)',
                  isSelected: false,
                  onTap: () {
                    // TODO: Show custom pronoun input
                  },
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
                  value: onboardingData.showPronounsOnProfile,
                  onChanged: (value) {
                    ref.read(onboardingDataProvider.notifier)
                        .toggleShowPronounsOnProfile();
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
          const InfoBanner(
            message: 'Helps others refer to you correctly. You can change this anytime.',
            iconStyle: InfoBannerIcon.gradientCircle,
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

class _PronounChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PronounChip({
    required this.label,
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
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandLight.withValues(alpha: 0.2) : AppColors.interactive50,
          border: Border.all(
            color: isSelected ? AppColors.brandDark : AppColors.interactive100,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.brandGradient : null,
                color: !isSelected ? AppColors.interactive300 : null,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? AppColors.brandDark : AppColors.interactive300,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
