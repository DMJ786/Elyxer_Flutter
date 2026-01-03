/// Screen Wrapper
/// Keeps progress bar static while content animates during page transitions
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'progress_indicator.dart';

class ScreenWrapper extends StatelessWidget {
  final int currentStep;
  final Widget child;

  const ScreenWrapper({
    super.key,
    required this.currentStep,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Static Progress Indicator - doesn't animate with page transitions
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.x5,
                right: AppSpacing.x5,
                top: AppSpacing.x14,
              ),
              child: CustomProgressIndicator(currentStep: currentStep),
            ),
            const SizedBox(height: AppSpacing.x8),

            // Animated Content Area
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
