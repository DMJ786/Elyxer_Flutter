/// Onboarding Progress Indicator
/// Animated progress bar showing onboarding steps
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_models.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final OnboardingStep currentStep;
  final Duration animationDuration;

  const OnboardingProgressIndicator({
    super.key,
    required this.currentStep,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Age Icon
        _StepIcon(
          icon: Icons.cake_outlined,
          isActive: currentStep.index >= 0,
          isCompleted: currentStep.index > 0,
          animationDuration: animationDuration,
        ),
        // Progress Bar 1
        Expanded(
          child: _ProgressBar(
            isActive: currentStep.index >= 1,
            animationDuration: animationDuration,
          ),
        ),
        // Gender Icon
        _StepIcon(
          icon: Icons.wc_outlined,
          isActive: currentStep.index >= 1,
          isCompleted: currentStep.index > 1,
          animationDuration: animationDuration,
        ),
        // Progress Bar 2
        Expanded(
          child: _ProgressBar(
            isActive: currentStep.index >= 2,
            animationDuration: animationDuration,
          ),
        ),
        // Pronoun Icon
        _StepIcon(
          icon: Icons.person_outline,
          isActive: currentStep.index >= 2,
          isCompleted: currentStep.index > 2,
          animationDuration: animationDuration,
        ),
        // Progress Bar 3
        Expanded(
          child: _ProgressBar(
            isActive: currentStep.index >= 3,
            animationDuration: animationDuration,
          ),
        ),
        // Complete Icon
        _StepIcon(
          icon: Icons.check,
          isActive: currentStep.index >= 3,
          isCompleted: currentStep.index >= 3,
          animationDuration: animationDuration,
        ),
      ],
    );
  }
}

class _StepIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isCompleted;
  final Duration animationDuration;

  const _StepIcon({
    required this.icon,
    required this.isActive,
    required this.isCompleted,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final size = isActive ? 60.0 : 40.0;

    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: Center(
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive
                ? AppColors.brandGradient
                : null,
            color: !isActive ? AppColors.interactive100 : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          child: AnimatedSwitcher(
            duration: animationDuration,
            child: Icon(
              isCompleted ? Icons.check : icon,
              key: ValueKey(isCompleted),
              color: isActive ? Colors.white : AppColors.interactive300,
              size: isActive ? 26 : 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final bool isActive;
  final Duration animationDuration;

  const _ProgressBar({
    required this.isActive,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.brandGradient : null,
          color: !isActive ? AppColors.interactive100 : null,
        ),
      ),
    );
  }
}
