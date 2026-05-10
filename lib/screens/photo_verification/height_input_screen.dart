/// Height Input Screen (Module 5, Step 1 of 3)
/// FT/CM toggle plus a single scroll-wheel picker. Skippable — handled
/// by the parent container.
///
/// Reconciled against Figma node 3939:21222 (Onboarding-for-AI):
/// - Single wheel listing every value (4'0"–6'5" / 140–192 cm)
/// - Cream-bordered selection band at center (per `Scalesection`)
/// - FT/CM pill toggle: white background + gradient text on active
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/photo_verification_models.dart';
import '../../providers/photo_verification_provider.dart';
import '../../widgets/info_banner.dart';

const int _kFeetMin = 4;
const int _kFeetMax = 6;
const int _kCmMin = 140;
const int _kCmMax = 192;

const int _kDefaultFeet = 5;
const int _kDefaultInches = 7;
const int _kDefaultCm = 170;

const double _kItemExtent = 48;
const double _kPickerHeight = 197;

/// FT picker items: 4'0", 4'1", … 6'5". 30 entries.
int _ftIndexFor({required int feet, required int inches}) =>
    (feet - _kFeetMin) * 12 + inches;

(int feet, int inches) _ftFromIndex(int index) => (
      _kFeetMin + (index ~/ 12),
      index % 12,
    );

int get _ftItemCount => (_kFeetMax - _kFeetMin) * 12 + 6; // through 6'5"

/// CM picker items: 140, 141, … 192. 53 entries.
int _cmIndexFor(int cm) => cm - _kCmMin;
int _cmFromIndex(int index) => _kCmMin + index;
int get _cmItemCount => _kCmMax - _kCmMin + 1;

class HeightInputScreen extends ConsumerStatefulWidget {
  const HeightInputScreen({super.key});

  @override
  ConsumerState<HeightInputScreen> createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends ConsumerState<HeightInputScreen> {
  late FixedExtentScrollController _ftController;
  late FixedExtentScrollController _cmController;

  @override
  void initState() {
    super.initState();
    final data = ref.read(photoVerificationDataProvider);
    _ftController = FixedExtentScrollController(
      initialItem: _ftIndexFor(
        feet: data.heightFeet ?? _kDefaultFeet,
        inches: data.heightInches ?? _kDefaultInches,
      ),
    );
    _cmController = FixedExtentScrollController(
      initialItem: _cmIndexFor(data.heightCm ?? _kDefaultCm),
    );
  }

  @override
  void dispose() {
    _ftController.dispose();
    _cmController.dispose();
    super.dispose();
  }

  void _commitFt(int index) {
    final (feet, inches) = _ftFromIndex(index);
    ref
        .read(photoVerificationDataProvider.notifier)
        .setHeightFeet(feet: feet, inches: inches);
  }

  void _commitCm(int index) {
    ref
        .read(photoVerificationDataProvider.notifier)
        .setHeightCm(_cmFromIndex(index));
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(
      photoVerificationDataProvider.select((d) => d.heightUnit),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Your Height',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Scroll to select your height',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.interactive300,
              height: 16 / 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Center(child: _UnitToggle(selected: unit)),
          const SizedBox(height: AppSpacing.x6),
          Center(
            child: _PickerWrap(
              child: unit == HeightUnit.feet
                  ? _SingleWheel(
                      key: const ValueKey('ft-wheel'),
                      controller: _ftController,
                      itemCount: _ftItemCount,
                      labelBuilder: (i) {
                        final (feet, inches) = _ftFromIndex(i);
                        return '$feet\'$inches"';
                      },
                      onSelectedItemChanged: _commitFt,
                    )
                  : _SingleWheel(
                      key: const ValueKey('cm-wheel'),
                      controller: _cmController,
                      itemCount: _cmItemCount,
                      labelBuilder: (i) => '${_cmFromIndex(i)}',
                      onSelectedItemChanged: _commitCm,
                    ),
            ),
          ),
          const Spacer(),
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
// FT / CM toggle — white background + gradient text on the active pill,
// gray-50 background + interactive-300 text on the inactive pill.
// ---------------------------------------------------------------------------

class _UnitToggle extends ConsumerWidget {
  final HeightUnit selected;

  const _UnitToggle({required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.interactive50,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.all(AppSpacing.x1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnitTogglePill(
            label: HeightUnit.feet.displayLabel,
            isActive: selected == HeightUnit.feet,
            onTap: () => ref
                .read(photoVerificationDataProvider.notifier)
                .setHeightUnit(HeightUnit.feet),
          ),
          _UnitTogglePill(
            label: HeightUnit.cm.displayLabel,
            isActive: selected == HeightUnit.cm,
            onTap: () => ref
                .read(photoVerificationDataProvider.notifier)
                .setHeightUnit(HeightUnit.cm),
          ),
        ],
      ),
    );
  }
}

class _UnitTogglePill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _UnitTogglePill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inactive = Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.interactive300,
      ),
    );
    final active = ShaderMask(
      shaderCallback: (bounds) => AppColors.brandGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white, // shaded by ShaderMask
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x6,
          vertical: AppSpacing.x3,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: isActive ? active : inactive,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Picker wrap — outer rounded container that hosts the scrolling wheel,
// with an overlaid cream-bordered selection band at center.
// ---------------------------------------------------------------------------

class _PickerWrap extends StatelessWidget {
  final Widget child;

  const _PickerWrap({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _kPickerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: AppColors.interactive100,
          width: 2,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      // Order matters: band underneath, wheel on top so the centered item
      // renders ON TOP of the cream band (matching Figma's `Scalesection`).
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Selection band — cream interior, brand-dark 2px border, 48px tall.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x1),
            child: Container(
              height: _kItemExtent,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(
                  color: AppColors.brandDark,
                  width: 2,
                ),
              ),
            ),
          ),
          // Wheel renders on top so item text overlays the band.
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single-axis wheel picker. ListWheelScrollView with a flattened cylinder
// so it reads like a vertical list rather than an iOS roller.
// ---------------------------------------------------------------------------

class _SingleWheel extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int index) labelBuilder;
  final ValueChanged<int> onSelectedItemChanged;

  const _SingleWheel({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.labelBuilder,
    required this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _kItemExtent,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 3.0, // larger = flatter cylinder
      perspective: 0.001,
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          return Center(
            child: Text(
              labelBuilder(index),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.interactive300,
              ),
            ),
          );
        },
      ),
    );
  }
}
