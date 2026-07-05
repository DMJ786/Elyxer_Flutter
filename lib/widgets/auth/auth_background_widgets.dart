/// Shared background widgets reused by LandingScreen and SignInScreen.
/// Extracted here per CLAUDE.md: "All reusable widgets in lib/widgets/".
library;

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_strings.dart';
import '../../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// AuthHeroBackground
// ---------------------------------------------------------------------------

/// Full-bleed hero image used behind both landing and sign-in screens.
/// Falls back to a dark brand gradient when the asset hasn't loaded.
class AuthHeroBackground extends StatelessWidget {
  const AuthHeroBackground({
    super.key,
    this.imagePath = 'assets/images/auth/Signin_background.png',
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.heroGradientDeep, AppColors.heroGradientDark],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DarkOverlay
// ---------------------------------------------------------------------------

/// Scrim gradient that improves text legibility over the hero image.
class DarkOverlay extends StatelessWidget {
  const DarkOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.85),
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AuthLegalText
// ---------------------------------------------------------------------------

/// Legal disclaimer with tappable Terms-of-Service, Privacy Policy, and
/// Cookies Policy links (M7 — app-store reviewer requirement).
class AuthLegalText extends StatefulWidget {
  const AuthLegalText({super.key});

  @override
  State<AuthLegalText> createState() => _AuthLegalTextState();
}

class _AuthLegalTextState extends State<AuthLegalText> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _cookiesRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => _launch(AppStrings.termsUrl);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => _launch(AppStrings.privacyUrl);
    _cookiesRecognizer = TapGestureRecognizer()
      ..onTap = () => _launch(AppStrings.cookiesUrl);
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _cookiesRecognizer.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.inter(
      fontSize: 11,
      color: Colors.white.withValues(alpha: 0.7),
      height: 1.5,
    );
    const linkStyle = TextStyle(
      decoration: TextDecoration.underline,
      color: Colors.white,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: AppStrings.legalPrefix),
          TextSpan(
            text: AppStrings.termsOfService,
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
          const TextSpan(text: AppStrings.legalMiddle),
          TextSpan(
            text: AppStrings.privacyPolicy,
            style: linkStyle,
            recognizer: _privacyRecognizer,
          ),
          const TextSpan(text: AppStrings.legalConjunction),
          TextSpan(
            text: AppStrings.cookiesPolicy,
            style: linkStyle,
            recognizer: _cookiesRecognizer,
          ),
          const TextSpan(text: AppStrings.legalSuffix),
        ],
      ),
    );
  }
}
