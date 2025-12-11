/// Layer 3 - Username Input Screen
/// User enters first name (required) and last name (optional)
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

class UsernameScreen extends ConsumerStatefulWidget {
  const UsernameScreen({super.key});

  @override
  ConsumerState<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      final firstName = _formKey.currentState!.value['firstName'] as String;
      final lastName = _formKey.currentState!.value['lastName'] as String?;

      try {
        await ref.read(verificationProvider.notifier).submitUsername(
              firstName: firstName,
              lastName: lastName ?? '',
            );

        if (mounted) {
          context.push('/email');
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
                const CustomProgressIndicator(currentStep: 2),
                const SizedBox(height: AppSpacing.x8),

                // Title
                Text(
                  "What's your name?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppSpacing.x4),

                // First Name Input
                FormBuilderTextField(
                  name: 'firstName',
                  decoration: const InputDecoration(
                    labelText: 'First name',
                    hintText: 'Enter your first name',
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(
                      2,
                      errorText: 'First name must be at least 2 characters',
                    ),
                    FormBuilderValidators.match(
                      r"^[a-zA-Z\s'-]+$",
                      errorText: 'Only letters, spaces, hyphens and apostrophes allowed',
                    ),
                  ]),
                ),
                const SizedBox(height: AppSpacing.x2),

                // Helper Text for First Name
                Text(
                  'Must be at least 2 characters',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.x4),

                // Last Name Input (Optional)
                FormBuilderTextField(
                  name: 'lastName',
                  decoration: const InputDecoration(
                    labelText: 'Last name (optional)',
                    hintText: 'Enter your last name',
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.match(
                      r"^[a-zA-Z\s'-]*$",
                      errorText: 'Only letters, spaces, hyphens and apostrophes allowed',
                    ),
                  ]),
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

                // Footer Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to support
                    },
                    child: const Text(
                      'Contact Support',
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
      ),
    );
  }
}
