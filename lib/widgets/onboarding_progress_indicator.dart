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
        // Age Icon (index 0)
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
        // Gender Icon (index 1)
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
        // Pronoun Icon (index 2)
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
        // Sexual Orientation Icon (index 3)
        _StepIcon(
          icon: Icons.favorite_outline,
          isActive: currentStep.index >= 3,
          isCompleted: currentStep.index > 3,
          animationDuration: animationDuration,
        ),
        // Progress Bar 4
        Expanded(
          child: _ProgressBar(
            isActive: currentStep.index >= 4,
            animationDuration: animationDuration,
          ),
        ),
        // Dating Preference Icon (index 4)
        _StepIcon(
          icon: Icons.people_outline,
          isActive: currentStep.index >= 4,
          isCompleted: currentStep.index > 4,
          animationDuration: animationDuration,
        ),
        // Progress Bar 5
        Expanded(
          child: _ProgressBar(
            isActive: currentStep.index >= 5,
            animationDuration: animationDuration,
          ),
        ),
        // Dating Goals Icon (index 5)
        _StepIcon(
          icon: Icons.flag_outlined,
          isActive: currentStep.index >= 5,
          isCompleted: currentStep.index > 5,
          animationDuration: animationDuration,
        ),
        // Progress Bar 6
        Expanded(
          child: _ProgressBar(
            isActive: currentStep.index >= 6,
            animationDuration: animationDuration,
          ),
        ),
        // Complete Icon (index 6)
        _StepIcon(
          icon: Icons.check,
          isActive: currentStep.index >= 6,
          isCompleted: currentStep.index >= 6,
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
    // Smaller sizes to fit 7 steps
    final size = isActive ? 40.0 : 28.0;

    return SizedBox(
      width: 40.0,
      height: 40.0,
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
              size: isActive ? 18 : 14,
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
    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.brandGradient : null,
        color: !isActive ? AppColors.interactive100 : null,
      ),
    );
  }
}
