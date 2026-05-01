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

/// Curated list of languages users can pick from.
/// Designer can replace this with a backend-driven list later.
class SupportedLanguages {
  SupportedLanguages._();

  static const List<String> all = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Cantonese',
    'Arabic',
    'Portuguese',
    'Russian',
    'Japanese',
    'Korean',
    'Italian',
    'Dutch',
    'Turkish',
    'Vietnamese',
    'Thai',
    'Tamil',
    'Telugu',
    'Bengali',
    'Punjabi',
    'Marathi',
    'Gujarati',
    'Urdu',
    'Malayalam',
    'Kannada',
    'Swahili',
    'Polish',
    'Greek',
    'Hebrew',
  ];
}
