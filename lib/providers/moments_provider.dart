/// Moments providers (Moments Module).
library;

import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/moment_models.dart';
import '../services/moments_repository.dart';

part 'moments_provider.g.dart';

@Riverpod(keepAlive: true)
MomentsRepository momentsRepository(Ref ref) => MockMomentsRepository();

@riverpod
class MomentsFeed extends _$MomentsFeed {
  @override
  Future<List<Moment>> build() =>
      ref.watch(momentsRepositoryProvider).feed();

  MomentsRepository get _repo => ref.read(momentsRepositoryProvider);

  Future<void> share({
    String? text,
    String? imageUrl,
    Uint8List? imageBytes,
    Mood? mood,
  }) async {
    await _repo.share(
        text: text, imageUrl: imageUrl, imageBytes: imageBytes, mood: mood);
    state = AsyncData(await _repo.feed());
  }

  Future<void> edit(
    String id, {
    String? text,
    String? imageUrl,
    Uint8List? imageBytes,
    Mood? mood,
  }) async {
    await _repo.edit(id,
        text: text, imageUrl: imageUrl, imageBytes: imageBytes, mood: mood);
    state = AsyncData(await _repo.feed());
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = AsyncData(await _repo.feed());
  }
}
