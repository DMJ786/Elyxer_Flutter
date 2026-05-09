/// Sign-In / Create Account Screen
/// Matches Figma: Apple, Google, and Phone number auth options
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../models/auth_models.dart';
import '../../widgets/auth/auth_background_widgets.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Navigate to onboarding once authenticated
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/onboarding');
      }
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthHeroBackground(),
          const DarkOverlay(),

          // Loading overlay with cancel control (M6)
          if (authState.isLoading)
            ColoredBox(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.brandLight,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    TextButton(
                      onPressed: () =>
                          ref.read(authProvider.notifier).cancelSignIn(),
                      child: Text(
                        AppStrings.loadingCancelLabel,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x6,
                    vertical: AppSpacing.x4,
                  ),
                  child: Text(
                    AppStrings.signInCreateAccount,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // ---- Branding ----
                const Spacer(),
                Center(
                  child: Column(
                    children: [
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
                    ],
                  ),
                ),
                const Spacer(),

                // ---- Buttons ----
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Apple Sign-In (M1: SVG asset icon)
                      _OutlinedAuthButton(
                        icon: const _AppleIcon(),
                        label: AppStrings.signInWithApple,
                        onPressed: authState.isLoading
                            ? null
                            : () => ref
                                .read(authProvider.notifier)
                                .signInWithApple(),
                      ),
                      const SizedBox(height: AppSpacing.x3),

                      // Google Sign-In (M1: SVG asset icon)
                      _OutlinedAuthButton(
                        icon: const _GoogleIcon(),
                        label: AppStrings.signInWithGoogle,
                        onPressed: authState.isLoading
                            ? null
                            : () => ref
                                .read(authProvider.notifier)
                                .signInWithGoogle(),
                      ),
                      const SizedBox(height: AppSpacing.x3),

                      // Phone Sign-In (gold gradient)
                      _GradientAuthButton(
                        label: AppStrings.signInWithPhone,
                        onPressed: authState.isLoading
                            ? null
                            : () {
                                ref
                                    .read(authProvider.notifier)
                                    .selectPhoneSignIn();
                                context.go('/verification');
                              },
                      ),
                      const SizedBox(height: AppSpacing.x4),

                      // Back link
                      Center(
                        child: TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            AppStrings.back,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),

                      // Legal text — tappable links (M7)
                      const AuthLegalText(),
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
// Outlined white button (Apple / Google)
// ---------------------------------------------------------------------------

class _OutlinedAuthButton extends StatelessWidget {
  const _OutlinedAuthButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.authButtonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.round),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: AppSpacing.x3),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gold-gradient button (Phone number)
// ---------------------------------------------------------------------------

class _GradientAuthButton extends StatelessWidget {
  const _GradientAuthButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.authButtonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? AppColors.brandGradient
              : const LinearGradient(
                  colors: [
                    AppColors.interactive200,
                    AppColors.interactive100,
                  ],
                ),
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
                  fontSize: 15,
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

// ---------------------------------------------------------------------------
// Apple logo icon — official SVG asset (M1: HIG-compliant)
// ---------------------------------------------------------------------------

class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/auth/apple_logo.svg',
      width: AppSizes.authIconSize,
      height: AppSizes.authIconSize,
      colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
    );
  }
}

// ---------------------------------------------------------------------------
// Google logo icon — official SVG asset (M1: brand-compliant)
// ---------------------------------------------------------------------------

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/auth/google_logo.svg',
      width: AppSizes.authIconSize,
      height: AppSizes.authIconSize,
    );
  }
}

