/// Layer 5 - Email OTP Verification Screen
/// User enters 6-digit OTP code sent to email with 2-minute timer
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../theme/app_theme.dart';
import '../widgets/otp_input.dart';
import '../widgets/progress_indicator.dart';
import '../providers/verification_provider.dart';

class EmailOTPScreen extends HookConsumerWidget {
  final String email;

  const EmailOTPScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpCode = useState('');
    final isLoading = useState(false);
    final error = useState<String?>(null);

    // Timer state
    final timeLeft = useState(120); // 2 minutes in seconds
    final canResend = useState(false);

    // Timer effect
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeLeft.value > 0) {
          timeLeft.value--;
        } else {
          canResend.value = true;
          timer.cancel();
        }
      });

      return timer.cancel;
    }, []);

    // Format timer as MM:SS
    String formatTime(int seconds) {
      final mins = seconds ~/ 60;
      final secs = seconds % 60;
      return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    // Auto-verify when OTP is complete
    Future<void> verifyOTP(String code) async {
      if (code.length == 6) {
        isLoading.value = true;
        error.value = null;

        try {
          // TODO: Implement verification provider
          // await ref.read(verificationProvider.notifier).verifyEmailOTP(code);
          await Future.delayed(const Duration(seconds: 1));

          if (context.mounted) {
            context.push('/complete');
          }
        } catch (e) {
          error.value = 'Invalid code. Please try again.';
          otpCode.value = ''; // Clear the input
        } finally {
          isLoading.value = false;
        }
      }
    }

    // Resend OTP
    Future<void> handleResend() async {
      if (!canResend.value) return;

      isLoading.value = true;
      error.value = null;

      try {
        // TODO: Implement verification provider
        // await ref.read(verificationProvider.notifier).sendEmailOTP(email);
        await Future.delayed(const Duration(seconds: 1));

        // Reset timer
        timeLeft.value = 120;
        canResend.value = false;

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code sent successfully')),
          );
        }
      } catch (e) {
        error.value = 'Failed to resend code';
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x14),

              // Progress Indicator
              const CustomProgressIndicator(currentStep: 4),
              const SizedBox(height: AppSpacing.x8),

              // Title
              Text(
                'Enter verification code',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.x2),

              // Subtitle
              Text(
                'We sent a code to $email',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x6),

              // OTP Input
              OTPInput(
                value: otpCode.value,
                length: 6,
                onCompleted: (code) {
                  otpCode.value = code;
                  verifyOTP(code);
                },
                onChanged: (code) {
                  otpCode.value = code;
                  error.value = null; // Clear error on change
                },
                hasError: error.value != null,
              ),
              const SizedBox(height: AppSpacing.x2),

              // Error message
              if (error.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.x2),
                  child: Text(
                    error.value!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.x4),

              // Timer or Resend option
              Center(
                child: canResend.value
                    ? TextButton(
                        onPressed: isLoading.value ? null : handleResend,
                        child: const Text(
                          'Resend code',
                          style: TextStyle(
                            color: AppColors.brandDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        'Code expires in ${formatTime(timeLeft.value)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              ),

              const Spacer(),

              // Loading indicator
              if (isLoading.value)
                const Center(
                  child: CircularProgressIndicator(),
                ),

              const SizedBox(height: AppSpacing.x6),

              // Change email address link
              Center(
                child: TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text(
                    'Change email address',
                    style: TextStyle(
                      color: AppColors.interactive400,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x6),
            ],
          ),
        ),
      ),
    );
  }
}
