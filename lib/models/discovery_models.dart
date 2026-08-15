/// Discovery Models (Discovery Module).
///
/// Vendor-agnostic domain models for the "Discover" tab — the profile-browse
/// experience where a user reads another member's profile and reacts with a
/// Vibe, an Invite, a Pass, or Block/Report. Like the chat models, these carry
/// no backend types: `MockDiscoveryRepository` fabricates them today and a real
/// BFF-backed impl maps into them later without touching the UI.
library;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discovery_models.freezed.dart';

/// Which part of a profile a Vibe reacts to. Drives the "Let them know you
/// vibe with their {X}" copy in the Send-a-Vibe popup. [joinMeFor] is special:
/// it opens the variant with a radio list of the member's Join-Me-For options.
enum VibeContext {
  picture,
  myStory,
  narrative,
  interests,
  joinMeFor;

  /// Bold noun shown in the popup subtitle.
  String get label {
    switch (this) {
      case VibeContext.picture:
        return 'Picture';
      case VibeContext.myStory:
        return 'My Story';
      case VibeContext.narrative:
        return 'Narrative';
      case VibeContext.interests:
        return 'Interests';
      case VibeContext.joinMeFor:
        return 'Join Me For';
    }
  }

  /// The Join-Me-For context uses the radio-list popup variant.
  bool get isJoinMeFor => this == VibeContext.joinMeFor;
}

/// A date-idea an Invite proposes. Matches the 8-card grid in the design.
enum InviteType {
  coffee,
  dinner,
  movie,
  virtualDate,
  longWalk,
  shortGetaway,
  petPlayDate,
  other;

  String get label {
    switch (this) {
      case InviteType.coffee:
        return 'Coffee';
      case InviteType.dinner:
        return 'Dinner';
      case InviteType.movie:
        return 'Movie';
      case InviteType.virtualDate:
        return 'Virtual Date';
      case InviteType.longWalk:
        return 'A long Walk';
      case InviteType.shortGetaway:
        return 'Short Getaway';
      case InviteType.petPlayDate:
        return 'Pet Play Date';
      case InviteType.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case InviteType.coffee:
        return Icons.local_cafe_outlined;
      case InviteType.dinner:
        return Icons.restaurant_outlined;
      case InviteType.movie:
        return Icons.movie_outlined;
      case InviteType.virtualDate:
        return Icons.videocam_outlined;
      case InviteType.longWalk:
        return Icons.directions_walk_outlined;
      case InviteType.shortGetaway:
        return Icons.luggage_outlined;
      case InviteType.petPlayDate:
        return Icons.pets_outlined;
      case InviteType.other:
        return Icons.more_horiz;
    }
  }
}

/// Why a member is blocking someone (Block popup reason list).
enum BlockReason {
  notInterested('Not interested'),
  inappropriateBehavior('Inappropriate behavior'),
  makingMeUncomfortable('Making me uncomfortable'),
  spamOrFakeAccount('Spam or fake account'),
  other('Other');

  const BlockReason(this.label);
  final String label;
}

/// Why a member is reporting someone (Report popup reason list).
enum ReportReason {
  notInterested('Not interested'),
  harassmentOrHateSpeech('Harassment or hate speech'),
  fakeProfileOrScam('Fake profile or scam'),
  underageOrMinor('Underage or minor'),
  other('Other');

  const ReportReason(this.label);
  final String label;
}

/// The five "About" facts shown in the tabbed info card.
@freezed
abstract class ProfileAbout with _$ProfileAbout {
  const factory ProfileAbout({
    required String gender,
    required String pronouns,
    required String orientation,
    required String education,
    required String height,
  }) = _ProfileAbout;
}

/// A titled short-form story on a profile ("THE SILENT OBSERVER" + body).
@freezed
abstract class ProfileNarrative with _$ProfileNarrative {
  const factory ProfileNarrative({
    required String title,
    required String content,
  }) = _ProfileNarrative;
}

/// A browseable member profile, as read on the Discovery screen.
@freezed
abstract class DiscoveryProfile with _$DiscoveryProfile {
  const factory DiscoveryProfile({
    required String id,
    required String name,
    required int age,
    required String occupation,
    required String location,

    /// Portrait photo urls, interleaved between the info sections.
    required List<String> photos,
    required String myStory,
    required ProfileAbout about,
    @Default(<String>[]) List<String> languages,
    @Default(<String>[]) List<String> intents,
    @Default(<String>[]) List<String> interests,
    @Default(<ProfileNarrative>[]) List<ProfileNarrative> narratives,
    @Default(<String>[]) List<String> joinMeFor,

    /// Verified badge next to the name.
    @Default(true) bool verified,
  }) = _DiscoveryProfile;
}
