/// Profile Studio · Layers 9 & 10 — Edit Narrative bottom sheet.
///
/// Single parametrized component covering both narrative popups (Figma still
/// duplicates the frame; we ship one widget with a `narrativeId` prop).
library;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/profile_studio_models.dart';
import '../../../providers/profile_studio_provider.dart';
import '../../../theme/app_theme.dart';
import '../widgets/profile_studio_widgets.dart';

class NarrativeEditSheet extends HookConsumerWidget {
  const NarrativeEditSheet({super.key, required this.narrativeId});

  final String narrativeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Narrative? narrative = ref
        .watch(profileStudioDataProvider)
        .narratives
        .where((Narrative n) => n.id == narrativeId)
        .firstOrNull;

    final TextEditingController titleCtrl =
        useTextEditingController(text: narrative?.title ?? '');
    final TextEditingController contentCtrl =
        useTextEditingController(text: narrative?.content ?? '');

    final int titleWords = useListenableSelector(
      titleCtrl,
      () => countWords(titleCtrl.text),
    );
    final int contentWords = useListenableSelector(
      contentCtrl,
      () => countWords(contentCtrl.text),
    );

    return EditSheetShell(
      title: 'Edit Narrative',
      onSave: () {
        ref.read(profileStudioDataProvider.notifier).updateNarrative(
              narrativeId,
              title: titleCtrl.text.trim(),
              content: contentCtrl.text.trim(),
            );
        Navigator.of(context).pop();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _FieldLabel(
            label: 'Title',
            counter: WordLimitCounter(
              current: titleWords,
              limit: WordLimits.narrativeTitle,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _boxedInput(controller: titleCtrl, maxLines: 1),
          const SizedBox(height: AppSpacing.x3),
          _FieldLabel(
            label: 'Content',
            counter: WordLimitCounter(
              current: contentWords,
              limit: WordLimits.narrativeContent,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _boxedInput(controller: contentCtrl, maxLines: 4),
        ],
      ),
    );
  }

  Widget _boxedInput({
    required TextEditingController controller,
    required int maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.interactive200),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.brandLight.withValues(alpha: 0.5),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.inter(
          fontSize: 16,
          height: 24 / 16,
          color: AppColors.interactive400,
        ),
        decoration: nakedInput(),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.counter});

  final String label;
  final Widget counter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.interactive300,
            height: 16 / 14,
          ),
        ),
        const Spacer(),
        counter,
      ],
    );
  }
}
