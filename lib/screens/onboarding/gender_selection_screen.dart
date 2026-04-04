/// Gender Selection Screen
/// User selects their gender identity
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../models/gender_identity_models.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/gradient_text_link.dart';
import '../../widgets/profile_visibility_checkbox.dart';
import 'gender_identity_sheet.dart';

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

          // Gender identity section — show link or selected chips
          if (onboardingData.genderIdentityOptionIds.isNotEmpty) ...[
            // Show curated text + chips
            Text(
              'Profile recommendations are curated based on your selection.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.interactive400,
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            _SelectedIdentitiesChips(
              gender: onboardingData.gender,
              selectedIds: onboardingData.genderIdentityOptionIds,
              onEdit: () => showGenderIdentitySheet(context),
            ),
          ] else ...[
            // Add more about gender identity link
            GestureDetector(
              onTap: onboardingData.gender != null
                  ? () => showGenderIdentitySheet(context)
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add more about your gender identity',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: onboardingData.gender != null
                          ? AppColors.brandDark
                          : AppColors.interactive200,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: onboardingData.gender != null
                        ? AppColors.brandDark
                        : AppColors.interactive200,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x4),

          // Show on profile checkbox
          ProfileVisibilityCheckbox(
            value: onboardingData.showGenderOnProfile,
            onToggle: () {
              ref.read(onboardingDataProvider.notifier)
                  .toggleShowGenderOnProfile();
            },
          ),

          const Spacer(),

          // Info Banner
          const InfoBanner(
            message: 'Helps represent you as you identify. You can change this anytime.',
          ),
          const SizedBox(height: AppSpacing.x3),

          // Footer Link
          GradientTextLink(
            text: 'Learn more',
            onTap: () {
              // TODO: Show learn more dialog
            },
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
            const SizedBox(height: AppSpacing.x2),
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

/// Displays selected gender identity chips with an edit button
class _SelectedIdentitiesChips extends StatelessWidget {
  final Gender? gender;
  final List<String> selectedIds;
  final VoidCallback onEdit;

  const _SelectedIdentitiesChips({
    required this.gender,
    required this.selectedIds,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Always include the base gender as the first chip
    final allLabels = <String>[];
    if (gender != null) {
      allLabels.add(gender!.displayName);
    }

    // Resolve IDs to labels (skip if same as base gender name)
    final options = gender?.identityOptions ?? [];
    for (final id in selectedIds) {
      final match = options.where((o) => o.id == id);
      if (match.isNotEmpty && match.first.label != gender?.displayName) {
        allLabels.add(match.first.label);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
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
            child: Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: allLabels.map((label) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.interactive50,
                    borderRadius: BorderRadius.circular(AppRadius.round),
                    border: Border.all(
                      color: AppColors.interactive200,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.interactive500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          GestureDetector(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.interactive400,
            ),
          ),
        ],
      ),
    );
  }
}
