/// Profile Studio · Module 6 container.
///
/// Wraps the intro → inspiration → refined flow, swapping child screens based
/// on [CurrentProfileStudioStep] with a fade transition to match Module 4.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/profile_studio_models.dart';
import '../../providers/profile_studio_provider.dart';
import 'inspiration_input_screen.dart';
import 'profile_refined_screen.dart';
import 'profile_studio_intro_screen.dart';
import 'profile_studio_loading_screen.dart';

class ProfileStudioScreen extends ConsumerStatefulWidget {
  const ProfileStudioScreen({super.key});

  @override
  ConsumerState<ProfileStudioScreen> createState() =>
      _ProfileStudioScreenState();
}

class _ProfileStudioScreenState extends ConsumerState<ProfileStudioScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileStudioStep>(
      currentProfileStudioStepProvider,
      (ProfileStudioStep? _, ProfileStudioStep next) {
        if (next == ProfileStudioStep.complete) {
          // TODO(module7): route to next module once available.
          context.go('/');
        }
      },
    );

    // When generation succeeds, advance to Refined and clear the async
    // flag so the loading screen unmounts.
    ref.listen<AsyncValue<ProfileStudioData?>>(
      profileStudioGenerationProvider,
      (AsyncValue<ProfileStudioData?>? _,
          AsyncValue<ProfileStudioData?> next) {
        next.whenOrNull(
          data: (ProfileStudioData? data) {
            if (data == null) return;
            ref
                .read(currentProfileStudioStepProvider.notifier)
                .goTo(ProfileStudioStep.refined);
            ref.read(profileStudioGenerationProvider.notifier).reset();
          },
        );
      },
    );

    final ProfileStudioStep step =
        ref.watch(currentProfileStudioStepProvider);
    final AsyncValue<ProfileStudioData?> generation =
        ref.watch(profileStudioGenerationProvider);
    final bool isGenerating =
        generation.isLoading || generation.hasError;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: isGenerating
          ? const ProfileStudioLoadingScreen(
              key: ValueKey<String>('generating'),
            )
          : switch (step) {
              ProfileStudioStep.intro => const ProfileStudioIntroScreen(
                  key: ValueKey<String>('intro'),
                ),
              ProfileStudioStep.inspiration => const InspirationInputScreen(
                  key: ValueKey<String>('inspiration'),
                ),
              ProfileStudioStep.refined => const ProfileRefinedScreen(
                  key: ValueKey<String>('refined'),
                ),
              ProfileStudioStep.complete => const SizedBox.shrink(
                  key: ValueKey<String>('complete'),
                ),
            },
    );
  }
}
