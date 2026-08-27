/// Interests Repository (Interests Module).
///
/// Serves the vibes & invites *received* by the current user and records their
/// responses. `MockInterestsRepository` fabricates them from the shared
/// Discovery seed profiles; a BFF-backed impl slots in later behind the same
/// interface.
library;

import '../models/discovery_models.dart';
import '../models/interest_models.dart';
import 'discovery_repository.dart';

abstract class InterestsRepository {
  /// Whether the user has premium — free users see the list gated (blurred).
  bool get isPremium;

  Future<List<ReceivedVibe>> receivedVibes();
  Future<List<ReceivedInvite>> receivedInvites();

  /// Accept a vibe (vibe back) → becomes a mutual connection.
  Future<void> vibeBack(String vibeId);

  /// Pass on a vibe → removed.
  Future<void> passVibe(String vibeId);

  /// Accept an invite → becomes a connection.
  Future<void> acceptInvite(String inviteId);

  /// Decline an invite → removed.
  Future<void> declineInvite(String inviteId);
}

class MockInterestsRepository implements InterestsRepository {
  MockInterestsRepository({bool isPremium = true}) : _isPremium = isPremium {
    _seed();
  }

  final bool _isPremium;
  final List<ReceivedVibe> _vibes = <ReceivedVibe>[];
  final List<ReceivedInvite> _invites = <ReceivedInvite>[];

  @override
  bool get isPremium => _isPremium;

  @override
  Future<List<ReceivedVibe>> receivedVibes() async =>
      _vibes.where((v) => v.status == InterestStatus.pending).toList();

  @override
  Future<List<ReceivedInvite>> receivedInvites() async =>
      _invites.where((i) => i.status == InterestStatus.pending).toList();

  @override
  Future<void> vibeBack(String vibeId) async => _removeVibe(vibeId);

  @override
  Future<void> passVibe(String vibeId) async => _removeVibe(vibeId);

  @override
  Future<void> acceptInvite(String inviteId) async => _removeInvite(inviteId);

  @override
  Future<void> declineInvite(String inviteId) async => _removeInvite(inviteId);

  void _removeVibe(String id) => _vibes.removeWhere((v) => v.id == id);
  void _removeInvite(String id) => _invites.removeWhere((i) => i.id == id);

  void _seed() {
    final List<DiscoveryProfile> people =
        MockDiscoveryRepository.seedProfiles;
    final DiscoveryProfile maya = people[0];
    final DiscoveryProfile aarav = people[1];
    final DiscoveryProfile zoya = people[2];

    _vibes.addAll(<ReceivedVibe>[
      ReceivedVibe(id: 'rv1', from: maya, context: VibeContext.myStory),
      ReceivedVibe(id: 'rv2', from: zoya, context: VibeContext.picture),
      ReceivedVibe(
        id: 'rv3',
        from: aarav,
        context: VibeContext.joinMeFor,
        joinMeForOption: aarav.joinMeFor.isNotEmpty ? aarav.joinMeFor.first : null,
      ),
      ReceivedVibe(id: 'rv4', from: zoya, context: VibeContext.narrative),
      ReceivedVibe(id: 'rv5', from: maya, context: VibeContext.interests),
    ]);

    _invites.addAll(<ReceivedInvite>[
      ReceivedInvite(
        id: 'ri1',
        from: aarav,
        type: InviteType.dinner,
        message:
            "It's been a while — dinner this weekend? There's a new spot "
            "downtown I've been dying to try.",
      ),
      ReceivedInvite(
        id: 'ri2',
        from: zoya,
        type: InviteType.virtualDate,
        message:
            'How about a virtual date tonight? We could cook the same recipe '
            'together over video call!',
      ),
      ReceivedInvite(id: 'ri3', from: maya, type: InviteType.coffee),
    ]);
  }
}
