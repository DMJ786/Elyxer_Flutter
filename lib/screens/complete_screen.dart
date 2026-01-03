/// Completion Screen
/// Shows success message after verification is complete
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/custom_button.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

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

              // Progress Indicator - All completed - wrapped in Hero to keep it static during transitions
              Hero(
                tag: 'progress_indicator',
                child: Material(
                  color: Colors.transparent,
                  child: const CustomProgressIndicator(currentStep: 3),
                ),
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

              // Get Started Button
              CustomButton(
                label: 'Get Started',
                onPressed: () {
                  // TODO: Navigate to main app
                },
                variant: ButtonVariant.primary,
              ),
              const SizedBox(height: AppSpacing.x6),
            ],
          ),
        ),
      ),
    );
  }
}
