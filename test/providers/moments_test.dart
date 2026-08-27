/// Unit tests for the Moments feed notifier + MockMomentsRepository.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dating_app_verification/models/moment_models.dart';
import 'package:dating_app_verification/providers/moments_provider.dart';
import 'package:dating_app_verification/services/moments_repository.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        momentsRepositoryProvider.overrideWithValue(MockMomentsRepository()),
      ],
    );
    addTearDown(container.dispose);
  });

  test('feed loads seed moments', () async {
    final feed = await container.read(momentsFeedProvider.future);
    expect(feed, hasLength(5));
    expect(feed.any((m) => m.isMine), isTrue);
    expect(feed.any((m) => !m.isMine), isTrue);
  });

  test('sharing prepends a new own moment', () async {
    await container.read(momentsFeedProvider.future);
    await container
        .read(momentsFeedProvider.notifier)
        .share(text: 'A quiet win today', mood: Mood.gratefulToday);

    final feed = container.read(momentsFeedProvider).asData!.value;
    expect(feed, hasLength(6));
    expect(feed.first.isMine, isTrue);
    expect(feed.first.text, 'A quiet win today');
    expect(feed.first.mood, Mood.gratefulToday);
  });

  test('deleting removes a moment', () async {
    final feed = await container.read(momentsFeedProvider.future);
    final String id = feed.first.id;

    await container.read(momentsFeedProvider.notifier).delete(id);

    final updated = container.read(momentsFeedProvider).asData!.value;
    expect(updated.any((m) => m.id == id), isFalse);
    expect(updated, hasLength(4));
  });

  test('editing updates the text and mood', () async {
    final feed = await container.read(momentsFeedProvider.future);
    final Moment mine = feed.firstWhere((m) => m.isMine);

    await container
        .read(momentsFeedProvider.notifier)
        .edit(mine.id, text: 'Edited thought', mood: Mood.goldenHour);

    final updated = container
        .read(momentsFeedProvider)
        .asData!
        .value
        .firstWhere((m) => m.id == mine.id);
    expect(updated.text, 'Edited thought');
    expect(updated.mood, Mood.goldenHour);
  });

  test('displayName is "You" for own moments', () async {
    final feed = await container.read(momentsFeedProvider.future);
    final Moment mine = feed.firstWhere((m) => m.isMine);
    expect(mine.displayName, 'You');
  });
}
