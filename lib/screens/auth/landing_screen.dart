/// Landing Screen — the very first screen users see
/// Matches Figma: full-screen hero image, Elyxer branding, CTA buttons
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ----------------------------------------------------------------
          // Hero background image
          // Place your photo at: assets/images/auth/hero_bg.jpg
          // ----------------------------------------------------------------
          _HeroBackground(),

          // Dark gradient overlay — readable text + button area at bottom
          _DarkOverlay(),

          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // ---- Branding ----
                Text(
                  'Elyxer',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Dating Redefined"',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),

                const Spacer(),

                // ---- Bottom section ----
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x6,
                  ),
                  child: Column(
                    children: [
                      // Legal text
                      Text(
                        'By creating an account or signing in, you agree to our Terms of Service. '
                        'Learn more on how we use your data in our Privacy Policy and Cookies Policy.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x6),

                      // "Create my account" — gold gradient button
                      _GradientButton(
                        label: 'Create my account',
                        onPressed: () => context.push('/signin'),
                      ),
                      const SizedBox(height: AppSpacing.x4),

                      // "Sign in" — ghost text link
                      TextButton(
                        onPressed: () =>
                            context.push('/signin', extra: {'mode': 'signin'}),
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero background — shows a dark gradient.
// To use a real photo:
//   1. Add your image to assets/images/auth/hero_bg.jpg
//   2. Add `- assets/images/auth/` to pubspec.yaml flutter.assets
//   3. Replace Container below with:
//      Image.asset('assets/images/auth/hero_bg.jpg', fit: BoxFit.cover)
// ---------------------------------------------------------------------------

class _HeroBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C1500), Color(0xFF0D0500)],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dark gradient overlay for text legibility
// ---------------------------------------------------------------------------

class _DarkOverlay extends StatelessWidget {
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
// Reusable gold-gradient button
// ---------------------------------------------------------------------------

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.round),
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
