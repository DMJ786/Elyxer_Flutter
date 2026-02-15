/// OTP Verification Content Widget
/// Shared OTP verification UI with timer, error display, resend, and loading
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../theme/app_theme.dart';
import 'otp_input.dart';

class OTPVerificationContent extends HookWidget {
  final String title;
  final String subtitle;
  final Future<void> Function(String code) onVerify;
  final Future<void> Function() onResend;
  final VoidCallback onBack;
  final String backLabel;
  final int timerDuration;

  const OTPVerificationContent({
    super.key,
    this.title = 'Enter verification code',
    required this.subtitle,
    required this.onVerify,
    required this.onResend,
    required this.onBack,
    required this.backLabel,
    this.timerDuration = 120,
  });

  @override
  Widget build(BuildContext context) {
    final otpCode = useState('');
    final isLoading = useState(false);
    final error = useState<String?>(null);

    // Timer state
    final timeLeft = useState(timerDuration);
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
    Future<void> handleVerify(String code) async {
      if (code.length == 6) {
        isLoading.value = true;
        error.value = null;

        try {
          await onVerify(code);
        } catch (e) {
          error.value = 'Invalid code. Please try again.';
          otpCode.value = '';
        } finally {
          isLoading.value = false;
        }
      }
    }

    // Resend OTP
    Future<void> handleResendCode() async {
      if (!canResend.value) return;

      isLoading.value = true;
      error.value = null;

      try {
        await onResend();

        // Reset timer
        timeLeft.value = timerDuration;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: AppSpacing.x2),

        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x6),

        // OTP Input
        OTPInput(
          value: otpCode.value,
          onChanged: (code) {
            otpCode.value = code;
            error.value = null;
            if (code.length == 6) {
              handleVerify(code);
            }
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
                  onPressed: isLoading.value ? null : handleResendCode,
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

        // Back button
        Center(
          child: TextButton(
            onPressed: onBack,
            child: Text(
              backLabel,
              style: const TextStyle(
                color: AppColors.interactive400,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x6),
      ],
    );
  }
}
