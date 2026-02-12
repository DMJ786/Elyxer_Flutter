/// Age Input Screen
/// User enters their birthdate (DD/MM/YYYY)
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/info_banner.dart';

class AgeInputScreen extends ConsumerStatefulWidget {
  const AgeInputScreen({super.key});

  @override
  ConsumerState<AgeInputScreen> createState() => _AgeInputScreenState();
}

class _AgeInputScreenState extends ConsumerState<AgeInputScreen> {
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  final _dayFocus = FocusNode();
  final _monthFocus = FocusNode();
  final _yearFocus = FocusNode();

  String? _errorMessage;

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _dayFocus.dispose();
    _monthFocus.dispose();
    _yearFocus.dispose();
    super.dispose();
  }

  void _validateAndUpdate() {
    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day == null || month == null || year == null) {
      setState(() => _errorMessage = null);
      return;
    }

    // Validate ranges
    if (day < 1 || day > 31) {
      setState(() => _errorMessage = 'Invalid day');
      return;
    }
    if (month < 1 || month > 12) {
      setState(() => _errorMessage = 'Invalid month');
      return;
    }

    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear) {
      setState(() => _errorMessage = 'Invalid year');
      return;
    }

    try {
      final birthdate = DateTime(year, month, day);
      final now = DateTime.now();

      // Calculate actual age considering if birthday has passed this year
      var age = now.year - year;
      if (now.month < month || (now.month == month && now.day < day)) {
        age--;
      }

      if (age < 18) {
        setState(() => _errorMessage = 'You must be at least 18 years old');
        return;
      }

      setState(() => _errorMessage = null);

      // Debug: Check ref and notifier
      print('DEBUG: About to update birthdate');
      final notifier = ref.read(onboardingDataProvider.notifier);
      print('DEBUG: Got notifier: $notifier');
      notifier.updateBirthdate(birthdate);
      print('DEBUG: Called updateBirthdate');

      // Debug: Check if birthdate was saved
      print('DEBUG: Birthdate saved: $birthdate, Age: $age');
    } catch (e) {
      setState(() => _errorMessage = 'Invalid date');
      print('DEBUG: Date parsing failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Let's confirm your age",
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x8),

          // Birthdate Input Section
          Text(
            'Add Your Birthdate',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

          // Date inputs
          Row(
            children: [
              // Day
              Expanded(
                child: _DateField(
                  controller: _dayController,
                  focusNode: _dayFocus,
                  label: 'Date',
                  placeholder: 'DD',
                  maxLength: 2,
                  hasError: _errorMessage != null,
                  onChanged: (value) {
                    if (value.length == 2) {
                      _monthFocus.requestFocus();
                    }
                    _validateAndUpdate();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.x2),

              // Month
              Expanded(
                child: _DateField(
                  controller: _monthController,
                  focusNode: _monthFocus,
                  label: 'Month',
                  placeholder: 'MM',
                  maxLength: 2,
                  hasError: _errorMessage != null,
                  onChanged: (value) {
                    if (value.length == 2) {
                      _yearFocus.requestFocus();
                    }
                    _validateAndUpdate();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.x2),

              // Year
              Expanded(
                flex: 2,
                child: _DateField(
                  controller: _yearController,
                  focusNode: _yearFocus,
                  label: 'Year',
                  placeholder: 'YYYY',
                  maxLength: 4,
                  hasError: _errorMessage != null,
                  onChanged: (value) {
                    _validateAndUpdate();
                  },
                ),
              ),
            ],
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: AppColors.error,
                ),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  _errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ],

          const Spacer(),

          // Info Banner
          const InfoBanner(
            message: 'Used to confirm and display your age on your profile.',
            iconStyle: InfoBannerIcon.gradientCircle,
          ),
          const SizedBox(height: AppSpacing.x3),

          // Footer Link
          GestureDetector(
            onTap: () {
              // TODO: Show info dialog
            },
            child: ShaderMask(
              shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
              child: Text(
                'Can I change this later?',
                style: theme.textTheme.labelMedium?.copyWith(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String placeholder;
  final int maxLength;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  const _DateField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.placeholder,
    required this.maxLength,
    this.hasError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x2),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? AppColors.error : AppColors.interactive200,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: hasError ? AppColors.error : AppColors.interactive400,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.interactive200,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSpacing.x3),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(maxLength),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
