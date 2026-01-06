/// Onboarding Complete Screen
/// Final screen in onboarding flow showing success message
library;

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OnboardingCompleteScreen extends StatelessWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Success Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
              boxShadow: AppShadows.defaultShadow,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 64,
            ),
          ),
          const SizedBox(height: AppSpacing.x6),

          // Title
          Text(
            'All Set!',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x4),

          // Subtitle
          Text(
            'Your profile is ready. Let\'s continue to verify your account.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
