/// Photos & Selfie Verification — Module 5 container.
/// PageView host for Height → Language → Photos → Complete with the
/// 4-step progress indicator at top and Skip / Next at bottom.
///
/// PR B replaces the photos placeholder with the real AddPhotoScreen.
/// Selfie flow is launched from inside AddPhotoScreen via showSelfieFlowSheet.
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/photos_verification_models.dart';
import '../../providers/photos_verification_provider.dart';
import '../../widgets/photos_verification_progress_indicator.dart';
import '../../widgets/next_button.dart';
import 'add_photo_screen.dart';
import 'height_input_screen.dart';
import 'language_input_screen.dart';

class PhotosVerificationScreen extends ConsumerStatefulWidget {
  const PhotosVerificationScreen({super.key});

  @override
  ConsumerState<PhotosVerificationScreen> createState() =>
      _PhotosVerificationScreenState();
}

class _PhotosVerificationScreenState
    extends ConsumerState<PhotosVerificationScreen>
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
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
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
    final currentStep = ref.read(currentPhotosVerificationStepProvider);

    if (currentStep == PhotosVerificationStep.complete) {
      // Module 5 finished — continue to Module 6 (Profile Studio).
      context.push('/profile-studio');
      return;
    }

    final canProceed = ref.read(canProceedPhotosVerificationProvider);
    if (!canProceed) {
      _showValidationError(currentStep);
      return;
    }

    _fadeController.reverse().then((_) {
      ref.read(currentPhotosVerificationStepProvider.notifier).next();

      // Advance the PageView for the three real screens; the Complete
      // step is reflected by the progress indicator alone (no extra page).
      if (currentStep.index < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }

      _fadeController.forward();
    });
  }

  void _skipStep() {
    _fadeController.reverse().then((_) {
      ref.read(currentPhotosVerificationStepProvider.notifier).next();
      final newStep = ref.read(currentPhotosVerificationStepProvider);
      if (newStep != PhotosVerificationStep.complete && newStep.index <= 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
      _fadeController.forward();
    });
  }

  void _showValidationError(PhotosVerificationStep step) {
    final message = switch (step) {
      PhotosVerificationStep.height => 'Please select your height',
      PhotosVerificationStep.language => 'Please add at least one language',
      PhotosVerificationStep.photos =>
        'Please add at least $kMinPhotos photos to continue',
      PhotosVerificationStep.complete => 'Please complete all steps',
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
    final currentStep = ref.watch(currentPhotosVerificationStepProvider);
    final isComplete = currentStep == PhotosVerificationStep.complete;
    // Photos step is skippable for the selfie portion only; a minimum of
    // kMinPhotos regular photos is required to proceed to Complete.
    final showSkip = !isComplete &&
        currentStep != PhotosVerificationStep.photos;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x5,
                AppSpacing.x14,
                AppSpacing.x5,
                AppSpacing.x4,
              ),
              child: PhotosVerificationProgressIndicator(
                currentStep: currentStep,
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    HeightInputScreen(),
                    LanguageInputScreen(),
                    AddPhotoScreen(),
                  ],
                ),
              ),
            ),
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
                  if (showSkip)
                    _SkipForNowLink(onTap: _skipStep)
                  else
                    const SizedBox.shrink(),
                  NextButton(onPressed: _nextPage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Skip for now" gradient text link — same pattern as background_screen.dart.
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
