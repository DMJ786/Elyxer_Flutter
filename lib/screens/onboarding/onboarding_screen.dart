/// Main Onboarding Screen
/// Container for onboarding flow with animated page transitions
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/onboarding_progress_indicator.dart';
import 'age_input_screen.dart';
import 'gender_selection_screen.dart';
import 'pronoun_selection_screen.dart';
import 'sexual_orientation_screen.dart';
import 'dating_preference_screen.dart';
import 'dating_goals_screen.dart';
import 'onboarding_complete_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
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
    final currentStep = ref.read(currentOnboardingStepProvider);
    final onboardingData = ref.read(onboardingDataProvider);
    final canProceed = ref
        .read(onboardingDataProvider.notifier)
        .canProceed(currentStep);

    // Debug logging
    print('DEBUG _nextPage: currentStep=$currentStep');
    print('DEBUG _nextPage: birthdate=${onboardingData.birthdate}');
    print('DEBUG _nextPage: canProceed=$canProceed');

    if (!canProceed) {
      _showErrorSnackBar();
      return;
    }

    if (currentStep == OnboardingStep.complete) {
      // Final step - submit and navigate to next flow
      _submitOnboarding();
      return;
    }

    // Animate fade out then slide to next page
    _fadeController.reverse().then((_) {
      ref.read(currentOnboardingStepProvider.notifier).next();
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
        ref.read(currentOnboardingStepProvider.notifier).previous();
        _pageController.previousPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        _fadeController.forward();
      });
    }
  }

  void _showErrorSnackBar() {
    final currentStep = ref.read(currentOnboardingStepProvider);
    String message;

    switch (currentStep) {
      case OnboardingStep.age:
        message = 'Please enter a valid birthdate';
        break;
      case OnboardingStep.gender:
        message = 'Please select your gender';
        break;
      case OnboardingStep.pronoun:
        message = 'Please select at least one pronoun';
        break;
      case OnboardingStep.sexualOrientation:
        message = 'Please select your sexual orientation';
        break;
      case OnboardingStep.datingPreference:
        message = 'Please select at least one preference';
        break;
      case OnboardingStep.datingGoals:
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

  Future<void> _submitOnboarding() async {
    try {
      await ref.read(onboardingDataProvider.notifier).submit();
      if (mounted) {
        // Navigate to completion screen
        context.push('/complete');
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
    final currentStep = ref.watch(currentOnboardingStepProvider);

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
              child: OnboardingProgressIndicator(
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
                    ref.read(currentOnboardingStepProvider.notifier)
                        .goTo(OnboardingStep.values[index]);
                  },
                  children: const [
                    AgeInputScreen(),
                    GenderSelectionScreen(),
                    PronounSelectionScreen(),
                    SexualOrientationScreen(),
                    DatingPreferenceScreen(),
                    DatingGoalsScreen(),
                    OnboardingCompleteScreen(),
                  ],
                ),
              ),
            ),

            // Next Button (Fixed at bottom)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Back button (optional, hide on complete step)
                  if (currentStep.index > 0 && currentStep != OnboardingStep.complete)
                    Container(
                      margin: const EdgeInsets.only(right: AppSpacing.x4),
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.defaultShadow,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: _previousPage,
                      ),
                    ),

                  // Next/Submit Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                      boxShadow: AppShadows.defaultShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _nextPage,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                        child: Container(
                          width: 54,
                          height: 54,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
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
