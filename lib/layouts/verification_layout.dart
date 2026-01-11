/// Verification Layout Wrapper
/// Manages progress bar separately from screen content
library;

import 'package:flutter/material.dart';
import '../widgets/progress_indicator.dart';
import '../theme/app_theme.dart';

class VerificationLayout extends StatelessWidget {
  final Widget child;
  final int currentStep;

  const VerificationLayout({
    super.key,
    required this.child,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar - stays here, animates independently
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.x5,
                right: AppSpacing.x5,
                top: AppSpacing.x14,
                bottom: AppSpacing.x8,
              ),
              child: CustomProgressIndicator(currentStep: currentStep),
            ),
            // Content area - child screens slide here
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
