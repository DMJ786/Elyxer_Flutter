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
import '../widgets/custom_button.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/next_button.dart';
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
    // Skip email verification and go to completion
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
                  "What's your email?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppSpacing.x4),

                // Email Input
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    hintText: 'Enter your email',
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
                const SizedBox(height: AppSpacing.x6),

                // Notifications Checkbox
                FormBuilderCheckbox(
                  name: 'enableNotifications',
                  initialValue: false,
                  title: Text(
                    'Stay updated with notifications',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  activeColor: AppColors.success,
                  checkColor: Colors.white,
                ),

                const Spacer(),

                // Skip Button
                CustomButton(
                  title: 'Skip for now',
                  onPressed: () => _handleSkip(),
                  variant: ButtonVariant.text,
                ),
                const SizedBox(height: AppSpacing.x6),

                // Next Button - Positioned at bottom right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
