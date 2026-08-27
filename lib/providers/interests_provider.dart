/// Interests providers (Interests Module).
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/interest_models.dart';
import '../services/interests_repository.dart';

part 'interests_provider.g.dart';

@Riverpod(keepAlive: true)
InterestsRepository interestsRepository(Ref ref) => MockInterestsRepository();

/// Immutable state for the Interests screen.
class InterestsState {
  const InterestsState({
    required this.tab,
    required this.isPremium,
    required this.vibes,
    required this.invites,
  });

  final InterestsTab tab;
  final bool isPremium;
  final List<ReceivedVibe> vibes;
  final List<ReceivedInvite> invites;

  int get vibeCount => vibes.length;
  int get inviteCount => invites.length;

  InterestsState copyWith({
    InterestsTab? tab,
    List<ReceivedVibe>? vibes,
    List<ReceivedInvite>? invites,
  }) =>
      InterestsState(
        tab: tab ?? this.tab,
        isPremium: isPremium,
        vibes: vibes ?? this.vibes,
        invites: invites ?? this.invites,
      );
}

@riverpod
class Interests extends _$Interests {
  @override
  Future<InterestsState> build() async {
    final InterestsRepository repo = ref.watch(interestsRepositoryProvider);
    final vibes = await repo.receivedVibes();
    final invites = await repo.receivedInvites();
    return InterestsState(
      tab: InterestsTab.vibes,
      isPremium: repo.isPremium,
      vibes: vibes,
      invites: invites,
    );
  }

  InterestsRepository get _repo => ref.read(interestsRepositoryProvider);

  void setTab(InterestsTab tab) {
    final InterestsState? s = state.asData?.value;
    if (s == null) return;
    state = AsyncData(s.copyWith(tab: tab));
  }

  Future<void> vibeBack(String id) async {
    await _repo.vibeBack(id);
    _dropVibe(id);
  }

  Future<void> passVibe(String id) async {
    await _repo.passVibe(id);
    _dropVibe(id);
  }

  Future<void> acceptInvite(String id) async {
    await _repo.acceptInvite(id);
    _dropInvite(id);
  }

  Future<void> declineInvite(String id) async {
    await _repo.declineInvite(id);
    _dropInvite(id);
  }

  void _dropVibe(String id) {
    final InterestsState? s = state.asData?.value;
    if (s == null) return;
    state = AsyncData(
      s.copyWith(vibes: s.vibes.where((v) => v.id != id).toList()),
    );
  }

  void _dropInvite(String id) {
    final InterestsState? s = state.asData?.value;
    if (s == null) return;
    state = AsyncData(
      s.copyWith(invites: s.invites.where((i) => i.id != id).toList()),
    );
  }
}
