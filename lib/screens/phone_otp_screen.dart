/// Layer 2 - Phone OTP Verification Screen
/// User enters 6-digit OTP code with 2-minute timer
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../theme/app_theme.dart';
import '../widgets/otp_input.dart';
import '../widgets/next_button.dart';
import '../providers/verification_provider.dart';

class PhoneOTPScreen extends HookConsumerWidget {
  final String phoneNumber;
  final String countryCode;

  const PhoneOTPScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
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
          // await ref.read(verificationProvider.notifier).verifyPhoneOTP(code);
          await Future.delayed(const Duration(seconds: 1));

          if (context.mounted) {
            context.push('/username');
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
        // await ref.read(verificationProvider.notifier).sendPhoneOTP(
        //       countryCode: countryCode,
        //       phoneNumber: phoneNumber,
        //     );
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Enter verification code',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x2),

          // Subtitle
          Text(
                'We sent a code to $countryCode $phoneNumber',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x6),

              // OTP Input
              OTPInput(
                value: otpCode.value,
                length: 6,
                onCompleted: (code) {
                  otpCode.value = code;
                  // Don't auto-verify, wait for Next button
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

              // Change phone number link - aligned to the right
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: ShaderMask(
                    shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
                    child: const Text(
                      'Change phone number',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Next Button at bottom
              Align(
                alignment: Alignment.centerRight,
                child: NextButton(
                  onPressed: otpCode.value.length == 6 
                      ? () {
                          verifyOTP(otpCode.value);
                        }
                      : null,
                  isLoading: isLoading.value,
                  isEnabled: otpCode.value.length == 6,
                ),
              ),
              const SizedBox(height: AppSpacing.x6),
            ],
          ),
        );
  }
}
