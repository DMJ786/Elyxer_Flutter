/// Shared background widgets for Landing and Sign-In screens
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_theme.dart';

/// Full-screen hero background.
/// Uses the brand gradient as a fallback until a photo asset is added in PR #2.
class AuthHeroBackground extends StatelessWidget {
  const AuthHeroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A0800),
            Color(0xFF3D1C00),
            AppColors.brandDark,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

/// Semi-transparent dark scrim placed above the hero background.
class DarkOverlay extends StatelessWidget {
  const DarkOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: Color(0x55000000));
  }
}

/// Legal footer text shown on Landing and Sign-In screens.
class AuthLegalText extends StatelessWidget {
  const AuthLegalText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.legalText,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 12,
        color: Colors.white.withValues(alpha: 0.65),
        height: 1.5,
      ),
    );
  }
}
