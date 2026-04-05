/// Verification Flow Screen
/// Container for phone verification flow with animated page transitions
library;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../theme/app_theme.dart';
import '../models/verification_models.dart';
import '../providers/verification_provider.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/next_button.dart';
import '../widgets/info_banner.dart';
import '../widgets/otp_verification_content.dart';
import '../widgets/phone_number_input.dart';

class VerificationFlowScreen extends ConsumerStatefulWidget {
  const VerificationFlowScreen({super.key});

  @override
  ConsumerState<VerificationFlowScreen> createState() => _VerificationFlowScreenState();
}

class _VerificationFlowScreenState extends ConsumerState<VerificationFlowScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentStep = 0;

  // Progress steps
  late List<ProgressStep> _steps;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );
    _fadeController.forward();
    _updateSteps();
  }

  void _updateSteps() {
    _steps = [
      // Phone icon - covers Phone Input (step 0) and Phone OTP (step 1)
      ProgressStep(
        id: '1',
        icon: StepIcon.phone,
        status: _currentStep == 0 || _currentStep == 1
            ? StepStatus.inProgress
            : _currentStep > 1
                ? StepStatus.completed
                : StepStatus.incomplete,
      ),
      // Account icon - covers Username (step 2)
      ProgressStep(
        id: '2',
        icon: StepIcon.account,
        status: _currentStep == 2
            ? StepStatus.inProgress
            : _currentStep > 2
                ? StepStatus.completed
                : StepStatus.incomplete,
      ),
      // Mail icon - covers Email Input (step 3) and Email OTP (step 4)
      ProgressStep(
        id: '3',
        icon: StepIcon.mail,
        status: _currentStep == 3 || _currentStep == 4
            ? StepStatus.inProgress
            : _currentStep > 4
                ? StepStatus.completed
                : StepStatus.incomplete,
      ),
      // Complete icon - for completion
      ProgressStep(
        id: '4',
        icon: StepIcon.complete,
        status: StepStatus.incomplete,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_currentStep < 4) {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentStep++;
          _updateSteps();
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        _fadeController.forward();
      });
    }
  }

  void previousPage() {
    if (_currentStep > 0) {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentStep--;
          _updateSteps();
        });
        _pageController.previousPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        _fadeController.forward();
      });
    }
  }

  void navigateToOnboarding() {
    // Navigate to onboarding after email verification
    context.push('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x5,
                AppSpacing.x14,
                AppSpacing.x5,
                AppSpacing.x4,
              ),
              child: ProgressIndicatorWidget(
                steps: _steps,
                currentStep: _currentStep,
              ),
            ),

            // Page Content with Slide + Fade Animation
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                      _updateSteps();
                    });
                  },
                  children: [
                    PhoneInputContent(onNext: nextPage),
                    PhoneOTPContent(onNext: nextPage, onBack: previousPage),
                    UsernameContent(onNext: nextPage, onBack: previousPage),
                    EmailInputContent(onNext: nextPage, onBack: previousPage),
                    EmailOTPContent(onNext: navigateToOnboarding, onBack: previousPage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Phone Input Content Widget
class PhoneInputContent extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const PhoneInputContent({super.key, required this.onNext});

  @override
  ConsumerState<PhoneInputContent> createState() => _PhoneInputContentState();
}

class _PhoneInputContentState extends ConsumerState<PhoneInputContent> {
  bool _isLoading = false;
  bool _isValidPhone = false;
  PhoneNumber? _phoneNumber;

  Future<void> _handleContinue() async {
    if (!_isValidPhone || _phoneNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(verificationServiceProvider);
      final phoneData = PhoneInputData(
        countryCode: '+${_phoneNumber!.countryCode}',
        phoneNumber: _phoneNumber!.number,
      );
      await service.sendPhoneOTP(phoneData);
      ref.read(phoneInputProvider.notifier).update(phoneData);

      if (mounted) {
        widget.onNext();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          Text(
            'Elyxer will send you a text with a verification code. Message and data rates may apply.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const Spacer(),

          const InfoBanner(
            message: 'Secure, private and only used for verification',
          ),
          const SizedBox(height: AppSpacing.x4),

          // Footer row with link and NextButton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // TODO: Navigate to help/support
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'What if my phone number changes?',
                  style: TextStyle(
                    color: AppColors.brandDark,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.brandDark,
                  ),
                ),
              ),
              NextButton(
                onPressed: (_isLoading || !_isValidPhone) ? null : _handleContinue,
                isDisabled: _isLoading || !_isValidPhone,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
        ],
      ),
    );
  }
}

/// Phone OTP Content Widget
class PhoneOTPContent extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PhoneOTPContent({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneData = ref.watch(phoneInputProvider);

    if (phoneData == null || phoneData.countryCode.isEmpty || phoneData.phoneNumber.isEmpty) {
      return const Center(child: Text('Error: Phone data not found'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: OTPVerificationContent(
        subtitle: 'We sent a code to ${phoneData.countryCode} ${phoneData.phoneNumber}',
        onVerify: (code) async {
          final service = ref.read(verificationServiceProvider);
          await service.verifyPhoneOTP(phoneData, code);
          if (context.mounted) onNext();
        },
        onResend: () async {
          final service = ref.read(verificationServiceProvider);
          await service.sendPhoneOTP(phoneData);
        },
        onBack: onBack,
        backLabel: 'Change phone number',
      ),
    );
  }
}

/// Username Content Widget
class UsernameContent extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const UsernameContent({super.key, required this.onNext, required this.onBack});

  @override
  ConsumerState<UsernameContent> createState() => _UsernameContentState();
}

class _UsernameContentState extends ConsumerState<UsernameContent> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      final firstName = _formKey.currentState!.value['firstName'] as String;
      final lastName = _formKey.currentState!.value['lastName'] as String?;

      try {
        final service = ref.read(verificationServiceProvider);
        final usernameData = UsernameData(
          firstName: firstName,
          lastName: lastName,
        );
        await service.submitUsername(usernameData);
        ref.read(usernameProvider.notifier).update(usernameData);

        if (mounted) {
          widget.onNext();
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
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    );
  }
}

/// Email Input Content Widget
class EmailInputContent extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EmailInputContent({super.key, required this.onNext, required this.onBack});

  @override
  ConsumerState<EmailInputContent> createState() => _EmailInputContentState();
}

class _EmailInputContentState extends ConsumerState<EmailInputContent> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      final email = _formKey.currentState!.value['email'] as String;
      final enableNotifications =
          _formKey.currentState!.value['enableNotifications'] as bool? ?? false;

      try {
        final service = ref.read(verificationServiceProvider);
        final emailData = EmailInputData(
          email: email,
          enableNotifications: enableNotifications,
        );
        await service.submitEmailPreferences(emailData);
        await service.sendEmailOTP(email);
        ref.read(emailInputProvider.notifier).update(emailData);

        if (mounted) {
          widget.onNext();
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
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                FormBuilderValidators.email(),
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

            // Notification Preference Checkbox
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
              activeColor: AppColors.brandDark,
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
                  onPressed: widget.onNext,
                  child: ShaderMask(
                    shaderCallback: (bounds) => AppColors.brandGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: const Text(
                      'Skip for now',
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
    );
  }
}

/// Email OTP Content Widget
class EmailOTPContent extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EmailOTPContent({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailData = ref.watch(emailInputProvider);

    if (emailData == null || emailData.email.isEmpty) {
      return const Center(child: Text('Error: Email data not found'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: OTPVerificationContent(
        subtitle: 'We sent a code to ${emailData.email}',
        onVerify: (code) async {
          final service = ref.read(verificationServiceProvider);
          await service.verifyEmailOTP(emailData.email, code);
          if (context.mounted) onNext();
        },
        onResend: () async {
          final service = ref.read(verificationServiceProvider);
          await service.sendEmailOTP(emailData.email);
        },
        onBack: onBack,
        backLabel: 'Change email',
      ),
    );
  }
}
