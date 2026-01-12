/// Layer 1 - Phone Input Screen
/// User enters phone number with country code picker
library;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/info_banner.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/next_button.dart';
import '../providers/verification_provider.dart';
import '../models/verification_models.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _selectedCountryCode = '+1';
  bool _isLoading = false;

  void _handleContinue() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      final phoneNumber = _formKey.currentState!.value['phoneNumber'] as String;
      final phoneData = PhoneInputData(
        countryCode: _selectedCountryCode,
        phoneNumber: phoneNumber,
      );

      // Store phone data in provider
      ref.read(phoneInputProvider.notifier).state = phoneData;

      // Send OTP (fire and forget or handle async separately)
      ref.read(sendPhoneOTPProvider(phoneData).future).then((_) {
        if (mounted) {
          setState(() => _isLoading = false);
          // Navigate to OTP verification screen
          context.push('/phone-otp');
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
  }

  void _showCountryCodePicker() {
    // TODO: Implement full country code picker modal
    // For now, showing a simple bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Country Code',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.x4),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text('United States'),
              trailing: const Text('+1'),
              onTap: () {
                setState(() => _selectedCountryCode = '+1');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇮🇳', style: TextStyle(fontSize: 24)),
              title: const Text('India'),
              trailing: const Text('+91'),
              onTap: () {
                setState(() => _selectedCountryCode = '+91');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('United Kingdom'),
              trailing: const Text('+44'),
              onTap: () {
                setState(() => _selectedCountryCode = '+44');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
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

                // Input Row: Country Code + Phone Number
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Code Picker
                    InkWell(
                      onTap: _showCountryCodePicker,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Container(
                        width: 99,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.interactive200,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedCountryCode,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.interactive500,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.interactive300,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),

                    // Phone Number Input
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'phoneNumber',
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.match(
                            RegExp(r'^[0-9]{10}$'),
                            errorText: 'Enter a valid 10-digit phone number',
                          ),
                        ]),
                      ),
                    ),
                  ],
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
                    onPressed: _isLoading ? null : _handleContinue,
                    isDisabled: _isLoading,
                  ),
                ),
                const SizedBox(height: AppSpacing.x6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
