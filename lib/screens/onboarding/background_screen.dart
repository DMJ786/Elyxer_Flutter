/// Background Screen - Education, Profession, Location
/// Container screen with PageView and 4-step progress indicator
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/background_progress_indicator.dart';
import '../../widgets/next_button.dart';
import 'education_entry_screen.dart';
import 'profession_entry_screen.dart';
import 'location_entry_screen.dart';

class BackgroundScreen extends ConsumerStatefulWidget {
  const BackgroundScreen({super.key});

  @override
  ConsumerState<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends ConsumerState<BackgroundScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final currentStep = ref.read(currentBackgroundStepProvider);

    if (currentStep == BackgroundStep.complete) {
      // All steps completed - navigate to next flow
      context.push('/complete');
      return;
    }

    // Validate current step before proceeding
    final canProceed = ref.read(onboardingDataProvider.notifier)
        .canProceedBackground(currentStep);
    if (!canProceed) {
      _showValidationError(currentStep);
      return;
    }

    // Animate fade out then slide to next page
    _fadeController.reverse().then((_) {
      ref.read(currentBackgroundStepProvider.notifier).next();

      if (currentStep.index < 2) {
        // Navigate to next page (education, profession, location)
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else if (currentStep == BackgroundStep.location) {
        // After location, show complete state (no extra page needed)
        // The progress indicator will show the complete step
      }

      _fadeController.forward();
    });
  }

  void _skipStep() {
    _fadeController.reverse().then((_) {
      ref.read(currentBackgroundStepProvider.notifier).next();

      final newStep = ref.read(currentBackgroundStepProvider);
      if (newStep != BackgroundStep.complete && newStep.index <= 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }

      _fadeController.forward();
    });
  }

  void _showValidationError(BackgroundStep step) {
    final message = switch (step) {
      BackgroundStep.education => 'Please select your education level',
      BackgroundStep.profession => 'Please enter your industry or role',
      BackgroundStep.location => 'Please enter your location',
      BackgroundStep.complete => 'Please complete all steps',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentBackgroundStepProvider);
    final isComplete = currentStep == BackgroundStep.complete;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x5,
                AppSpacing.x14,
                AppSpacing.x5,
                AppSpacing.x4,
              ),
              child: BackgroundProgressIndicator(
                currentStep: currentStep,
              ),
            ),

            // Page Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      EducationEntryScreen(),
                      ProfessionEntryScreen(),
                      LocationEntryScreen(),
                    ],
                  ),
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x5, AppSpacing.x4, AppSpacing.x5, AppSpacing.x5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip for now (not shown on location screen or complete)
                  if (!isComplete &&
                      currentStep != BackgroundStep.location)
                    _SkipForNowLink(onTap: _skipStep)
                  else
                    const SizedBox.shrink(),

                  NextButton(
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

/// Skip for now link with gold gradient text
class _SkipForNowLink extends StatelessWidget {
  final VoidCallback onTap;

  const _SkipForNowLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ShaderMask(
        shaderCallback: (bounds) => AppColors.brandGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: const Text(
          'Skip for now',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
