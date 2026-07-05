/// Profile Studio · Layer 8 — Edit Interests bottom sheet.
///
/// Up to 6 chips; each chip up to 2 words. Type + Add + tap × on chip to remove.
library;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/profile_studio_models.dart';
import '../../../providers/profile_studio_provider.dart';
import '../../../theme/app_theme.dart';
import '../widgets/profile_studio_widgets.dart';

class InterestsEditSheet extends HookConsumerWidget {
  const InterestsEditSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> initial =
        ref.watch(profileStudioDataProvider).interests;
    final ValueNotifier<List<String>> chips =
        useState<List<String>>(List<String>.of(initial));
    final TextEditingController controller = useTextEditingController();
    final ValueNotifier<int> wordCount = useState<int>(0);

    useEffect(() {
      void listener() => wordCount.value = countWords(controller.text);
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, <Object?>[controller]);

    void addChip() {
      final String value = controller.text.trim();
      if (value.isEmpty) return;
      if (countWords(value) > WordLimits.interestWordLimit) return;
      if (chips.value.length >= WordLimits.interestsMax) return;
      chips.value = <String>[...chips.value, value];
      controller.clear();
    }

    return EditSheetShell(
      title: 'Edit Interests',
      trailingHeader: Text(
        '${chips.value.length}/${WordLimits.interestsMax}',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.interactive300,
        ),
      ),
      onSave: () {
        ref
            .read(profileStudioDataProvider.notifier)
            .setInterests(chips.value);
        Navigator.of(context).pop();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'You can add up to ${WordLimits.interestsMax} interests',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.interactive300,
              height: 16 / 14,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                    vertical: AppSpacing.x2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(color: AppColors.interactive200),
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
                          decoration: nakedInput(
                            hintText: 'Type and press add',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: AppColors.interactive300,
                            ),
                          ),
                          onSubmitted: (_) => addChip(),
                        ),
                      ),
                      WordLimitCounter(
                        current: wordCount.value,
                        limit: WordLimits.interestWordLimit,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              OutlinedButton(
                onPressed: addChip,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.brandDark),
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ),
                child: Text(
                  'Add',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.interactive500,
                  ),
                ),
              ),
            ],
          ),
          if (chips.value.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.x3),
            Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x2,
              children: <Widget>[
                for (final String chip in chips.value)
                  InputChip(
                    label: Text(chip),
                    onDeleted: () {
                      chips.value = <String>[
                        for (final String c in chips.value)
                          if (c != chip) c,
                      ];
                    },
                    labelStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.brandDark,
                    ),
                    side: const BorderSide(color: Color(0xFFE8C97A)),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
