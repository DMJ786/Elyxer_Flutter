/// Photos & Selfie Verification Models (Module 5)
/// Holds height, language, photo, and selfie verification state.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'photos_verification_models.freezed.dart';

/// Maximum number of languages a user can select
const int kMaxLanguages = 6;

/// Minimum number of regular photos required to proceed
const int kMinPhotos = 4;

/// Maximum number of regular (non-selfie) photos
const int kMaxPhotos = 5;

/// Module 5 step enum: Height → Language → Photos → Complete.
/// Mirrors BackgroundStep / OnboardingStep convention with `isLast`.
enum PhotosVerificationStep {
  height,
  language,
  photos,
  complete;

  bool get isLast => this == PhotosVerificationStep.complete;
}

/// Height unit toggle (FT shows feet+inches wheels, CM shows single wheel).
enum HeightUnit {
  feet,
  cm;

  String get displayLabel {
    switch (this) {
      case HeightUnit.feet:
        return 'FT';
      case HeightUnit.cm:
        return 'CM';
    }
  }
}

/// Module 5 data — kept separate from OnboardingData to avoid bloating
/// the shared model with file-system / verification concerns.
@freezed
abstract class PhotosVerificationData with _$PhotosVerificationData {
  const factory PhotosVerificationData({
    int? heightFeet,
    int? heightInches,
    int? heightCm,
    @Default(HeightUnit.feet) HeightUnit heightUnit,
    @Default([]) List<String> languages,
    @Default([]) List<String> photos,
    String? selfiePhotoPath,
    @Default(false) bool selfieVerified,
  }) = _PhotosVerificationData;
}

/// Maximum number of suggestions visible in the search results at once.
/// (User can keep typing to narrow further — cap is purely visual.)
const int kMaxSuggestions = 10;

/// Curated language catalog — India-first, with a small set of common
/// international languages users may speak as a second/third.
///
/// Sourced from the 8th Schedule of the Indian Constitution (22 scheduled
/// languages) plus widely-spoken non-scheduled Indian languages, plus
/// English. Final composition agreed with product + design for the
/// India-only launch (vs a 100+ international catalog that doesn't fit
/// the market).
///
/// TODO(backend): swap to a `/languages` endpoint when the BFF has one.
class SupportedLanguages {
  SupportedLanguages._();

  /// Primary catalog — Indian languages + English. Ranked above
  /// `international` in suggestion results when query relevance ties.
  static const List<String> primary = [
    // 22 scheduled languages (8th Schedule)
    'Assamese',
    'Bengali',
    'Bodo',
    'Dogri',
    'Gujarati',
    'Hindi',
    'Kannada',
    'Kashmiri',
    'Konkani',
    'Maithili',
    'Malayalam',
    'Manipuri',
    'Marathi',
    'Nepali',
    'Odia',
    'Punjabi',
    'Sanskrit',
    'Santali',
    'Sindhi',
    'Tamil',
    'Telugu',
    'Urdu',
    // Widely-spoken non-scheduled Indian languages
    'Awadhi',
    'Bhojpuri',
    'Chhattisgarhi',
    'Garhwali',
    'Haryanvi',
    'Khasi',
    'Kumaoni',
    'Magahi',
    'Mizo',
    'Rajasthani',
    'Tulu',
    // Essential second language
    'English',
  ];

  /// Common international languages — for users flagging fluency in a
  /// second/third foreign language.
  static const List<String> international = [
    'Arabic',
    'French',
    'German',
    'Indonesian',
    'Italian',
    'Japanese',
    'Korean',
    'Mandarin',
    'Persian',
    'Portuguese',
    'Russian',
    'Spanish',
    'Thai',
    'Turkish',
    'Vietnamese',
  ];

  /// Combined catalog — primary first, then international.
  /// Total: ~49 entries.
  static List<String> get all => [...primary, ...international];
}

/// Rank language suggestions for a search [query], excluding [selected]
/// entries the user already picked. Capped at [kMaxSuggestions].
///
/// Ranking (lower number = higher priority):
///  0. Prefix match in `primary` catalog
///  1. Prefix match in `international`
///  2. Substring match in `primary`
///  3. Substring match in `international`
///
/// Within the same rank, alphabetical.
List<String> rankLanguageSuggestions({
  required String query,
  required List<String> selected,
}) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return const [];

  int rankOf(String language) {
    final lower = language.toLowerCase();
    if (!lower.contains(q)) return -1;
    final isPrimary = SupportedLanguages.primary.contains(language);
    final isPrefix = lower.startsWith(q);
    if (isPrefix) return isPrimary ? 0 : 1;
    return isPrimary ? 2 : 3;
  }

  final candidates = SupportedLanguages.all
      .where((l) => !selected.contains(l) && rankOf(l) >= 0)
      .toList();

  candidates.sort((a, b) {
    final byRank = rankOf(a).compareTo(rankOf(b));
    if (byRank != 0) return byRank;
    return a.compareTo(b);
  });

  return candidates.take(kMaxSuggestions).toList();
}
