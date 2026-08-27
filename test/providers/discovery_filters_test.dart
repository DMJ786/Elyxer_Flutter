/// Discovery filters (issue #61): the applied filter state narrows the deck
/// and clearing restores it, plus the DiscoveryFilters.matches predicate.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dating_app_verification/providers/discovery_provider.dart';
import 'package:dating_app_verification/services/discovery_repository.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        discoveryRepositoryProvider.overrideWithValue(MockDiscoveryRepository()),
      ],
    );
    addTearDown(container.dispose);
  });

  // Seed deck: Maya (28), Aarav (31), Zoya (26).

  test('applying an age filter narrows the deck; clearing restores it',
      () async {
    final all = await container.read(discoveryDeckProvider.future);
    expect(all.profiles, hasLength(3));

    // 26–28 excludes Aarav (31).
    container
        .read(discoveryFilterStateProvider.notifier)
        .apply(const DiscoveryFilters(ageMin: 26, ageMax: 28));

    final filtered = await container.read(discoveryDeckProvider.future);
    expect(
      filtered.profiles.map((p) => p.name),
      containsAll(<String>['Maya', 'Zoya']),
    );
    expect(filtered.profiles.any((p) => p.name == 'Aarav'), isFalse);
    expect(filtered.index, 0, reason: 'cursor resets to the top on filter');

    // Clear restores the full deck.
    container.read(discoveryFilterStateProvider.notifier).clear();
    final restored = await container.read(discoveryDeckProvider.future);
    expect(restored.profiles, hasLength(3));
  });

  test('an intent filter keeps only matching profiles', () async {
    await container.read(discoveryDeckProvider.future);

    container
        .read(discoveryFilterStateProvider.notifier)
        .apply(const DiscoveryFilters(intents: <String>{'New Friendships'}));

    final filtered = await container.read(discoveryDeckProvider.future);
    // Only Zoya has 'New Friendships'.
    expect(filtered.profiles.map((p) => p.name), <String>['Zoya']);
  });

  test('intent options are the sorted union across the deck', () async {
    final options = await container.read(discoveryIntentOptionsProvider.future);
    expect(
      options,
      <String>[
        'Meaningful Connection',
        'New Friendships',
        'Shared Experience',
        'Something Long-term',
      ],
    );
  });

  group('DiscoveryFilters.matches', () {
    final maya =
        MockDiscoveryRepository.seedProfiles.firstWhere((p) => p.id == 'maya');
    final aarav =
        MockDiscoveryRepository.seedProfiles.firstWhere((p) => p.id == 'aarav');

    test('age bounds are inclusive', () {
      expect(const DiscoveryFilters(ageMin: 28, ageMax: 28).matches(maya),
          isTrue);
      expect(const DiscoveryFilters(ageMin: 29, ageMax: 40).matches(maya),
          isFalse);
    });

    test('intent match is ANY-of and default is unfiltered', () {
      expect(DiscoveryFilters.none.matches(aarav), isTrue);
      expect(
        const DiscoveryFilters(intents: <String>{'Something Long-term'})
            .matches(aarav),
        isTrue,
      );
      expect(
        const DiscoveryFilters(intents: <String>{'New Friendships'})
            .matches(aarav),
        isFalse,
      );
    });

    test('isActive reflects any narrowing', () {
      expect(DiscoveryFilters.none.isActive, isFalse);
      expect(const DiscoveryFilters(ageMin: 20).isActive, isTrue);
      expect(
        const DiscoveryFilters(intents: <String>{'Nature'}).isActive,
        isTrue,
      );
    });
  });
}
