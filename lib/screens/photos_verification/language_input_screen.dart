/// Language Input Screen (Module 5, Step 2 of 3)
/// Search + filter from SupportedLanguages.all, gradient-bordered chips
/// for selected entries, max-6 enforcement. Skippable — handled by parent.
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

  List<String> _filteredSuggestions(List<String> selected) {
    final q = _query.trim().toLowerCase();
    return SupportedLanguages.all.where((language) {
      if (selected.contains(language)) return false;
      if (q.isEmpty) return true;
      return language.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(
      photosVerificationDataProvider.select((d) => d.languages),
    );
    final notifier =
        ref.read(photosVerificationDataProvider.notifier);
    final atMax = selected.length >= kMaxLanguages;
    final suggestions = _filteredSuggestions(selected);

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
              color: AppColors.interactive300,
              height: 1.43,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),

          // Search field — disabled when max reached
          TextField(
            controller: _searchController,
            enabled: !atMax,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: atMax
                  ? "You've reached the limit"
                  : 'Search languages',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.interactive300,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.interactive300),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),

          // Selected chips
          if (selected.isNotEmpty)
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
          if (selected.isNotEmpty)
            const SizedBox(height: AppSpacing.x3),

          // Helper text
          Text(
            atMax
                ? 'You can add up to $kMaxLanguages languages'
                : '${selected.length} / $kMaxLanguages selected',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: atMax
                  ? AppColors.brandDark
                  : AppColors.interactive300,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),

          // Suggestions
          Expanded(
            child: suggestions.isEmpty
                ? const _EmptySuggestionState()
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: suggestions.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      color: AppColors.interactive100,
                    ),
                    itemBuilder: (context, index) {
                      final language = suggestions[index];
                      return InkWell(
                        onTap: atMax
                            ? null
                            : () {
                                notifier.addLanguage(language);
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.x3,
                            horizontal: AppSpacing.x2,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  language,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: AppColors.interactive500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.add,
                                color: atMax
                                    ? AppColors.interactive200
                                    : AppColors.brandDark,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: AppSpacing.x3),
          const InfoBanner(
            message:
                'Languages help us suggest matches who speak your language.',
            iconStyle: InfoBannerIcon.gradientCircle,
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Selected language chip — gradient border + × delete
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
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      padding: const EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x4,
          AppSpacing.x2,
          AppSpacing.x2,
          AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.brandGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
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
