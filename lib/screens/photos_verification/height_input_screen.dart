/// Height Input Screen (Module 5, Step 1 of 3)
/// FT/CM toggle plus scroll-wheel picker. Skippable — handled by parent.
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/photos_verification_models.dart';
import '../../providers/photos_verification_provider.dart';
import '../../widgets/info_banner.dart';

/// Picker bounds (matches Figma spec).
const int _kFeetMin = 4;
const int _kFeetMax = 6;
const int _kInchesMin = 0;
const int _kInchesMax = 11;
const int _kCmMin = 140;
const int _kCmMax = 192;

/// Defaults shown before the user scrolls.
const int _kDefaultFeet = 5;
const int _kDefaultInches = 7;
const int _kDefaultCm = 170;

class HeightInputScreen extends ConsumerStatefulWidget {
  const HeightInputScreen({super.key});

  @override
  ConsumerState<HeightInputScreen> createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends ConsumerState<HeightInputScreen> {
  late FixedExtentScrollController _feetController;
  late FixedExtentScrollController _inchesController;
  late FixedExtentScrollController _cmController;

  @override
  void initState() {
    super.initState();
    final data = ref.read(photosVerificationDataProvider);
    _feetController = FixedExtentScrollController(
      initialItem: (data.heightFeet ?? _kDefaultFeet) - _kFeetMin,
    );
    _inchesController = FixedExtentScrollController(
      initialItem: data.heightInches ?? _kDefaultInches,
    );
    _cmController = FixedExtentScrollController(
      initialItem: (data.heightCm ?? _kDefaultCm) - _kCmMin,
    );
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _cmController.dispose();
    super.dispose();
  }

  void _commitFeet() {
    final feet = _kFeetMin + _feetController.selectedItem;
    final inches = _inchesController.selectedItem;
    ref
        .read(photosVerificationDataProvider.notifier)
        .setHeightFeet(feet: feet, inches: inches);
  }

  void _commitCm() {
    final cm = _kCmMin + _cmController.selectedItem;
    ref.read(photosVerificationDataProvider.notifier).setHeightCm(cm);
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(
      photosVerificationDataProvider.select((d) => d.heightUnit),
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
              height: 1.43,
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Center(child: _UnitToggle(selected: unit)),
          const SizedBox(height: AppSpacing.x6),
          Expanded(
            child: Center(
              child: unit == HeightUnit.feet
                  ? _FeetPicker(
                      feetController: _feetController,
                      inchesController: _inchesController,
                      onChanged: _commitFeet,
                    )
                  : _CmPicker(
                      controller: _cmController,
                      onChanged: _commitCm,
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          const InfoBanner(
            message:
                'Sharing your height helps people find a better match.',
            iconStyle: InfoBannerIcon.gradientCircle,
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FT / CM toggle
// ---------------------------------------------------------------------------

class _UnitToggle extends ConsumerWidget {
  final HeightUnit selected;

  const _UnitToggle({required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brandDark, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      padding: const EdgeInsets.all(AppSpacing.x1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnitTogglePill(
            label: HeightUnit.feet.displayLabel,
            isActive: selected == HeightUnit.feet,
            onTap: () => ref
                .read(photosVerificationDataProvider.notifier)
                .setHeightUnit(HeightUnit.feet),
          ),
          _UnitTogglePill(
            label: HeightUnit.cm.displayLabel,
            isActive: selected == HeightUnit.cm,
            onTap: () => ref
                .read(photosVerificationDataProvider.notifier)
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x6,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.brandGradient : null,
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.brandDark,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FT picker (two ListWheelScrollViews — feet + inches)
// ---------------------------------------------------------------------------

class _FeetPicker extends StatelessWidget {
  final FixedExtentScrollController feetController;
  final FixedExtentScrollController inchesController;
  final VoidCallback onChanged;

  const _FeetPicker({
    required this.feetController,
    required this.inchesController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Wheel(
          controller: feetController,
          itemCount: _kFeetMax - _kFeetMin + 1,
          labelBuilder: (i) => "${_kFeetMin + i}'",
          onSelectedItemChanged: (_) => onChanged(),
        ),
        const SizedBox(width: AppSpacing.x6),
        _Wheel(
          controller: inchesController,
          itemCount: _kInchesMax - _kInchesMin + 1,
          labelBuilder: (i) => '$i"',
          onSelectedItemChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CM picker (single ListWheelScrollView)
// ---------------------------------------------------------------------------

class _CmPicker extends StatelessWidget {
  final FixedExtentScrollController controller;
  final VoidCallback onChanged;

  const _CmPicker({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Wheel(
      controller: controller,
      itemCount: _kCmMax - _kCmMin + 1,
      labelBuilder: (i) => '${_kCmMin + i} cm',
      onSelectedItemChanged: (_) => onChanged(),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable cylinder wheel with center-item gradient highlight
// ---------------------------------------------------------------------------

class _Wheel extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int index) labelBuilder;
  final ValueChanged<int> onSelectedItemChanged;

  const _Wheel({
    required this.controller,
    required this.itemCount,
    required this.labelBuilder,
    required this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    const itemExtent = 48.0;
    return SizedBox(
      width: 110,
      height: itemExtent * 5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center selection band — subtle horizontal lines bracketing the
          // active row, mirroring iOS-style wheel pickers.
          IgnorePointer(
            child: Container(
              height: itemExtent,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.interactive100,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: AppColors.interactive100,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: itemExtent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 1.6,
            perspective: 0.003,
            onSelectedItemChanged: onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final isCenter = controller.hasClients &&
                        controller.selectedItem == index;
                    final label = labelBuilder(index);
                    final textStyle = GoogleFonts.inter(
                      fontSize: isCenter ? 28 : 20,
                      fontWeight:
                          isCenter ? FontWeight.w700 : FontWeight.w400,
                      color: isCenter
                          ? Colors.white // shaded by ShaderMask below
                          : AppColors.interactive300,
                    );
                    final text = Text(label, style: textStyle);
                    if (!isCenter) {
                      return Center(child: text);
                    }
                    return Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.brandGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: text,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
