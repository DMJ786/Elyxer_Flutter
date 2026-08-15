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
