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
import '../../widgets/next_button.dart';
import '../../widgets/age_confirmation_dialog.dart';
import 'age_input_screen.dart';
import 'gender_selection_screen.dart';
import 'pronoun_selection_screen.dart';

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

  void _nextPage() async {
    final currentStep = ref.read(currentOnboardingStepProvider);
    final canProceed = ref.read(canProceedOnboardingProvider);

    if (!canProceed) {
      _showErrorSnackBar();
      return;
    }

    // Show age confirmation dialog on the age step
    if (currentStep == OnboardingStep.age) {
      final birthdate = ref.read(onboardingDataProvider).birthdate;
      if (birthdate != null) {
        final age = calculateAge(birthdate);
        final confirmed = await showAgeConfirmationDialog(
          context,
          age: age,
        );
        if (confirmed != true || !mounted) return;
      }
    }

    // Check if we're on the last content screen (pronoun)
    if (currentStep == OnboardingStep.pronoun) {
      // Advance progress to "complete" step (fills the 4th icon),
      // then navigate to Module 2 after a short delay.
      _fadeController.reverse().then((_) {
        ref.read(currentOnboardingStepProvider.notifier).next();
        _fadeController.forward();
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) context.go('/orientation');
        });
      });
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

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentOnboardingStepProvider);
    final canProceed = ref.watch(canProceedOnboardingProvider);

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
