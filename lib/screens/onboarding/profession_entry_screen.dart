/// Profession Entry Screen (Module 4 - Step 2)
/// Education level single-select radio list
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/info_banner.dart';

class ProfessionEntryScreen extends ConsumerWidget {
  const ProfessionEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingData = ref.watch(onboardingDataProvider);
    final selectedLevel = onboardingData.educationLevel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Your Profession',
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x4),

          // Subtitle
          Text(
            'Highest level of education',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.interactive400,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

          // Radio list
          Expanded(
            child: ListView.separated(
              itemCount: EducationLevel.values.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.x3),
              itemBuilder: (context, index) {
                final level = EducationLevel.values[index];
                final isSelected = selectedLevel == level;

                return _RadioOption(
                  label: level.displayName,
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(onboardingDataProvider.notifier)
                        .updateEducationLevel(level);
                  },
                );
              },
            ),
          ),

          // Info Banner
          const InfoBanner(
            message: 'Helps people get to know you better.',
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.x3),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.brandDark : AppColors.interactive300,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: Row(
          children: [
            // Radio circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandDark
                      : AppColors.interactive300,
                  width: isSelected ? 0 : 1.5,
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
            const SizedBox(width: AppSpacing.x3),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.interactive400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
