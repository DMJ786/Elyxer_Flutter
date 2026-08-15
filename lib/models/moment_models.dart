/// Moment Models (Moments Module).
///
/// A "moment" is a lightweight social-feed post — a candid thought (text)
/// and/or a photo, tagged with a mood. Vendor-agnostic like the other modules.
library;

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'discovery_models.dart';

part 'moment_models.freezed.dart';

/// The mood tag on a moment (SELECT YOUR MOOD grid).
enum Mood {
  littleJoys('Little joys'),
  findingCalm('Finding calm'),
  feelingGood('Feeling good'),
  inMyFeels('In my feels'),
  gratefulToday('Grateful today'),
  creativeSpark('Creative spark'),
  lostInMusic('Lost in music'),
  coffeeAndThoughts('Coffee & thoughts'),
  rainyDayMood('Rainy day mood'),
  randomThoughts('Random thoughts'),
  goldenHour('Golden hour'),
  capturedAMoment('Captured a moment');

  const Mood(this.label);
  final String label;
}

/// A single feed post.
@freezed
abstract class Moment with _$Moment {
  const factory Moment({
    required String id,

    /// The poster's profile (drives avatar/name + tap-to-preview for others).
    required DiscoveryProfile author,
    String? text,

    /// A network/seed photo URL.
    String? imageUrl,

    /// A user-picked photo, zoomed/aligned and baked to PNG bytes. Takes
    /// precedence over [imageUrl] when present.
    Uint8List? imageBytes,
    Mood? mood,

    /// Pre-formatted relative time for the mock (e.g. "2h ago").
    required String timeLabel,

    /// True when posted by the current user (menu = Edit/Delete).
    @Default(false) bool isMine,
  }) = _Moment;

  const Moment._();

  /// Name shown on the card — "You" for own moments.
  String get displayName => isMine ? 'You' : author.name;
}
