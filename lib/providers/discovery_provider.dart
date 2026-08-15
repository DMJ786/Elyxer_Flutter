/// Discovery providers (Discovery Module).
///
/// Riverpod wiring over [DiscoveryRepository]. Defaults to the in-memory mock;
/// swap the one line in [discoveryRepository] for the AWS BFF impl later.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/discovery_models.dart';
import '../models/interest_models.dart';
import '../services/discovery_repository.dart';

part 'discovery_provider.g.dart';

/// The active repository impl. Mock today (no backend); becomes the BFF-backed
/// impl once AWS provisioning (#40) lands.
@Riverpod(keepAlive: true)
DiscoveryRepository discoveryRepository(Ref ref) => MockDiscoveryRepository();

/// Immutable cursor over the browse deck.
class DiscoveryDeckState {
  const DiscoveryDeckState({required this.profiles, required this.index});

  final List<DiscoveryProfile> profiles;
  final int index;

  /// The profile currently on screen, or null once the deck is exhausted.
  DiscoveryProfile? get current =>
      (index >= 0 && index < profiles.length) ? profiles[index] : null;

  bool get isExhausted => index >= profiles.length;
  bool get canUndo => index > 0;

  DiscoveryDeckState copyWith({int? index}) =>
      DiscoveryDeckState(profiles: profiles, index: index ?? this.index);
}

/// Drives the browse deck and the actions taken on the current profile.
///
/// Vibe does NOT advance the deck (a user can vibe several sections of one
/// profile); Invite / Pass / Block / Report do.
@riverpod
class DiscoveryDeck extends _$DiscoveryDeck {
  @override
  Future<DiscoveryDeckState> build() async {
    final profiles = await ref.watch(discoveryRepositoryProvider).loadDeck();
    return DiscoveryDeckState(profiles: profiles, index: 0);
  }

  DiscoveryRepository get _repo => ref.read(discoveryRepositoryProvider);

  void _advance() {
    final s = state.asData?.value;
    if (s == null) return;
    state = AsyncData(s.copyWith(index: s.index + 1));
  }

  /// Step back to the previous profile (Undo / return icon).
  void undo() {
    final s = state.asData?.value;
    if (s == null || s.index <= 0) return;
    state = AsyncData(s.copyWith(index: s.index - 1));
  }

  /// React to a section with a Vibe. Stays on the current profile.
  Future<SentVibe?> vibe(VibeContext context, {String? joinMeForOption}) async {
    final profile = state.asData?.value.current;
    if (profile == null) return null;
    return _repo.sendVibe(profile, context, joinMeForOption: joinMeForOption);
  }

  /// Send an Invite, then advance.
  Future<SentInvite?> invite(InviteType type, {String? note}) async {
    final profile = state.asData?.value.current;
    if (profile == null) return null;
    final sent = await _repo.sendInvite(profile, type, note: note);
    _advance();
    return sent;
  }

  /// Pass on the current profile.
  Future<void> pass() async {
    final profile = state.asData?.value.current;
    if (profile == null) return;
    await _repo.pass(profile.id);
    _advance();
  }

  /// Block the current profile, then advance.
  Future<void> block(BlockReason reason, {String? details}) async {
    final profile = state.asData?.value.current;
    if (profile == null) return;
    await _repo.block(profile, reason: reason, details: details);
    _advance();
  }

  /// Report the current profile, then advance.
  Future<void> report(ReportReason reason, {String? details}) async {
    final profile = state.asData?.value.current;
    if (profile == null) return;
    await _repo.report(profile, reason: reason, details: details);
    _advance();
  }
}
