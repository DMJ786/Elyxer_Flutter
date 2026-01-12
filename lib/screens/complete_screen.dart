/// Completion Screen
/// Shows success message after verification is complete
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/next_button.dart';
import '../models/verification_models.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  // Define progress steps
  static const List<ProgressStep> _steps = [
    ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.completed),
    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.completed),
    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.completed),
    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.completed),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.x14),

              // Progress Indicator - All completed
              ProgressIndicatorWidget(
                steps: _steps,
                currentStep: 3,
              ),
              const SizedBox(height: AppSpacing.x8),

              const Spacer(),

              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppSpacing.x6),

              // Title
              Text(
                'Verification Complete!',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x4),

              // Subtitle
              Text(
                'Your account has been successfully verified. You can now enjoy all features of the app.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Next Button - Positioned at bottom right
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NextButton(
                    onPressed: () {
                      // TODO: Navigate to main app
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x6),
            ],
          ),
        ),
      ),
    );
  }
}
