/// Sign-In / Create Account Screen
/// Matches Figma: Apple, Google, and Phone number auth options
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../models/auth_models.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Navigate to onboarding once authenticated
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/verification');
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
          // Hero background (same as landing screen)
          _HeroBackground(),
          _DarkOverlay(),

          // Loading overlay
          if (authState.isLoading)
            const ColoredBox(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.brandLight),
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
                    'Sign In / Create Account',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // ---- Branding (same as landing) ----
                const Spacer(),
                Center(
                  child: Column(
                    children: [
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
                      // Apple Sign-In
                      _OutlinedAuthButton(
                        icon: const _AppleIcon(),
                        label: 'Sign in with  Apple',
                        onPressed: authState.isLoading
                            ? null
                            : () => ref
                                .read(authProvider.notifier)
                                .signInWithApple(),
                      ),
                      const SizedBox(height: AppSpacing.x3),

                      // Google Sign-In
                      _OutlinedAuthButton(
                        icon: const _GoogleIcon(),
                        label: 'Sign in with  Google',
                        onPressed: authState.isLoading
                            ? null
                            : () => ref
                                .read(authProvider.notifier)
                                .signInWithGoogle(),
                      ),
                      const SizedBox(height: AppSpacing.x3),

                      // Phone Sign-In (gold gradient)
                      _GradientAuthButton(
                        label: 'Sign in with Phone number',
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
                            'Back',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),

                      // Legal text
                      Text(
                        'By creating an account or signing in, you agree to our '
                        'Terms of Service. Learn more on how we use your data in our '
                        'Privacy Policy and Cookies Policy.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
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
      height: 52,
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
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? AppColors.brandGradient
              : const LinearGradient(
                  colors: [Color(0xFFB0B0B0), Color(0xFFD0D0D0)]),
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
// Apple logo icon (vector-drawn, no external asset needed)
// ---------------------------------------------------------------------------

class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.apple, size: 22, color: Colors.black87);
  }
}

// ---------------------------------------------------------------------------
// Google logo icon (coloured G)
// ---------------------------------------------------------------------------

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    // Draw coloured segments approximating the Google "G" logo
    final segments = [
      // Red (top-right, ~90°)
      (startAngle: -0.52, sweepAngle: 1.57, color: const Color(0xFFEA4335)),
      // Yellow (bottom-right, ~90°)
      (startAngle: 1.05, sweepAngle: 1.57, color: const Color(0xFFFBBC05)),
      // Green (bottom-left, ~90°)
      (startAngle: 2.62, sweepAngle: 1.57, color: const Color(0xFF34A853)),
      // Blue (top-left, ~90°)
      (startAngle: 4.19, sweepAngle: 1.57, color: const Color(0xFF4285F4)),
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72),
        seg.startAngle,
        seg.sweepAngle,
        false,
        paint,
      );
    }

    // White cutout bar for the "G" horizontal stroke
    final cutPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - size.height * 0.12, r * 0.9, size.height * 0.24),
      cutPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Shared background helpers
// ---------------------------------------------------------------------------

class _HeroBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: replace with Image.asset('assets/images/auth/hero_bg.jpg', fit: BoxFit.cover)
    // after adding the image and declaring the asset folder in pubspec.yaml.
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
