/// Module 4 Screen - Education, Profession, Location
/// Container screen with PageView and 4-step progress indicator
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/onboarding_models.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/module4_progress_indicator.dart';
import 'education_entry_screen.dart';
import 'profession_entry_screen.dart';
import 'location_entry_screen.dart';

class Module4Screen extends ConsumerStatefulWidget {
  const Module4Screen({super.key});

  @override
  ConsumerState<Module4Screen> createState() => _Module4ScreenState();
}

class _Module4ScreenState extends ConsumerState<Module4Screen>
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
    final currentStep = ref.read(currentModule4StepProvider);

    if (currentStep == Module4Step.complete) {
      // All steps completed - navigate to next flow
      context.push('/complete');
      return;
    }

    // Animate fade out then slide to next page
    _fadeController.reverse().then((_) {
      ref.read(currentModule4StepProvider.notifier).next();

      if (currentStep.index < 2) {
        // Navigate to next page (education, profession, location)
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else if (currentStep == Module4Step.location) {
        // After location, show complete state (no extra page needed)
        // The progress indicator will show the complete step
      }

      _fadeController.forward();
    });
  }

  void _skipStep() {
    _fadeController.reverse().then((_) {
      ref.read(currentModule4StepProvider.notifier).next();

      final newStep = ref.read(currentModule4StepProvider);
      if (newStep != Module4Step.complete && newStep.index <= 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }

      _fadeController.forward();
    });
  }

  void _previousPage() {
    final currentStep = ref.read(currentModule4StepProvider);

    if (currentStep == Module4Step.complete) {
      // Go back to location from complete
      _fadeController.reverse().then((_) {
        ref.read(currentModule4StepProvider.notifier).previous();
        _fadeController.forward();
      });
      return;
    }

    if (_pageController.page! > 0) {
      _fadeController.reverse().then((_) {
        ref.read(currentModule4StepProvider.notifier).previous();
        _pageController.previousPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        _fadeController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentModule4StepProvider);
    final isComplete = currentStep == Module4Step.complete;

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
              child: Module4ProgressIndicator(
                currentStep: currentStep,
              ),
            ),

            // Page Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: isComplete
                    ? _buildCompleteContent()
                    : PageView(
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

            // Bottom row: Skip for now + Next button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip for now (not shown on location screen or complete)
                  if (!isComplete &&
                      currentStep != Module4Step.location)
                    _SkipForNowLink(onTap: _skipStep)
                  else
                    const SizedBox.shrink(),

                  Row(
                    children: [
                      // Back button
                      if (currentStep.index > 0 && !isComplete)
                        Container(
                          margin:
                              const EdgeInsets.only(right: AppSpacing.x4),
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

                      // Next/Complete button
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius:
                              BorderRadius.circular(AppRadius.large),
                          boxShadow: AppShadows.defaultShadow,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _nextPage,
                            borderRadius:
                                BorderRadius.circular(AppRadius.large),
                            child: Container(
                              width: 54,
                              height: 54,
                              alignment: Alignment.center,
                              child: Icon(
                                isComplete
                                    ? Icons.check
                                    : Icons.arrow_forward,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteContent() {
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
            'Your education, profession, and location have been saved.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 2),
        ],
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
