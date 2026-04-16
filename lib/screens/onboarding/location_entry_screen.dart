/// Location Entry Screen (Module 4 - Step 3)
/// Location search field with pin icon
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/info_banner.dart';

class LocationEntryScreen extends ConsumerStatefulWidget {
  const LocationEntryScreen({super.key});

  @override
  ConsumerState<LocationEntryScreen> createState() =>
      _LocationEntryScreenState();
}

class _LocationEntryScreenState extends ConsumerState<LocationEntryScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingDataProvider);
    _searchController = TextEditingController(text: data.locationQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Your Location',
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.x2),

          // Subtitle
          Text(
            'Your neighbourhood is shown, while your exact address stays private.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),

          // Location search field with pin icon
          SizedBox(
            height: 48,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref
                    .read(onboardingDataProvider.notifier)
                    .updateLocationQuery(value);
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  // TODO: integrate geocoding API to resolve actual coordinates
                  ref
                      .read(onboardingDataProvider.notifier)
                      .updateLocationQuery(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search your area or postcode',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/images/background/LocationSearchIcon.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Info Banner
          const InfoBanner(
            message:
                'Location helps us curate profile recommendations close to you.',
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
      ),
    );
  }
}
