/// Location Entry Screen (Module 4 - Step 3)
/// Map placeholder + search field
library;

import 'package:flutter/material.dart';
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
  bool _hasLocation = false;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingDataProvider);
    _searchController = TextEditingController(text: data.locationQuery ?? '');
    _hasLocation =
        data.locationQuery != null && data.locationQuery!.isNotEmpty;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _simulateLocationSelect() {
    // Simulate selecting a location (placeholder for real map integration)
    const simulatedQuery = 'London, UK';
    _searchController.text = simulatedQuery;
    ref.read(onboardingDataProvider.notifier).updateLocation(
          latitude: 51.5074,
          longitude: -0.1278,
          query: simulatedQuery,
        );
    setState(() {
      _hasLocation = true;
    });
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

          // Map placeholder
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Map container
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.interactive50,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(
                      color: AppColors.interactive100,
                      width: 1,
                    ),
                  ),
                  child: _hasLocation
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 48,
                                color: AppColors.brandDark,
                              ),
                              const SizedBox(height: AppSpacing.x2),
                              Text(
                                _searchController.text,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.interactive400,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 64,
                                color: AppColors.interactive200,
                              ),
                              const SizedBox(height: AppSpacing.x2),
                              Text(
                                'Map preview',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.interactive200,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                // "My Location" button (bottom-right)
                Positioned(
                  bottom: AppSpacing.x3,
                  right: AppSpacing.x3,
                  child: GestureDetector(
                    onTap: _simulateLocationSelect,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.brandDark,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.brandGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

          // Search field
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
                  // Simulate location search result
                  ref.read(onboardingDataProvider.notifier).updateLocation(
                        latitude: 51.5074,
                        longitude: -0.1278,
                        query: value,
                      );
                  setState(() {
                    _hasLocation = true;
                  });
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search your area or postcode',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.interactive200,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),

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
