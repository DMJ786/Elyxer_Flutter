/// Education Entry Screen (Module 4 - Step 1)
/// Industry text field + "What do you do?" text field
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/info_banner.dart';

class EducationEntryScreen extends ConsumerStatefulWidget {
  const EducationEntryScreen({super.key});

  @override
  ConsumerState<EducationEntryScreen> createState() =>
      _EducationEntryScreenState();
}

class _EducationEntryScreenState extends ConsumerState<EducationEntryScreen> {
  late TextEditingController _industryController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingDataProvider);
    _industryController = TextEditingController(text: data.industry ?? '');
    _roleController = TextEditingController(text: data.role ?? '');
  }

  @override
  void dispose() {
    _industryController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Your Education',
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x6),

          // Industry field
          Text(
            'Your industry',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.interactive400,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          SizedBox(
            height: 48,
            child: TextField(
              controller: _industryController,
              onChanged: (value) {
                ref.read(onboardingDataProvider.notifier).updateIndustry(value);
              },
              decoration: const InputDecoration(
                hintText: 'e.g., Technology, Healthcare, Arts, Finance',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),

          // Role field
          Text(
            'What do you do?',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.interactive400,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          SizedBox(
            height: 48,
            child: TextField(
              controller: _roleController,
              onChanged: (value) {
                ref.read(onboardingDataProvider.notifier).updateRole(value);
              },
              decoration: const InputDecoration(
                hintText: 'e.g., Product Designer, Teacher, Entrepreneur',
              ),
            ),
          ),

          const Spacer(),

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
