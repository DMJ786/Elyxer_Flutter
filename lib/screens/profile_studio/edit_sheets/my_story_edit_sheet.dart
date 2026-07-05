/// Profile Studio · Layer 7 — Edit My Story bottom sheet.
library;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/profile_studio_models.dart';
import '../../../providers/profile_studio_provider.dart';
import '../../../theme/app_theme.dart';
import '../widgets/profile_studio_widgets.dart';

class MyStoryEditSheet extends HookConsumerWidget {
  const MyStoryEditSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String initial =
        ref.watch(profileStudioDataProvider).myStory;
    final TextEditingController controller =
        useTextEditingController(text: initial);
    final int words = useListenableSelector(
      controller,
      () => countWords(controller.text),
    );

    return EditSheetShell(
      title: 'Edit My Story',
      trailingHeader: WordLimitCounter(
        current: words,
        limit: WordLimits.myStory,
      ),
      onSave: () {
        ref
            .read(profileStudioDataProvider.notifier)
            .updateMyStory(controller.text.trim());
        Navigator.of(context).pop();
      },
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.interactive100),
        ),
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: TextField(
          controller: controller,
          maxLines: 4,
          style: GoogleFonts.inter(
            fontSize: 16,
            height: 24 / 16,
            color: AppColors.interactive400,
          ),
          decoration: nakedInput(
            hintText:
                "I'm someone who brings the same focus to my personal life…",
          ),
        ),
      ),
    );
  }
}
