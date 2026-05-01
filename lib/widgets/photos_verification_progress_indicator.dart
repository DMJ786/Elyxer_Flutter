/// Photos & Selfie Verification Progress Indicator
/// 4-step progress bar: Height, Language, Photo, Complete
/// SVG assets live in assets/images/photos_verification/
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../models/photos_verification_models.dart';

class PhotosVerificationProgressIndicator extends StatelessWidget {
  final PhotosVerificationStep currentStep;
  final Duration animationDuration;

  const PhotosVerificationProgressIndicator({
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
          _SvgStepIcon(
            assetBase: 'assets/images/photos_verification/HeightIcon',
            isActive: currentStep.index >= 0,
            isCompleted: currentStep.index > 0,
            animationDuration: animationDuration,
          ),
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 1,
            animationDuration: animationDuration,
          ),
          _SvgStepIcon(
            assetBase: 'assets/images/photos_verification/LanguageIcon',
            isActive: currentStep.index >= 1,
            isCompleted: currentStep.index > 1,
            animationDuration: animationDuration,
          ),
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 2,
            animationDuration: animationDuration,
          ),
          _SvgStepIcon(
            assetBase: 'assets/images/photos_verification/PhotoIcon',
            isActive: currentStep.index >= 2,
            isCompleted: currentStep.index > 2,
            animationDuration: animationDuration,
          ),
          _ResponsiveProgressBar(
            isActive: currentStep.index >= 3,
            animationDuration: animationDuration,
          ),
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
    final iconSize = isActive ? activeSize : inactiveSize;

    return SizedBox(
      width: activeSize,
      height: activeSize,
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
    final size = isActive ? activeSize : inactiveSize;
    final iconFontSize = size * 0.35;

    return SizedBox(
      width: activeSize,
      height: activeSize,
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

class _ResponsiveProgressBar extends StatelessWidget {
  final bool isActive;
  final Duration animationDuration;

  const _ResponsiveProgressBar({
    required this.isActive,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
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
