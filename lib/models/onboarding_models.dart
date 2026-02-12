/// Onboarding Models
/// Data models for onboarding flow
library;

/// Onboarding state that holds user selections
class OnboardingData {
  final DateTime? birthdate;
  final Gender? gender;
  final String? customGenderIdentity;
  final List<String> pronouns;
  final String? customPronoun;
  final bool showGenderOnProfile;
  final bool showPronounsOnProfile;
  final SexualOrientation? sexualOrientation;
  final bool showSexualOrientationOnProfile;
  final List<DatingPreference> datingPreferences;
  final List<String> datingGoalIds;

  // Module 4 fields
  final String? industry;
  final String? role;
  final EducationLevel? educationLevel;
  final String? locationQuery;
  final double? latitude;
  final double? longitude;

  const OnboardingData({
    this.birthdate,
    this.gender,
    this.customGenderIdentity,
    this.pronouns = const [],
    this.customPronoun,
    this.showGenderOnProfile = false,
    this.showPronounsOnProfile = false,
    this.sexualOrientation,
    this.showSexualOrientationOnProfile = false,
    this.datingPreferences = const [],
    this.datingGoalIds = const [],
    this.industry,
    this.role,
    this.educationLevel,
    this.locationQuery,
    this.latitude,
    this.longitude,
  });

  OnboardingData copyWith({
    DateTime? birthdate,
    Gender? gender,
    String? customGenderIdentity,
    List<String>? pronouns,
    String? customPronoun,
    bool? showGenderOnProfile,
    bool? showPronounsOnProfile,
    SexualOrientation? sexualOrientation,
    bool? showSexualOrientationOnProfile,
    List<DatingPreference>? datingPreferences,
    List<String>? datingGoalIds,
    String? industry,
    String? role,
    EducationLevel? educationLevel,
    String? locationQuery,
    double? latitude,
    double? longitude,
  }) {
    return OnboardingData(
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      customGenderIdentity: customGenderIdentity ?? this.customGenderIdentity,
      pronouns: pronouns ?? this.pronouns,
      customPronoun: customPronoun ?? this.customPronoun,
      showGenderOnProfile: showGenderOnProfile ?? this.showGenderOnProfile,
      showPronounsOnProfile:
          showPronounsOnProfile ?? this.showPronounsOnProfile,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      showSexualOrientationOnProfile:
          showSexualOrientationOnProfile ?? this.showSexualOrientationOnProfile,
      datingPreferences: datingPreferences ?? this.datingPreferences,
      datingGoalIds: datingGoalIds ?? this.datingGoalIds,
      industry: industry ?? this.industry,
      role: role ?? this.role,
      educationLevel: educationLevel ?? this.educationLevel,
      locationQuery: locationQuery ?? this.locationQuery,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

/// Gender enum
enum Gender {
  man,
  woman,
  nonBinary,
  other;

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
class DatingGoal {
  final String id;
  final String title;
  final String subtitle;

  const DatingGoal({
    required this.id,
    required this.title,
    required this.subtitle,
  });

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
        return 'Doctorate/PhD';
      case EducationLevel.studying:
        return 'Studying';
      case EducationLevel.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

/// Module 4 step enum
enum Module4Step {
  education,
  profession,
  location,
  complete;

  bool get isLast => this == Module4Step.complete;
}

/// Onboarding step enum
enum OnboardingStep {
  age,
  gender,
  pronoun,
  sexualOrientation,
  datingPreference,
  datingGoals,
  complete;

  bool get isLast => this == OnboardingStep.complete;
}
