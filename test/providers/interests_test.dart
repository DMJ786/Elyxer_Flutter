/// Unit tests for the Interests notifier + MockInterestsRepository.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dating_app_verification/models/interest_models.dart';
import 'package:dating_app_verification/providers/interests_provider.dart';
import 'package:dating_app_verification/services/interests_repository.dart';

void main() {
  ProviderContainer makeContainer({bool isPremium = true}) {
    final container = ProviderContainer(
      overrides: [
        interestsRepositoryProvider
            .overrideWithValue(MockInterestsRepository(isPremium: isPremium)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('loads received vibes + invites, defaults to Vibes tab', () async {
    final container = makeContainer();
    final state = await container.read(interestsProvider.future);

    expect(state.tab, InterestsTab.vibes);
    expect(state.isPremium, isTrue);
    expect(state.vibes, hasLength(5));
    expect(state.invites, hasLength(3));
  });

  test('setTab switches the active tab', () async {
    final container = makeContainer();
    await container.read(interestsProvider.future);
    container.read(interestsProvider.notifier).setTab(InterestsTab.invites);

    expect(
      container.read(interestsProvider).asData?.value.tab,
      InterestsTab.invites,
    );
  });

  test('passing a vibe drops it from the list', () async {
    final container = makeContainer();
    final state = await container.read(interestsProvider.future);
    final String id = state.vibes.first.id;

    await container.read(interestsProvider.notifier).passVibe(id);

    final vibes = container.read(interestsProvider).asData!.value.vibes;
    expect(vibes.any((v) => v.id == id), isFalse);
    expect(vibes, hasLength(4));
  });

  test('accepting an invite drops it from the list', () async {
    final container = makeContainer();
    final state = await container.read(interestsProvider.future);
    final String id = state.invites.first.id;

    await container.read(interestsProvider.notifier).acceptInvite(id);

    final invites = container.read(interestsProvider).asData!.value.invites;
    expect(invites.any((i) => i.id == id), isFalse);
    expect(invites, hasLength(2));
  });

  test('free users are flagged non-premium', () async {
    final container = makeContainer(isPremium: false);
    final state = await container.read(interestsProvider.future);
    expect(state.isPremium, isFalse);
  });
}
