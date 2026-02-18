/// Orientation Progress Indicator
/// Animated progress bar showing orientation module steps
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_models.dart';

class OrientationProgressIndicator extends StatelessWidget {
  final OrientationStep currentStep;
  final Duration animationDuration;

  const OrientationProgressIndicator({
    super.key,
    required this.currentStep,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sexual Orientation Icon (index 0)
        _StepIcon(
          icon: Icons.favorite_outline,
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
        // Dating Preference Icon (index 1)
        _StepIcon(
          icon: Icons.people_outline,
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
        // Dating Goals Icon (index 2)
        _StepIcon(
          icon: Icons.flag_outlined,
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
        // Complete Icon (index 3)
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
          child: Icon(
            icon,
            color: isActive ? Colors.white : AppColors.interactive300,
            size: isActive ? 18 : 14,
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
