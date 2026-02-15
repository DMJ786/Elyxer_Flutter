/// Layer 3 - Username Input Screen
/// User enters first name (required) and last name (optional)
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
      ref.read(usernameProvider.notifier).update(usernameData);

      // Submit username
      ref.read(submitUsernameProvider(usernameData).future).then((_) {
        if (mounted) {
          setState(() => _isLoading = false);
          context.push('/email-input');
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
                    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.inProgress),
                    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.incomplete),
                    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.incomplete),
                  ],
                ),
                const SizedBox(height: AppSpacing.x8),

                // Title
                Text(
                  "Your name is your first charm",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppSpacing.x4),

                // First Name Input
                FormBuilderTextField(
                  name: 'firstName',
                  decoration: const InputDecoration(
                    hintText: 'First name (Minimum 2 characters)',
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
                const SizedBox(height: AppSpacing.x4),

                // Last Name Input (Optional)
                FormBuilderTextField(
                  name: 'lastName',
                  decoration: const InputDecoration(
                    hintText: 'Last name (Optional)',
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
                const SizedBox(height: AppSpacing.x2),

                // Helper text
                Text(
                  'This name will be visible on your Elyxer profile.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: AppColors.interactive300,
                  ),
                ),

                const Spacer(),

                // Information Banner
                const InfoBanner(
                  message: 'Genuine name builds trust and spark real connection',
                ),
                const SizedBox(height: AppSpacing.x4),

                // Footer row with link and NextButton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // TODO: Show help dialog about name change
                      },
                      child: ShaderMask(
                        shaderCallback: (bounds) => AppColors.brandGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Text(
                          'Can I change my name later?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    NextButton(
                      onPressed: _isLoading ? null : _handleContinue,
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
