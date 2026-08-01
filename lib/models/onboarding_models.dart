/// Onboarding Models
/// Data models for onboarding flow
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'gender_identity_models.dart';

part 'onboarding_models.freezed.dart';

/// Onboarding state that holds user selections
@freezed
abstract class OnboardingData with _$OnboardingData {
  const factory OnboardingData({
    DateTime? birthdate,
    Gender? gender,
    String? customGenderIdentity,
    @Default([]) List<String> genderIdentityOptionIds,
    @Default([]) List<String> pronouns,
    String? customPronoun,
    @Default(false) bool showGenderOnProfile,
    @Default(false) bool showPronounsOnProfile,
    SexualOrientation? sexualOrientation,
    @Default(false) bool showSexualOrientationOnProfile,
    @Default([]) List<DatingPreference> datingPreferences,
    @Default([]) List<String> datingGoalIds,
    // Module 4 fields
    String? industry,
    String? role,
    EducationLevel? educationLevel,
    String? locationQuery,
    double? latitude,
    double? longitude,
  }) = _OnboardingData;
}

/// Gender enum
enum Gender {
  man,
  woman,
  nonBinary,
  other;

  /// Value sent to / stored by the BFF `gender` enum. Matches the
  /// Postgres `CREATE TYPE gender AS ENUM (...)` in the onboarding migration.
  String get wireValue {
    switch (this) {
      case Gender.man:
        return 'man';
      case Gender.woman:
        return 'woman';
      case Gender.nonBinary:
        return 'non_binary';
      case Gender.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case Gender.man:
        return 'Man';
      case Gender.woman:
        return 'Woman';
      case Gender.nonBinary:
        return 'Non-Binary';
      case Gender.other:
        return 'Other';
    }
  }

  /// Sub-options for each gender identity
  List<GenderIdentityOption> get identityOptions {
    switch (this) {
      case Gender.man:
        return GenderIdentityOptions.man;
      case Gender.woman:
        return GenderIdentityOptions.woman;
      case Gender.nonBinary:
        return GenderIdentityOptions.nonBinary;
      case Gender.other:
        return const [];
    }
  }
}

/// Predefined pronouns
class Pronouns {
  static const sheHer = 'She/Her';
  static const heHim = 'He/Him';
  static const theyThem = 'They/Them';
  static const coCo = 'Co/Co';
  static const zeZir = 'Ze/Zir';
  static const xeXim = 'Xe/Xim';
  static const eyEm = 'Ey/Em';
  static const veVer = 'Ve/Ver';
  static const perPer = 'Per/Per';
  static const sheThey = 'She/They';
  static const heThey = 'He/They';
  static const anyAll = 'Any/All';
  static const faeFaer = 'Fae/Faer';
  static const itIts = 'It/Its';

  static const List<String> all = [
    sheHer,
    heHim,
    theyThem,
    coCo,
    zeZir,
    xeXim,
    eyEm,
    veVer,
    perPer,
    sheThey,
    heThey,
    anyAll,
    faeFaer,
    itIts,
  ];
}

/// Sexual Orientation enum
enum SexualOrientation {
  straight,
  gay,
  lesbian,
  bisexual,
  pansexual,
  asexual,
  queer;

  /// Value sent to / stored by the BFF `sexual_orientation` enum.
  /// The Dart names already match the Postgres enum values.
  String get wireValue => name;

  String get displayName {
    switch (this) {
      case SexualOrientation.straight:
        return 'Straight';
      case SexualOrientation.gay:
        return 'Gay';
      case SexualOrientation.lesbian:
        return 'Lesbian';
      case SexualOrientation.bisexual:
        return 'Bisexual';
      case SexualOrientation.pansexual:
        return 'Pansexual';
      case SexualOrientation.asexual:
        return 'Asexual';
      case SexualOrientation.queer:
        return 'Queer';
    }
  }
}

/// Dating Preference enum
enum DatingPreference {
  men,
  women,
  nonBinary,
  openToAll;

  /// Value sent to / stored by the BFF `dating_preference` enum. Matches
  /// the Postgres `CREATE TYPE dating_preference AS ENUM (...)`.
  String get wireValue {
    switch (this) {
      case DatingPreference.men:
        return 'men';
      case DatingPreference.women:
        return 'women';
      case DatingPreference.nonBinary:
        return 'non_binary';
      case DatingPreference.openToAll:
        return 'open_to_all';
    }
  }

  String get displayName {
    switch (this) {
      case DatingPreference.men:
        return 'Men';
      case DatingPreference.women:
        return 'Women';
      case DatingPreference.nonBinary:
        return 'Non-Binary';
      case DatingPreference.openToAll:
        return 'Open to All';
    }
  }
}

/// Dating Goal model
@freezed
abstract class DatingGoal with _$DatingGoal {
  const DatingGoal._();
  const factory DatingGoal({
    required String id,
    required String title,
    required String subtitle,
  }) = _DatingGoal;

  static const List<DatingGoal> all = [
    DatingGoal(
      id: 'long_term',
      title: 'Long-term relationship',
      subtitle: 'Looking for something serious and committed',
    ),
    DatingGoal(
      id: 'casual',
      title: 'Casual dating',
      subtitle: 'Open to seeing where things go',
    ),
    DatingGoal(
      id: 'friendship',
      title: 'New friends',
      subtitle: 'Looking to expand my social circle',
    ),
    DatingGoal(
      id: 'fun',
      title: 'Something fun',
      subtitle: 'Just here to have a good time',
    ),
    DatingGoal(
      id: 'unsure',
      title: 'Still figuring it out',
      subtitle: 'Open to possibilities',
    ),
  ];
}

/// Education level enum for Module 4
enum EducationLevel {
  highSchool,
  undergraduate,
  postgraduate,
  doctorate,
  studying,
  preferNotToSay;

  String get displayName {
    switch (this) {
      case EducationLevel.highSchool:
        return 'High School';
      case EducationLevel.undergraduate:
        return 'Undergraduate';
      case EducationLevel.postgraduate:
        return 'Postgraduate';
      case EducationLevel.doctorate:
        return 'Doctorate / PhD';
      case EducationLevel.studying:
        return 'Studying';
      case EducationLevel.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

/// Background Module step enum (Education, Profession, Location)
enum BackgroundStep {
  education,
  profession,
  location,
  complete;

  bool get isLast => this == BackgroundStep.complete;
}

/// Onboarding Module step enum (Module 1: Age, Gender, Pronoun)
enum OnboardingStep {
  age,
  gender,
  pronoun,
  complete;

  bool get isLast => this == OnboardingStep.complete;
}

/// Orientation Module step enum (Module 2: Sexual Orientation, Dating Preference, Dating Goals)
enum OrientationStep {
  sexualOrientation,
  datingPreference,
  datingGoals,
  complete;

  bool get isLast => this == OrientationStep.complete;
}
