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

  const OnboardingData({
    this.birthdate,
    this.gender,
    this.customGenderIdentity,
    this.pronouns = const [],
    this.customPronoun,
    this.showGenderOnProfile = false,
    this.showPronounsOnProfile = false,
  });

  OnboardingData copyWith({
    DateTime? birthdate,
    Gender? gender,
    String? customGenderIdentity,
    List<String>? pronouns,
    String? customPronoun,
    bool? showGenderOnProfile,
    bool? showPronounsOnProfile,
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

/// Onboarding step enum
enum OnboardingStep {
  age,
  gender,
  pronoun,
  complete;

  bool get isLast => this == OnboardingStep.complete;
}
