/// Landing Screen — the very first screen users see
/// Matches Figma: full-screen hero image, Elyxer branding, CTA buttons
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth/auth_background_widgets.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthHeroBackground(),
          const DarkOverlay(),

          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // ---- Branding ----
                Text(
                  AppStrings.appName,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: AppSizes.brandHeadingFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  AppStrings.appTagline,
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
                      const AuthLegalText(),
                      const SizedBox(height: AppSpacing.x6),

                      _GradientButton(
                        label: AppStrings.createAccount,
                        onPressed: () => context.push('/signin'),
                      ),
                      const SizedBox(height: AppSpacing.x4),

                      TextButton(
                        onPressed: () =>
                            context.push('/signin', extra: {'mode': 'signin'}),
                        child: Text(
                          AppStrings.signIn,
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
// Gold-gradient CTA button (landing screen only)
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
      height: AppSizes.authButtonHeight,
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
