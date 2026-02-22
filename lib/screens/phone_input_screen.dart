/// Layer 1 - Phone Input Screen
/// User enters phone number with country code picker
/// Uses intl_phone_field for country selection with flags
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../theme/app_theme.dart';
import '../widgets/info_banner.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/next_button.dart';
import '../widgets/phone_number_input.dart';
import '../providers/verification_provider.dart';
import '../models/verification_models.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  bool _isLoading = false;
  bool _isValidPhone = false;
  PhoneNumber? _phoneNumber;

  void _handleContinue() {
    if (_phoneNumber == null || !_isValidPhone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final phoneData = PhoneInputData(
      countryCode: '+${_phoneNumber!.countryCode}',
      phoneNumber: _phoneNumber!.number,
    );

    // Store phone data in provider
    ref.read(phoneInputProvider.notifier).update(phoneData);

    // Send OTP
    ref.read(sendPhoneOTPProvider(phoneData).future).then((_) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.push('/phone-otp', extra: {
          'phoneNumber': _phoneNumber!.number,
          'countryCode': '+${_phoneNumber!.countryCode}',
        });
      }
    }).catchError((e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                currentStep: 0,
                steps: const [
                  ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.inProgress),
                  ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.incomplete),
                  ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.incomplete),
                  ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.incomplete),
                ],
              ),
              const SizedBox(height: AppSpacing.x8),

              // Title
              Text(
                "Let's verify your account",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.x4),

              // Phone Input
              PhoneNumberInput(
                onChanged: (phone) => _phoneNumber = phone,
                onValidChanged: (valid) => setState(() => _isValidPhone = valid),
              ),
              const SizedBox(height: AppSpacing.x2),

              // Helper Text
              Text(
                'Elyxer will send you a text with a verification code. Message and data rates may apply.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const Spacer(),

              // Information Banner
              const InfoBanner(
                message: 'Secure, private and only used for verification',
              ),
              const SizedBox(height: AppSpacing.x4),

              // Footer Link
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to help/support
                  },
                  child: const Text(
                    'What if my phone number changes?',
                    style: TextStyle(
                      color: AppColors.interactive400,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x6),

              // Next Button - Positioned at bottom right
              Align(
                alignment: Alignment.centerRight,
                child: NextButton(
                  onPressed: (_isLoading || !_isValidPhone) ? null : _handleContinue,
                  isDisabled: _isLoading || !_isValidPhone,
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
