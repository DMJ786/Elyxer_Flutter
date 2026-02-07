/// Verification Flow Screen
/// Container for phone verification flow with animated page transitions
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../models/verification_models.dart';
import '../providers/verification_provider.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/otp_input.dart';
import '../widgets/next_button.dart';

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
      ProgressStep(
        id: '1',
        icon: StepIcon.phone,
        status: _currentStep == 0
            ? StepStatus.inProgress
            : _currentStep > 0
                ? StepStatus.completed
                : StepStatus.incomplete,
      ),
      ProgressStep(
        id: '2',
        icon: StepIcon.account,
        status: _currentStep == 1
            ? StepStatus.inProgress
            : _currentStep > 1
                ? StepStatus.completed
                : StepStatus.incomplete,
      ),
      ProgressStep(
        id: '3',
        icon: StepIcon.mail,
        status: StepStatus.incomplete,
      ),
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
    if (_currentStep < 2) {
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
    // Navigate to onboarding flow
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
                    UsernameContent(onNext: navigateToOnboarding, onBack: previousPage),
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
  final _formKey = GlobalKey<FormBuilderState>();
  String _selectedCountryCode = '+1';
  bool _isLoading = false;

  Future<void> _handleContinue() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);

      final phoneNumber = _formKey.currentState!.value['phoneNumber'] as String;

      try {
        final service = ref.read(verificationServiceProvider);
        final phoneData = PhoneInputData(
          countryCode: _selectedCountryCode,
          phoneNumber: phoneNumber,
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
  }

  void _showCountryCodePicker() {
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
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's verify your account",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.x4),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Expanded(
                  child: FormBuilderTextField(
                    name: 'phoneNumber',
                    decoration: const InputDecoration(hintText: 'Phone number'),
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

            Text(
              'Elyxer will send you a text with a verification code.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(AppSpacing.x4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brandDark),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.x2),
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Text(
                      'Secure, private and only used for verification',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x6),

            // Next Button - uses SVG assets with proper state handling
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
    );
  }
}

/// Phone OTP Content Widget
class PhoneOTPContent extends HookConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PhoneOTPContent({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneData = ref.watch(phoneInputProvider);

    // Guard clause - phone data should exist by this point
    if (phoneData == null || phoneData.countryCode.isEmpty || phoneData.phoneNumber.isEmpty) {
      return const Center(child: Text('Error: Phone data not found'));
    }

    final otpCode = useState('');
    final isLoading = useState(false);
    final error = useState<String?>(null);

    // Timer state
    final timeLeft = useState(120); // 2 minutes in seconds
    final canResend = useState(false);

    // Timer effect
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeLeft.value > 0) {
          timeLeft.value--;
        } else {
          canResend.value = true;
          timer.cancel();
        }
      });

      return timer.cancel;
    }, []);

    // Format timer as MM:SS
    String formatTime(int seconds) {
      final mins = seconds ~/ 60;
      final secs = seconds % 60;
      return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    // Auto-verify when OTP is complete
    Future<void> verifyOTP(String code) async {
      if (code.length == 6) {
        isLoading.value = true;
        error.value = null;

        try {
          final service = ref.read(verificationServiceProvider);
          await service.verifyPhoneOTP(phoneData, code);

          if (context.mounted) {
            onNext();
          }
        } catch (e) {
          error.value = 'Invalid code. Please try again.';
          otpCode.value = ''; // Clear the input
        } finally {
          isLoading.value = false;
        }
      }
    }

    // Resend OTP
    Future<void> handleResend() async {
      if (!canResend.value) return;

      isLoading.value = true;
      error.value = null;

      try {
        final service = ref.read(verificationServiceProvider);
        await service.sendPhoneOTP(phoneData);

        // Reset timer
        timeLeft.value = 120;
        canResend.value = false;

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code sent successfully')),
          );
        }
      } catch (e) {
        error.value = 'Failed to resend code';
      } finally {
        isLoading.value = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter verification code',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x2),

          Text(
            'We sent a code to ${phoneData.countryCode} ${phoneData.phoneNumber}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.x6),

          // OTP Input
          OTPInput(
            value: otpCode.value,
            onChanged: (code) {
              otpCode.value = code;
              error.value = null;
              if (code.length == 6) {
                verifyOTP(code);
              }
            },
            hasError: error.value != null,
          ),
          const SizedBox(height: AppSpacing.x2),

          // Error message
          if (error.value != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.x2),
              child: Text(
                error.value!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 14,
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.x4),

          // Timer or Resend option
          Center(
            child: canResend.value
                ? TextButton(
                    onPressed: isLoading.value ? null : handleResend,
                    child: const Text(
                      'Resend code',
                      style: TextStyle(
                        color: AppColors.brandDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    'Code expires in ${formatTime(timeLeft.value)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
          ),

          const Spacer(),

          // Loading indicator
          if (isLoading.value)
            const Center(
              child: CircularProgressIndicator(),
            ),

          const SizedBox(height: AppSpacing.x6),

          // Back button
          Center(
            child: TextButton(
              onPressed: onBack,
              child: const Text(
                'Change phone number',
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

            // Next Button - uses SVG assets with proper state handling
            Align(
              alignment: Alignment.centerRight,
              child: NextButton(
                onPressed: _isLoading ? null : _handleContinue,
                isDisabled: _isLoading,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),

            // Footer Link
            Center(
              child: TextButton(
                onPressed: widget.onBack,
                child: const Text(
                  'Go back',
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
    );
  }
}
