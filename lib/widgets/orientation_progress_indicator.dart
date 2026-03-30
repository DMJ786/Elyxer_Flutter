/// Orientation Progress Indicator
/// Animated progress bar showing orientation module steps
/// Uses responsive sizing based on screen width (same approach as ProgressIndicatorWidget)
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive icon size: 15% of screen width, clamped between 48-70px
    final activeSize = (screenWidth * 0.15).clamp(48.0, 70.0);

    return SizedBox(
      height: activeSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sexual Orientation Icon (index 0)
          _SvgStepIcon(
            assetBase: 'assets/images/orientation/SexualOrientationIcon',
            isActive: currentStep.index >= 0,
            isCompleted: currentStep.index > 0,
            animationDuration: animationDuration,
          ),
          // Progress Bar 1
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 1,
            animationDuration: animationDuration,
          ),
          // Dating Preference Icon (index 1)
          _SvgStepIcon(
            assetBase: 'assets/images/orientation/DatingPreferenceIcon',
            isActive: currentStep.index >= 1,
            isCompleted: currentStep.index > 1,
            animationDuration: animationDuration,
          ),
          // Progress Bar 2
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 2,
            animationDuration: animationDuration,
          ),
          // Dating Goals Icon (index 2)
          _SvgStepIcon(
            assetBase: 'assets/images/orientation/DatingGoalIcon',
            isActive: currentStep.index >= 2,
            isCompleted: currentStep.index > 2,
            animationDuration: animationDuration,
          ),
          // Progress Bar 3
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 3,
            animationDuration: animationDuration,
          ),
          // Complete Icon (index 3) - Thank You icon or fallback check
          _SvgStepIcon(
            assetBase: 'assets/images/orientation/DatingGoalIcon',
            isActive: currentStep.index >= 3,
            isCompleted: currentStep.index >= 3,
            animationDuration: animationDuration,
            completedOverride: 'assets/images/orientation/ThankyouIcon.svg',
            inprogressOverride: 'assets/images/orientation/ThankyouIcon.svg',
          ),
        ],
      ),
    );
  }
}

/// SVG-based step icon that switches between completed/inprogress/incomplete states
/// Uses responsive sizing: active = 15% screen width, inactive = 10% screen width
class _SvgStepIcon extends StatelessWidget {
  final String assetBase;
  final bool isActive;
  final bool isCompleted;
  final Duration animationDuration;
  final String? completedOverride;
  final String? inprogressOverride;

  const _SvgStepIcon({
    required this.assetBase,
    required this.isActive,
    required this.isCompleted,
    required this.animationDuration,
    this.completedOverride,
    this.inprogressOverride,
  });

  String get _svgAssetPath {
    if (isCompleted) return completedOverride ?? '$assetBase/completed.svg';
    if (isActive) return inprogressOverride ?? '$assetBase/inprogress.svg';
    return '$assetBase/incomplete.svg';
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing based on screen width
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

/// Responsive progress bar that scales width with screen size
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
