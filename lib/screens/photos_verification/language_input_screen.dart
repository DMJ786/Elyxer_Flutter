/// Language Input Screen (Module 5, Step 2 of 3)
/// Search field, gradient chips for selections, max-6 enforcement.
/// Skippable — handled by the parent container.
///
/// Reconciled against Figma node 3939:23441 (Onboarding-for-AI):
/// - Plain search field (no prefix icon, no clear suffix), placeholder "Start Typing"
/// - Selected chips: gradient bg + white text + white × at 12px Inter Regular
/// - InfoBanner copy: "Helps curate recommendations, you can update this anytime."
///
/// Designer-confirmed UX:
/// - Suggestions list is hidden by default; appears only after the user
///   types into the search field. Tapping a result adds it as a chip and
///   clears the input.
/// - Helper text uses the dynamic "n / 6 selected" counter (replaced
///   Figma's static copy by mutual agreement with the designer).
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/photos_verification_models.dart';
import '../../providers/photos_verification_provider.dart';
import '../../widgets/info_banner.dart';

class LanguageInputScreen extends ConsumerStatefulWidget {
  const LanguageInputScreen({super.key});

  @override
  ConsumerState<LanguageInputScreen> createState() =>
      _LanguageInputScreenState();
}

class _LanguageInputScreenState extends ConsumerState<LanguageInputScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Ranking is defined in `models/photos_verification_models.dart` so it
  // can be unit-tested as a pure function. See `rankLanguageSuggestions`.

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(
      photosVerificationDataProvider.select((d) => d.languages),
    );
    final notifier = ref.read(photosVerificationDataProvider.notifier);
    final atMax = selected.length >= kMaxLanguages;
    final suggestions = rankLanguageSuggestions(
      query: _query,
      selected: selected,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Your Languages',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Search and add languages',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.interactive300,
              height: 16 / 14,
            ),
          ),
          const SizedBox(height: AppSpacing.x6),

          // Plain search field — no prefix icon, no clear button (per Figma).
          TextField(
            controller: _searchController,
            enabled: !atMax,
            onChanged: (v) => setState(() => _query = v),
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.interactive500,
            ),
            decoration: InputDecoration(
              hintText: atMax ? "You've reached the limit" : 'Start Typing',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.interactive300,
                height: 16 / 16,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),

          // Selected chips
          if (selected.isNotEmpty) ...[
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                for (final language in selected)
                  _SelectedLanguageChip(
                    label: language,
                    onRemove: () => notifier.removeLanguage(language),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
          ],

          // Helper text — DRIFT FLAGGED: dynamic counter vs Figma's static copy
          // pending designer reply. Keeping dynamic for now since it's strictly
          // more informative; will revert to static if designer prefers.
          Text(
            atMax
                ? 'You can add up to $kMaxLanguages languages.'
                : '${selected.length} / $kMaxLanguages selected',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  atMax ? AppColors.brandDark : AppColors.interactive300,
              height: 16 / 14,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),

          // Search results — only visible while the user is typing.
          // Renders matches as a Wrap of unselected chips (per Figma
          // LanguageSelection state=false). Tap a chip to add it as a
          // selected chip and clear the input.
          Expanded(
            child: _query.trim().isEmpty
                ? const SizedBox.shrink()
                : suggestions.isEmpty
                    ? const _EmptySuggestionState()
                    : SingleChildScrollView(
                        child: Wrap(
                          spacing: AppSpacing.x2,
                          runSpacing: AppSpacing.x2,
                          children: [
                            for (final language in suggestions)
                              _UnselectedLanguageChip(
                                label: language,
                                onTap: atMax
                                    ? null
                                    : () {
                                        notifier.addLanguage(language);
                                        _searchController.clear();
                                        setState(() => _query = '');
                                      },
                              ),
                          ],
                        ),
                      ),
          ),
          const SizedBox(height: AppSpacing.x3),
          const InfoBanner(
            message:
                'Helps curate recommendations, you can update this anytime.',
            iconStyle: InfoBannerIcon.gradientCircle,
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Selected language chip — matches Figma `LanguageSelection` (state=true):
// brand gradient bg, white 12px Inter Regular text, white 12px × icon.
// ---------------------------------------------------------------------------

class _SelectedLanguageChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _SelectedLanguageChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brandDark, width: 1),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 16 / 12,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Icons.close,
              size: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Unselected language chip — Figma `LanguageSelection` state=false:
// gray bg + 1px interactive-100 border + 12px Inter Regular #666 text,
// no × icon. Tap to promote to a selected chip.
// ---------------------------------------------------------------------------

class _UnselectedLanguageChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _UnselectedLanguageChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.interactive50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.interactive100,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: 6,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.interactive300,
            height: 16 / 12,
          ),
        ),
      ),
    );
  }
}

class _EmptySuggestionState extends StatelessWidget {
  const _EmptySuggestionState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Text(
          'No languages match your search.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.interactive300,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
