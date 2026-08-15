/// Interest Models (outgoing Vibes & Invites).
///
/// Records the actions a user takes from the Discovery screen. Today these are
/// only produced (by `MockDiscoveryRepository`) and shown as a confirmation
/// toast — the Interests tab that will *consume* them (a "Sent" list) is not
/// built yet. Kept as real models now so that when the Interests module lands
/// it reads a stable shape instead of a refactor.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'discovery_models.dart';

part 'interest_models.freezed.dart';

/// Which Interests tab a list belongs to.
enum InterestsTab { vibes, invites }

/// Lifecycle of a received interest as the user responds.
enum InterestStatus { pending, accepted, passed }

/// A Vibe the current user sent, reacting to a specific part of a profile.
@freezed
abstract class SentVibe with _$SentVibe {
  const factory SentVibe({
    required String id,
    required String profileId,
    required String profileName,
    required VibeContext context,

    /// For a Join-Me-For vibe: which option was picked. Null otherwise.
    String? joinMeForOption,
    required DateTime sentAt,
  }) = _SentVibe;
}

/// An Invite the current user sent, proposing a date idea.
@freezed
abstract class SentInvite with _$SentInvite {
  const factory SentInvite({
    required String id,
    required String profileId,
    required String profileName,
    required InviteType type,
    String? note,
    required DateTime sentAt,
  }) = _SentInvite;
}

/// A Vibe another member sent to the current user (shown in Interests → Vibes).
/// The [from] profile supplies both the avatar/name and the content preview
/// (My Story text, a picture, interests, etc. — derived by [context]).
@freezed
abstract class ReceivedVibe with _$ReceivedVibe {
  const factory ReceivedVibe({
    required String id,
    required DiscoveryProfile from,
    required VibeContext context,

    /// For a Join-Me-For vibe: the option they vibed with.
    String? joinMeForOption,
    @Default(InterestStatus.pending) InterestStatus status,
  }) = _ReceivedVibe;
}

/// An Invite another member sent to the current user (Interests → Invites).
@freezed
abstract class ReceivedInvite with _$ReceivedInvite {
  const factory ReceivedInvite({
    required String id,
    required DiscoveryProfile from,
    required InviteType type,
    String? message,
    @Default(InterestStatus.pending) InterestStatus status,
  }) = _ReceivedInvite;
}
