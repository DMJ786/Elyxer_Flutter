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
import '../providers/verification_provider.dart';

class EmailInputScreen extends ConsumerStatefulWidget {
  const EmailInputScreen({super.key});

  @override
  ConsumerState<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends ConsumerState<EmailInputScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      final email = _formKey.currentState!.value['email'] as String;
      final enableNotifications =
          _formKey.currentState!.value['enableNotifications'] as bool? ?? false;

      try {
        // TODO: Implement verification provider
        // Submit email preferences
        // await ref.read(verificationProvider.notifier).submitEmailPreferences(
        //       email: email,
        //       enableNotifications: enableNotifications,
        //     );

        // Send OTP
        // await ref.read(verificationProvider.notifier).sendEmailOTP(email);
        await Future.delayed(const Duration(seconds: 1));

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
                const CustomProgressIndicator(currentStep: 3),
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

                // Continue Button
                CustomButton(
                  label: 'Continue',
                  onPressed: _isLoading ? null : _handleContinue,
                  isLoading: _isLoading,
                  variant: ButtonVariant.primary,
                ),
                const SizedBox(height: AppSpacing.x4),

                // Skip Button
                CustomButton(
                  label: 'Skip for now',
                  onPressed: _handleSkip,
                  variant: ButtonVariant.text,
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
