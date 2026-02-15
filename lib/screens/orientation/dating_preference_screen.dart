/// Dating Preference Screen
/// User selects who they're interested in dating (multi-select)
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';

class DatingPreferenceScreen extends ConsumerWidget {
  const DatingPreferenceScreen({super.key});

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
            'Who are you interested in dating?',
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Select all that apply',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.interactive300,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

          // Preference Selection List
          Expanded(
            child: ListView.separated(
              itemCount: DatingPreference.values.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.x3),
              itemBuilder: (context, index) {
                final preference = DatingPreference.values[index];
                final isSelected = onboardingData.datingPreferences.contains(preference);

                return _PreferenceTile(
                  preference: preference,
                  isSelected: isSelected,
                  onTap: () {
                    ref.read(onboardingDataProvider.notifier)
                        .toggleDatingPreference(preference);
                  },
                );
              },
            ),
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
                    'We\'ll use this to show you relevant matches. You can update this later.',
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

class _PreferenceTile extends StatelessWidget {
  final DatingPreference preference;
  final bool isSelected;
  final VoidCallback onTap;

  const _PreferenceTile({
    required this.preference,
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
          color: isSelected
              ? AppColors.brandLight.withValues(alpha: 0.1)
              : Colors.white,
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
            // Checkbox indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.small),
                border: Border.all(
                  color: isSelected ? AppColors.brandDark : AppColors.interactive200,
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
              child: Text(
                preference.displayName,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.brandDark : AppColors.interactive400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
