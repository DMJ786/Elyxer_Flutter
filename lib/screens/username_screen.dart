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
import '../models/verification_models.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  const UsernameScreen({super.key});

  @override
  ConsumerState<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  void _handleContinue() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      final firstName = _formKey.currentState!.value['firstName'] as String;
      final lastName = _formKey.currentState!.value['lastName'] as String?;

      final usernameData = UsernameData(
        firstName: firstName,
        lastName: lastName,
      );

      // Store username data
      ref.read(usernameProvider.notifier).state = usernameData;

      // Submit username
      ref.read(submitUsernameProvider(usernameData).future).then((_) {
        if (mounted) {
          setState(() => _isLoading = false);
          context.push('/email');
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
                  currentStep: 2,
                  steps: const [
                    ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.completed),
                    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.completed),
                    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.inProgress),
                    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.incomplete),
                  ],
                ),
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
                      RegExp(r"^[a-zA-Z\s'-]+$"),
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
                      RegExp(r"^[a-zA-Z\s'-]*$"),
                      errorText: 'Only letters, spaces, hyphens and apostrophes allowed',
                    ),
                  ]),
                ),

                const Spacer(),

                // Continue Button
                CustomButton(
                  title: 'Continue',
                  onPressed: _handleContinue,
                  isLoading: _isLoading,
                  isDisabled: _isLoading,
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
