/// Phone Number Input Widget
/// Shared country code picker + phone number field
library;

import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/countries.dart';
import '../theme/app_theme.dart';

class PhoneNumberInput extends StatefulWidget {
  final ValueChanged<PhoneNumber?> onChanged;
  final ValueChanged<bool> onValidChanged;

  const PhoneNumberInput({
    super.key,
    required this.onChanged,
    required this.onValidChanged,
  });

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final _phoneController = TextEditingController();
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = countries.firstWhere((country) => country.code == 'US');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      });
                      _notifyChange();
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
                _notifyChange();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _notifyChange() {
    final number = _phoneController.text;
    final isValid = number.length >= 10;
    widget.onValidChanged(isValid);
    widget.onChanged(
      PhoneNumber(
        countryISOCode: _selectedCountry.code,
        countryCode: _selectedCountry.dialCode,
        number: number,
      ),
    );
  }
}
