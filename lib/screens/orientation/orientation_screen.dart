/// Orientation Screen (Module 2)
/// Container for orientation flow with animated page transitions
/// Includes: Sexual Orientation, Dating Preference, Dating Goals
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/orientation_progress_indicator.dart';
import '../../widgets/next_button.dart';
import 'sexual_orientation_screen.dart';
import 'dating_preference_screen.dart';
import 'dating_goals_screen.dart';

class OrientationScreen extends ConsumerStatefulWidget {
  const OrientationScreen({super.key});

  @override
  ConsumerState<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends ConsumerState<OrientationScreen>
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
    final currentStep = ref.read(currentOrientationStepProvider);
    final canProceed = ref
        .read(onboardingDataProvider.notifier)
        .canProceedOrientation(currentStep);

    print('DEBUG Orientation _nextPage: currentStep=$currentStep');
    print('DEBUG Orientation _nextPage: canProceed=$canProceed');

    if (!canProceed) {
      _showErrorSnackBar();
      return;
    }

    // Check if we're on the last screen (dating goals)
    if (currentStep == OrientationStep.datingGoals) {
      // Final step - submit and navigate to next flow
      _submitOrientation();
      return;
    }

    // Animate fade out then slide to next page
    _fadeController.reverse().then((_) {
      ref.read(currentOrientationStepProvider.notifier).next();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _fadeController.forward();
    });
  }

  void _previousPage() {
    if (_pageController.page! > 0) {
      _fadeController.reverse().then((_) {
        ref.read(currentOrientationStepProvider.notifier).previous();
        _pageController.previousPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        _fadeController.forward();
      });
    } else {
      // Go back to onboarding module
      context.go('/onboarding');
    }
  }

  void _showErrorSnackBar() {
    final currentStep = ref.read(currentOrientationStepProvider);
    String message;

    switch (currentStep) {
      case OrientationStep.sexualOrientation:
        message = 'Please select your sexual orientation';
        break;
      case OrientationStep.datingPreference:
        message = 'Please select at least one preference';
        break;
      case OrientationStep.datingGoals:
        message = 'Please select 1-2 dating goals';
        break;
      default:
        message = 'Please complete this step';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitOrientation() async {
    try {
      await ref.read(onboardingDataProvider.notifier).submit();
      if (mounted) {
        // Navigate to username screen
        context.push('/username');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentOrientationStepProvider);
    final onboardingData = ref.watch(onboardingDataProvider);
    final canProceed = ref
        .read(onboardingDataProvider.notifier)
        .canProceedOrientation(currentStep);

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
              child: OrientationProgressIndicator(
                currentStep: currentStep,
              ),
            ),

            // Page Content with Slide + Fade Animation
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    // Sync page index with step provider
                    ref.read(currentOrientationStepProvider.notifier)
                        .goTo(OrientationStep.values[index]);
                  },
                  children: const [
                    SexualOrientationScreen(),
                    DatingPreferenceScreen(),
                    DatingGoalsScreen(),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x5,
                AppSpacing.x4,
                AppSpacing.x5,
                AppSpacing.x5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: _previousPage,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.interactive200,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.round),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.interactive300,
                      ),
                    ),
                  ),

                  // Next Button
                  NextButton(
                    onPressed: canProceed ? _nextPage : null,
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
