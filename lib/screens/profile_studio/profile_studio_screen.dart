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

    final ProfileStudioStep step =
        ref.watch(currentProfileStudioStepProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: switch (step) {
        ProfileStudioStep.intro =>
          const ProfileStudioIntroScreen(key: ValueKey<String>('intro')),
        ProfileStudioStep.inspiration =>
          const InspirationInputScreen(key: ValueKey<String>('inspiration')),
        ProfileStudioStep.refined =>
          const ProfileRefinedScreen(key: ValueKey<String>('refined')),
        ProfileStudioStep.complete =>
          const SizedBox.shrink(key: ValueKey<String>('complete')),
      },
    );
  }
}
