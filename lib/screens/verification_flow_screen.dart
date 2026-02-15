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
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/countries.dart';
import '../theme/app_theme.dart';
import '../models/verification_models.dart';
import '../providers/verification_provider.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/otp_input.dart';
import '../widgets/next_button.dart';
import '../widgets/info_banner.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isValidPhone = false;
  PhoneNumber? _phoneNumber;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Initialize with US as default
    _selectedCountry = countries.firstWhere((country) => country.code == 'US');
    _phoneNumber = PhoneNumber(
      countryISOCode: _selectedCountry.code,
      countryCode: _selectedCountry.dialCode,
      number: '',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
    return Form(
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

            // Phone Input with separate country code and number boxes
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Country Code Selector Box
                Container(
                  constraints: const BoxConstraints(minWidth: 110),
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.interactive50,
                    border: Border.all(
                      color: AppColors.interactive200,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await showDialog<Country>(
                          context: context,
                          builder: (context) => Theme(
                            data: Theme.of(context).copyWith(
                              scaffoldBackgroundColor: AppColors.cream,
                            ),
                            child: CountryPickerDialog(
                              filteredCountries: countries,
                              searchText: 'Search country',
                              countryList: countries,
                              selectedCountry: _selectedCountry,
                              languageCode: 'en',
                              onCountryChanged: (country) {
                                setState(() {
                                  _selectedCountry = country;
                                  _phoneNumber = PhoneNumber(
                                    countryISOCode: country.code,
                                    countryCode: country.dialCode,
                                    number: _phoneController.text,
                                  );
                                });
                              },
                              style: PickerDialogStyle(
                                backgroundColor: AppColors.cream,
                                countryNameStyle: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.interactive500,
                                ),
                                countryCodeStyle: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.interactive300,
                                ),
                                searchFieldInputDecoration: InputDecoration(
                                  hintText: 'Search country',
                                  hintStyle: const TextStyle(color: AppColors.interactive200),
                                  prefixIcon: const Icon(Icons.search, color: AppColors.interactive300),
                                  filled: true,
                                  fillColor: AppColors.interactive50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.medium),
                                    borderSide: const BorderSide(color: AppColors.interactive200),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedCountry.flag,
                                style: const TextStyle(fontSize: 24, height: 1.0),
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              Text(
                                '+${_selectedCountry.dialCode}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.interactive500,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x1),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.interactive300,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                
                // Phone Number Input Box
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.interactive500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Phone number',
                        hintStyle: const TextStyle(
                          color: AppColors.interactive200,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: AppColors.interactive50,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x4,
                          vertical: 14,
                        ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        borderSide: const BorderSide(
                          color: AppColors.interactive200,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        borderSide: const BorderSide(
                          color: AppColors.interactive200,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        borderSide: const BorderSide(
                          color: AppColors.focus,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _phoneNumber = PhoneNumber(
                          countryISOCode: _selectedCountry.code,
                          countryCode: _selectedCountry.dialCode,
                          number: value,
                        );
                        _isValidPhone = value.length >= 10;
                      });
                    },
                  ),
                  ),
                ),
              ],
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
                // Next Button - uses SVG assets with proper state handling
                NextButton(
                  onPressed: (_isLoading || !_isValidPhone) ? null : _handleContinue,
                  isDisabled: _isLoading || !_isValidPhone,
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
            },
            hasError: error.value != null,
          ),
          const SizedBox(height: AppSpacing.x2),

          // Security message
          Text(
            'For your security, don\'t share this code',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: AppColors.interactive300,
            ),
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

          // Bottom navigation row with back link and next button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onBack,
                child: ShaderMask(
                  shaderCallback: (bounds) => AppColors.brandGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: const Text(
                    'Change phone number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              NextButton(
                onPressed: (isLoading.value || otpCode.value.length != 6)
                    ? null
                    : () => verifyOTP(otpCode.value),
                isDisabled: isLoading.value || otpCode.value.length != 6,
              ),
            ],
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
class EmailOTPContent extends HookConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EmailOTPContent({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailData = ref.watch(emailInputProvider);

    // Guard clause - email data should exist by this point
    if (emailData == null || emailData.email.isEmpty) {
      return const Center(child: Text('Error: Email data not found'));
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
          await service.verifyEmailOTP(emailData.email, code);

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
        await service.sendEmailOTP(emailData.email);

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
            'We sent a code to ${emailData.email}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.x6),

          // OTP Input
          OTPInput(
            value: otpCode.value,
            onChanged: (code) {
              otpCode.value = code;
              error.value = null;
            },
            hasError: error.value != null,
          ),
          const SizedBox(height: AppSpacing.x2),

          // Security message
          Text(
            'For your security, don\'t share this code',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: AppColors.interactive300,
            ),
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

          // Bottom navigation row with back link and next button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onBack,
                child: ShaderMask(
                  shaderCallback: (bounds) => AppColors.brandGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: const Text(
                    'Change email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              NextButton(
                onPressed: (isLoading.value || otpCode.value.length != 6)
                    ? null
                    : () => verifyOTP(otpCode.value),
                isDisabled: isLoading.value || otpCode.value.length != 6,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
        ],
      ),
    );
  }
}
