/// Layer 2 - Phone OTP Verification Screen
/// User enters 6-digit OTP code with 2-minute timer
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/otp_verification_content.dart';
import '../providers/verification_provider.dart';
import '../models/verification_models.dart';

class PhoneOTPScreen extends ConsumerWidget {
  final String phoneNumber;
  final String countryCode;

  const PhoneOTPScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });

  static const List<ProgressStep> _steps = [
    ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.inProgress),
    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.incomplete),
    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.incomplete),
    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.incomplete),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ProgressIndicatorWidget(
                steps: _steps,
                currentStep: 1,
              ),
              const SizedBox(height: AppSpacing.x8),

              // OTP Verification Content
              Expanded(
                child: OTPVerificationContent(
                  subtitle: 'We sent a code to $countryCode $phoneNumber',
                  onVerify: (code) async {
                    final service = ref.read(verificationServiceProvider);
                    final phoneData = PhoneInputData(
                      countryCode: countryCode,
                      phoneNumber: phoneNumber,
                    );
                    await service.verifyPhoneOTP(phoneData, code);
                    if (context.mounted) {
                      context.push('/username');
                    }
                  },
                  onResend: () async {
                    final service = ref.read(verificationServiceProvider);
                    final phoneData = PhoneInputData(
                      countryCode: countryCode,
                      phoneNumber: phoneNumber,
                    );
                    await service.sendPhoneOTP(phoneData);
                  },
                  onBack: () => context.pop(),
                  backLabel: 'Change phone number',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
