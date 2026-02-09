/// Layer 1 - Phone Input Screen
/// User enters phone number with country code picker
/// Uses intl_phone_field for country selection with flags
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/countries.dart';

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

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_phoneNumber == null || !_isValidPhone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid phone number')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final phoneData = PhoneInputData(
        countryCode: '+${_phoneNumber!.countryCode}',
        phoneNumber: _phoneNumber!.number,
      );

      // Store phone data in provider
      ref.read(phoneInputProvider.notifier).update(phoneData);

      // Send OTP
      ref.read(sendPhoneOTPProvider(phoneData).future).then((_) {
        if (mounted) {
          setState(() => _isLoading = false);
          // Navigate to OTP verification screen
          context.push('/phone-otp', extra: {
            'phoneNumber': _phoneNumber!.number,
            'countryCode': '+${_phoneNumber!.countryCode}',
          });
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
        child: Form(
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

                // Phone Input with separate country code and number boxes
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Country Code Selector Box
                    Container(
                      constraints: const BoxConstraints(minWidth: 110),
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.interactive200,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
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
                                      fillColor: Colors.white,
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.x4,
                              vertical: 14,
                            ),
                            child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCountry.flag,
                                style: const TextStyle(fontSize: 24),
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

                    const SizedBox(width: AppSpacing.x3),
                    
                    // Phone Number Input Box
                    Expanded(
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
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
                          fillColor: Colors.white,
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
                    onPressed: (_isLoading || !_isValidPhone) ? null : _handleContinue,
                    isDisabled: _isLoading || !_isValidPhone,
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
