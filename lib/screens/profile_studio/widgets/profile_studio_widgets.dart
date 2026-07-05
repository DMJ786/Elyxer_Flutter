/// Shared building blocks for Module 6 (Profile Studio).
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

/// "Profile Studio" mixed-italic title used across L2-L5.
class ProfileStudioTitle extends StatelessWidget {
  const ProfileStudioTitle({super.key, this.subtitle});

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: 'Profile ',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.interactive500,
                  height: 32 / 28,
                ),
              ),
              TextSpan(
                text: 'Studio',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: AppColors.brandDark,
                  height: 32 / 28,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: AppSpacing.x2),
          Text(
            subtitle!,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.interactive300,
              height: 16 / 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Full-width gradient CTA (pill shape, 48pt tall).
class GradientCta extends StatelessWidget {
  const GradientCta({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.trailingArrow = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool trailingArrow;

  @override
  Widget build(BuildContext context) {
    final bool interactive = enabled && onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.round),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: interactive ? onPressed : null,
          child: Ink(
            decoration: BoxDecoration(
              gradient: interactive ? AppColors.brandGradient : null,
              color: interactive ? null : AppColors.interactive100,
              borderRadius: BorderRadius.circular(AppRadius.round),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: interactive
                        ? Colors.white
                        : AppColors.interactive300,
                  ),
                ),
                if (trailingArrow) ...<Widget>[
                  const SizedBox(width: AppSpacing.x2),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: interactive ? Colors.white : AppColors.interactive300,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Word counter (e.g. "12/25 words"). Turns red when at/over the limit.
class WordLimitCounter extends StatelessWidget {
  const WordLimitCounter({
    super.key,
    required this.current,
    required this.limit,
    this.suffix = 'words',
  });

  final int current;
  final int limit;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final bool over = current >= limit;
    return Text(
      '$current/$limit${suffix.isEmpty ? '' : ' $suffix'}',
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: over
            ? const Color(0xFFBD4A44)
            : AppColors.interactive300,
      ),
      textAlign: TextAlign.right,
    );
  }
}

/// Bottom-sheet shell used by all 5 edit popups (L7-L11).
///
/// Renders: drag handle → optional header → body → Cancel / Save row.
class EditSheetShell extends StatelessWidget {
  const EditSheetShell({
    super.key,
    required this.title,
    required this.body,
    required this.onSave,
    this.onCancel,
    this.trailingHeader,
    this.saveEnabled = true,
  });

  final String title;
  final Widget body;
  final VoidCallback onSave;
  final VoidCallback? onCancel;
  final Widget? trailingHeader;
  final bool saveEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.x5,
        right: AppSpacing.x5,
        top: AppSpacing.x4,
        bottom: AppSpacing.x6 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.interactive100,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 32 / 20,
                    color: AppColors.interactive500,
                  ),
                ),
              ),
              if (trailingHeader != null) trailingHeader!,
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          body,
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      onCancel ?? () => Navigator.of(context).maybePop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: AppColors.interactive300),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  child: Text(
                    'Cancel',
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
                child: SizedBox(
                  height: 48,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: saveEnabled ? onSave : null,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: saveEnabled
                              ? AppColors.brandGradient
                              : null,
                          color: saveEnabled
                              ? null
                              : AppColors.interactive100,
                          borderRadius:
                              BorderRadius.circular(AppRadius.medium),
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: saveEnabled
                                  ? Colors.white
                                  : AppColors.interactive300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Build a fully "naked" [InputDecoration] that suppresses the global
/// [InputDecorationTheme]'s fill + all border states. Use this when the
/// TextField is wrapped by its own container (the Module 6 pattern).
InputDecoration nakedInput({
  String? hintText,
  TextStyle? hintStyle,
}) {
  return InputDecoration(
    filled: false,
    isDense: true,
    contentPadding: EdgeInsets.zero,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    hintText: hintText,
    hintStyle: hintStyle,
  );
}

/// Present an edit sheet with the app's standard rounded top corners.
Future<T?> showProfileStudioSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cream,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.large),
      ),
    ),
    builder: (BuildContext ctx) => child,
  );
}
