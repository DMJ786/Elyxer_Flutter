/// Background Progress Indicator
/// 4-step progress bar: Education, Profession, Location, Complete
/// Uses SVG assets from assets/images/background/ for step icons
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_models.dart';

class BackgroundProgressIndicator extends StatelessWidget {
  final BackgroundStep currentStep;
  final Duration animationDuration;

  const BackgroundProgressIndicator({
    super.key,
    required this.currentStep,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final activeSize = (screenWidth * 0.15).clamp(48.0, 70.0);

    return SizedBox(
      height: activeSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Education Icon (index 0)
          _SvgStepIcon(
            assetBase: 'assets/images/background/EducationIcon',
            isActive: currentStep.index >= 0,
            isCompleted: currentStep.index > 0,
            animationDuration: animationDuration,
          ),
          // Progress Bar 1
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 1,
            animationDuration: animationDuration,
          ),
          // Profession Icon (index 1)
          _SvgStepIcon(
            assetBase: 'assets/images/background/ProfessionIcon',
            isActive: currentStep.index >= 1,
            isCompleted: currentStep.index > 1,
            animationDuration: animationDuration,
          ),
          // Progress Bar 2
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 2,
            animationDuration: animationDuration,
          ),
          // Location Icon (index 2)
          _SvgStepIcon(
            assetBase: 'assets/images/background/LocationIcon',
            isActive: currentStep.index >= 2,
            isCompleted: currentStep.index > 2,
            animationDuration: animationDuration,
          ),
          // Progress Bar 3
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 3,
            animationDuration: animationDuration,
          ),
          // Complete Icon (index 3) - no SVG, keep as check icon
          _StepIcon(
            icon: Icons.check,
            isActive: currentStep.index >= 3,
            isCompleted: currentStep.index >= 3,
            animationDuration: animationDuration,
          ),
        ],
      ),
    );
  }
}

/// SVG-based step icon that switches between completed/inprogress/incomplete states
class _SvgStepIcon extends StatelessWidget {
  final String assetBase;
  final bool isActive;
  final bool isCompleted;
  final Duration animationDuration;

  const _SvgStepIcon({
    required this.assetBase,
    required this.isActive,
    required this.isCompleted,
    required this.animationDuration,
  });

  String get _svgAssetPath {
    if (isCompleted) return '$assetBase/completed.svg';
    if (isActive) return '$assetBase/inprogress.svg';
    return '$assetBase/incomplete.svg';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final activeSize = (screenWidth * 0.15).clamp(48.0, 70.0);
    final inactiveSize = (screenWidth * 0.10).clamp(32.0, 50.0);
    final containerSize = activeSize;
    final iconSize = isActive ? activeSize : inactiveSize;

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: Center(
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          width: iconSize,
          height: iconSize,
          child: SvgPicture.asset(
            _svgAssetPath,
            key: ValueKey<String>(_svgAssetPath),
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/// Fallback Material Icon step (used for the complete/check step)
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
    final screenWidth = MediaQuery.of(context).size.width;
    final activeSize = (screenWidth * 0.15).clamp(48.0, 70.0);
    final inactiveSize = (screenWidth * 0.10).clamp(32.0, 50.0);
    final containerSize = activeSize;
    final size = isActive ? activeSize : inactiveSize;
    final iconFontSize = size * 0.35;

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: Center(
        child: AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive ? AppColors.brandGradient : null,
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
            size: iconFontSize,
          ),
        ),
      ),
    );
  }
}

/// Responsive progress bar connecting step icons
class _ResponsiveProgressBar extends StatelessWidget {
  final bool isActive;
  final Duration animationDuration;

  const _ResponsiveProgressBar({
    required this.isActive,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive bar width: 8% of screen width, clamped between 20-40px
    final screenWidth = MediaQuery.of(context).size.width;
    final barWidth = (screenWidth * 0.08).clamp(20.0, 40.0);

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      width: barWidth,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.brandGradient : null,
        color: !isActive ? AppColors.interactive100 : null,
      ),
    );
  }
}
