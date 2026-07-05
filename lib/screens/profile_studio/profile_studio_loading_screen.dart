/// Profile Studio · loading state.
///
/// Shown after the user taps "Create My Profile" while the LLM
/// generates their story. Uses the Playfair Display heading + a soft
/// pulsing gradient dot as a low-key progress affordance.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/profile_studio_provider.dart';
import '../../theme/app_theme.dart';

class ProfileStudioLoadingScreen extends ConsumerWidget {
  const ProfileStudioLoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Object?> gen =
        ref.watch(profileStudioGenerationProvider);
    final Object? error = gen.hasError ? gen.error : null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              const _PulsingDot(),
              const SizedBox(height: AppSpacing.x6),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Crafting your ',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.interactive500,
                        height: 32 / 28,
                      ),
                    ),
                    TextSpan(
                      text: 'story',
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
              const SizedBox(height: AppSpacing.x3),
              Text(
                error != null
                    ? _errorMessage(error)
                    : 'Turning your words into a profile worth reading.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: error != null
                      ? const Color(0xFFBD4A44)
                      : AppColors.interactive300,
                  height: 20 / 14,
                ),
              ),
              const Spacer(),
              if (error != null)
                OutlinedButton(
                  onPressed: () => ref
                      .read(profileStudioGenerationProvider.notifier)
                      .run(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: AppColors.brandDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                  ),
                  child: Text(
                    'Try again',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.brandDark,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is StateError) return error.message;
    return 'Something went wrong. Please try again.';
  }
}

/// A gradient dot that fades in and out on a slow loop. Matches the
/// brand's gold gradient and doesn't compete with Material's spinner.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext _, Widget? _) {
        final double t = Curves.easeInOut.transform(_controller.value);
        return Center(
          child: Container(
            width: 24 + t * 12,
            height: 24 + t * 12,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.brandLight.withValues(alpha: 0.3 + t * 0.3),
                  blurRadius: 12 + t * 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
