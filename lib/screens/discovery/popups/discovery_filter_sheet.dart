/// Discovery filter sheet (issue #61) — behind the funnel icon in the header.
///
/// Edits a draft of the [DiscoveryFilters] (age range + intents) and commits
/// it on Apply; Clear restores the full deck. The deck provider watches the
/// applied filter state and re-narrows the mock deck.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/discovery_provider.dart';
import '../../../theme/app_theme.dart';
import '../../profile_studio/widgets/profile_studio_widgets.dart';

/// Opens the filter sheet as a modal bottom sheet.
Future<void> showDiscoveryFilterSheet(BuildContext context) {
  return showProfileStudioSheet<void>(
    context: context,
    child: const _DiscoveryFilterSheet(),
  );
}

class _DiscoveryFilterSheet extends ConsumerStatefulWidget {
  const _DiscoveryFilterSheet();

  @override
  ConsumerState<_DiscoveryFilterSheet> createState() =>
      _DiscoveryFilterSheetState();
}

class _DiscoveryFilterSheetState extends ConsumerState<_DiscoveryFilterSheet> {
  late RangeValues _age;
  late Set<String> _intents;

  @override
  void initState() {
    super.initState();
    final DiscoveryFilters f = ref.read(discoveryFilterStateProvider);
    _age = RangeValues(f.ageMin.toDouble(), f.ageMax.toDouble());
    _intents = <String>{...f.intents};
  }

  void _apply() {
    ref.read(discoveryFilterStateProvider.notifier).apply(
          DiscoveryFilters(
            ageMin: _age.start.round(),
            ageMax: _age.end.round(),
            intents: _intents,
          ),
        );
    Navigator.of(context).pop();
  }

  void _clear() {
    ref.read(discoveryFilterStateProvider.notifier).clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<String>> optionsAsync =
        ref.watch(discoveryIntentOptionsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.x5,
        right: AppSpacing.x5,
        top: AppSpacing.x4,
        bottom: AppSpacing.x6 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Filters',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.interactive500,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: AppColors.interactive400),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),

          // Age range -----------------------------------------------------
          Row(
            children: <Widget>[
              _label('Age'),
              const Spacer(),
              Text(
                '${_age.start.round()} – ${_age.end.round()}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandDark,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _age,
            min: DiscoveryFilters.minAge.toDouble(),
            max: DiscoveryFilters.maxAge.toDouble(),
            divisions: DiscoveryFilters.maxAge - DiscoveryFilters.minAge,
            activeColor: AppColors.brandDark,
            inactiveColor: AppColors.interactive100,
            labels: RangeLabels(
              '${_age.start.round()}',
              '${_age.end.round()}',
            ),
            onChanged: (RangeValues v) => setState(() => _age = v),
          ),
          const SizedBox(height: AppSpacing.x4),

          // Intent --------------------------------------------------------
          _label('Looking for'),
          const SizedBox(height: AppSpacing.x3),
          optionsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.x2),
              child: LinearProgressIndicator(),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (List<String> options) => Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: <Widget>[
                for (final String o in options)
                  _IntentChip(
                    label: o,
                    selected: _intents.contains(o),
                    onTap: () => setState(() {
                      if (!_intents.remove(o)) _intents.add(o);
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x6),

          // Actions -------------------------------------------------------
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: _clear,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: AppColors.interactive300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  child: Text(
                    'Clear all',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.interactive300,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: GradientCta(
                  label: 'Apply',
                  trailingArrow: false,
                  onPressed: _apply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.interactive500,
        ),
      );
}

class _IntentChip extends StatelessWidget {
  const _IntentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.brandGradient : null,
          color: selected ? null : Colors.white,
          border: Border.all(
            color: selected ? Colors.transparent : AppColors.interactive200,
          ),
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColors.interactive400,
          ),
        ),
      ),
    );
  }
}
