/// Unit tests for the Discovery deck notifier + MockDiscoveryRepository.
///
/// Verifies the action semantics: Vibe records but stays on the profile;
/// Invite / Pass advance; Undo steps back; Block/Report remove from a fresh
/// deck load.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dating_app_verification/models/discovery_models.dart';
import 'package:dating_app_verification/providers/discovery_provider.dart';
import 'package:dating_app_verification/services/discovery_repository.dart';

void main() {
  late MockDiscoveryRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = MockDiscoveryRepository();
    container = ProviderContainer(
      overrides: [
        discoveryRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
  });

  DiscoveryProfile? current() =>
      container.read(discoveryDeckProvider).asData?.value.current;

  test('deck loads with the first profile current', () async {
    final state = await container.read(discoveryDeckProvider.future);
    expect(state.current?.name, 'Maya');
    expect(state.canUndo, isFalse);
  });

  test('vibe records the action but stays on the same profile', () async {
    await container.read(discoveryDeckProvider.future);
    final notifier = container.read(discoveryDeckProvider.notifier);

    await notifier.vibe(VibeContext.myStory);

    expect(repo.sentVibes, hasLength(1));
    expect(repo.sentVibes.single.context, VibeContext.myStory);
    expect(current()?.name, 'Maya', reason: 'vibe must not advance the deck');
  });

  test('join-me-for vibe carries the chosen option', () async {
    await container.read(discoveryDeckProvider.future);
    final notifier = container.read(discoveryDeckProvider.notifier);

    await notifier.vibe(VibeContext.joinMeFor,
        joinMeForOption: 'Grabbing a quiet coffee');

    expect(repo.sentVibes.single.joinMeForOption, 'Grabbing a quiet coffee');
  });

  test('invite records the action and advances', () async {
    await container.read(discoveryDeckProvider.future);
    final notifier = container.read(discoveryDeckProvider.notifier);

    await notifier.invite(InviteType.coffee, note: 'Would love to!');

    expect(repo.sentInvites, hasLength(1));
    expect(repo.sentInvites.single.type, InviteType.coffee);
    expect(repo.sentInvites.single.note, 'Would love to!');
    expect(current()?.name, 'Aarav');
  });

  test('pass advances and undo steps back', () async {
    await container.read(discoveryDeckProvider.future);
    final notifier = container.read(discoveryDeckProvider.notifier);

    await notifier.pass();
    expect(current()?.name, 'Aarav');

    notifier.undo();
    expect(current()?.name, 'Maya');
  });

  test('blocking removes the profile from a fresh deck load', () async {
    final maya = (await repo.loadDeck()).first;
    await repo.block(maya, reason: BlockReason.spamOrFakeAccount);

    final deck = await repo.loadDeck();
    expect(deck.any((p) => p.id == 'maya'), isFalse);
  });

  test('deck exhausts after passing every profile', () async {
    final state = await container.read(discoveryDeckProvider.future);
    final notifier = container.read(discoveryDeckProvider.notifier);

    for (var i = 0; i < state.profiles.length; i++) {
      await notifier.pass();
    }

    expect(current(), isNull);
    expect(container.read(discoveryDeckProvider).asData?.value.isExhausted,
        isTrue);
  });
}
