/// Profile Studio · Layer 11 — Join Me For bottom sheet.
///
/// Up to 3 experiences, each ≤ 5 words. Rows have inline word-count and a
/// 48pt hit-target close button (Figma's 24×24 SmallCloseButton fails a11y).
library;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/profile_studio_models.dart';
import '../../../providers/profile_studio_provider.dart';
import '../../../theme/app_theme.dart';
import '../widgets/profile_studio_widgets.dart';

class JoinMeForEditSheet extends HookConsumerWidget {
  const JoinMeForEditSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> initial =
        ref.watch(profileStudioDataProvider).joinMeFor;

    final List<TextEditingController> controllers = useMemoized(
      () => List<TextEditingController>.generate(
        WordLimits.joinMeForMax,
        (int i) => TextEditingController(
          text: i < initial.length ? initial[i] : '',
        ),
      ),
      const <Object?>[],
    );

    useEffect(() {
      return () {
        for (final TextEditingController c in controllers) {
          c.dispose();
        }
      };
    }, const <Object?>[]);

    return EditSheetShell(
      title: 'Join Me For',
      onSave: () {
        ref.read(profileStudioDataProvider.notifier).setJoinMeFor(
              <String>[
                for (final TextEditingController c in controllers)
                  if (c.text.trim().isNotEmpty) c.text.trim(),
              ],
            );
        Navigator.of(context).pop();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Add up to ${WordLimits.joinMeForMax} experiences you’d love to share',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.interactive300,
              height: 16 / 14,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (int i = 0; i < controllers.length; i++) ...<Widget>[
            _ExperienceRow(
              index: i,
              controller: controllers[i],
            ),
            if (i < controllers.length - 1)
              const SizedBox(height: AppSpacing.x4),
          ],
        ],
      ),
    );
  }
}

class _ExperienceRow extends HookWidget {
  const _ExperienceRow({required this.index, required this.controller});

  final int index;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final int words = useListenableSelector(
      controller,
      () => countWords(controller.text),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Experience ${index + 1}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.interactive300,
                height: 16 / 14,
              ),
            ),
            const Spacer(),
            WordLimitCounter(
              current: words,
              limit: WordLimits.joinMeForWordLimit,
              suffix: '',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.interactive200),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.interactive400,
                  ),
                  decoration: nakedInput(hintText: 'e.g. A long evening walk'),
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: () => controller.clear(),
                  icon: const Icon(
                    Icons.close,
                    size: 24,
                    color: AppColors.interactive300,
                  ),
                  tooltip: 'Clear',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
