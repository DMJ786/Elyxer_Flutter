/// Layer 4 - Email Input Screen
/// User enters email with notification preferences checkbox
/// Option to skip this step
library;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/next_button.dart';
import '../widgets/info_banner.dart';
import '../widgets/gradient_text_link.dart';
import '../providers/verification_provider.dart';
import '../models/verification_models.dart';

class EmailInputScreen extends ConsumerStatefulWidget {
  const EmailInputScreen({super.key});

  @override
  ConsumerState<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends ConsumerState<EmailInputScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  // Define progress steps
  final List<ProgressStep> _steps = const [
    ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.completed),
    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.completed),
    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.inProgress),
    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.incomplete),
  ];

  Future<void> _handleContinue() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      final email = _formKey.currentState!.value['email'] as String;
      final enableNotifications =
          _formKey.currentState!.value['enableNotifications'] as bool? ?? false;

      try {
        final service = ref.read(verificationServiceProvider);

        // Create email data
        final emailData = EmailInputData(
          email: email,
          enableNotifications: enableNotifications,
        );

        // Submit email preferences first
        await service.submitEmailPreferences(emailData);

        // Send OTP
        await service.sendEmailOTP(email);

        // Save email input data
        ref.read(emailInputProvider.notifier).update(emailData);

        if (mounted) {
          context.push('/email-otp', extra: {'email': email});
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleSkip() async {
    // Mark email as skipped and go to completion
    // This distinguishes between "user skipped" vs "user provided email"
    ref.read(emailSkippedProvider.notifier).markAsSkipped();
    
    if (mounted) {
      context.push('/complete');
    }
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
                  steps: _steps,
                  currentStep: 2,
                ),
                const SizedBox(height: AppSpacing.x8),

                // Title
                Text(
                  "Your Email keeps you connected",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppSpacing.x4),

                // Email Input
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(
                      errorText: 'Please enter a valid email address',
                    ),
                  ]),
                ),
                const SizedBox(height: AppSpacing.x2),

                // Helper text
                Text(
                  "We'll send you a verification code to confirm your email address.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: AppColors.interactive300,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),

                // Notifications Checkbox
                FormBuilderCheckbox(
                  name: 'enableNotifications',
                  initialValue: false,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stay updated',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        'Receive important notifications and updates about your account',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: AppColors.interactive300,
                        ),
                      ),
                    ],
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  activeColor: AppColors.success,
                  checkColor: Colors.white,
                ),

                const Spacer(),

                // Information Banner
                const InfoBanner(
                  message: 'Secure, private and used for verification and account recovery',
                ),
                const SizedBox(height: AppSpacing.x4),

                // Footer row with skip link and NextButton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _handleSkip(),
                      child: GradientTextLink(
                        text: 'Skip for now',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    NextButton(
                      onPressed: _isLoading ? null : () => _handleContinue(),
                      isDisabled: _isLoading,
                    ),
                  ],
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
