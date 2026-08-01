/// Onboarding Provider
/// Manages onboarding flow state and navigation
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/onboarding_models.dart';
import '../services/onboarding_service.dart';

part 'onboarding_provider.g.dart';

/// Current onboarding step provider (Module 1: Age, Gender, Pronoun)
@Riverpod(keepAlive: true)
class CurrentOnboardingStep extends _$CurrentOnboardingStep {
  @override
  OnboardingStep build() => OnboardingStep.age;

  void next() {
    if (!state.isLast) {
      state = OnboardingStep.values[state.index + 1];
    }
  }

  void previous() {
    if (state.index > 0) {
      state = OnboardingStep.values[state.index - 1];
    }
  }

  void goTo(OnboardingStep step) {
    state = step;
  }
}

/// Current orientation step provider (Module 2: Sexual Orientation, Dating Preference, Dating Goals)
@Riverpod(keepAlive: true)
class CurrentOrientationStep extends _$CurrentOrientationStep {
  @override
  OrientationStep build() => OrientationStep.sexualOrientation;

  void next() {
    if (!state.isLast) {
      state = OrientationStep.values[state.index + 1];
    }
  }

  void previous() {
    if (state.index > 0) {
      state = OrientationStep.values[state.index - 1];
    }
  }

  void goTo(OrientationStep step) {
    state = step;
  }
}

/// Current Background step provider
@Riverpod(keepAlive: true)
class CurrentBackgroundStep extends _$CurrentBackgroundStep {
  @override
  BackgroundStep build() => BackgroundStep.education;

  void next() {
    if (!state.isLast) {
      state = BackgroundStep.values[state.index + 1];
    }
  }

  void previous() {
    if (state.index > 0) {
      state = BackgroundStep.values[state.index - 1];
    }
  }

  void goTo(BackgroundStep step) {
    state = step;
  }
}

/// Onboarding data provider
@Riverpod(keepAlive: true)
class OnboardingDataNotifier extends _$OnboardingDataNotifier {
  @override
  OnboardingData build() => const OnboardingData();

  void updateBirthdate(DateTime date) {
    state = state.copyWith(birthdate: date);
  }

  void updateGender(Gender gender) {
    // Clear identity selections when gender changes
    state = state.copyWith(gender: gender, genderIdentityOptionIds: []);
  }

  void updateCustomGenderIdentity(String? identity) {
    state = state.copyWith(customGenderIdentity: identity);
  }

  void updateGenderIdentityOption(String? optionId) {
    state = state.copyWith(genderIdentityOptionIds: [if (optionId != null) optionId]);
  }

  void updateGenderIdentityOptions(List<String> optionIds) {
    state = state.copyWith(genderIdentityOptionIds: optionIds);
  }

  void toggleGenderIdentityOption(String optionId) {
    final ids = List<String>.from(state.genderIdentityOptionIds);
    if (ids.contains(optionId)) {
      ids.remove(optionId);
    } else {
      ids.add(optionId);
    }
    state = state.copyWith(genderIdentityOptionIds: ids);
  }

  void togglePronoun(String pronoun) {
    final pronouns = List<String>.from(state.pronouns);
    if (pronouns.contains(pronoun)) {
      pronouns.remove(pronoun);
    } else {
      pronouns.add(pronoun);
    }
    state = state.copyWith(pronouns: pronouns);
  }

  void updateCustomPronoun(String? pronoun) {
    state = state.copyWith(customPronoun: pronoun);
  }

  void toggleShowGenderOnProfile() {
    state = state.copyWith(showGenderOnProfile: !state.showGenderOnProfile);
  }

  void toggleShowPronounsOnProfile() {
    state = state.copyWith(
      showPronounsOnProfile: !state.showPronounsOnProfile,
    );
  }

  void updateSexualOrientation(SexualOrientation orientation) {
    state = state.copyWith(sexualOrientation: orientation);
  }

  void toggleShowSexualOrientationOnProfile() {
    state = state.copyWith(
      showSexualOrientationOnProfile: !state.showSexualOrientationOnProfile,
    );
  }

  void toggleDatingPreference(DatingPreference preference) {
    final preferences = List<DatingPreference>.from(state.datingPreferences);
    if (preferences.contains(preference)) {
      preferences.remove(preference);
    } else {
      preferences.add(preference);
    }
    state = state.copyWith(datingPreferences: preferences);
  }

  void toggleDatingGoal(String goalId) {
    final goals = List<String>.from(state.datingGoalIds);
    if (goals.contains(goalId)) {
      goals.remove(goalId);
    } else if (goals.length < 2) {
      // Enforce max 2 selections
      goals.add(goalId);
    }
    state = state.copyWith(datingGoalIds: goals);
  }

  // Module 4 methods
  void updateIndustry(String industry) {
    state = state.copyWith(industry: industry);
  }

  void updateRole(String role) {
    state = state.copyWith(role: role);
  }

  void updateEducationLevel(EducationLevel level) {
    state = state.copyWith(educationLevel: level);
  }

  void updateLocationQuery(String query) {
    state = state.copyWith(locationQuery: query);
  }

  void updateLocation({
    required double latitude,
    required double longitude,
    required String query,
  }) {
    state = state.copyWith(
      latitude: latitude,
      longitude: longitude,
      locationQuery: query,
    );
  }

  /// Validate if Background step can proceed
  bool canProceedBackground(BackgroundStep step) {
    switch (step) {
      case BackgroundStep.education:
        return state.educationLevel != null;
      case BackgroundStep.profession:
        return (state.industry != null && state.industry!.isNotEmpty) ||
            (state.role != null && state.role!.isNotEmpty);
      case BackgroundStep.location:
        return state.locationQuery != null && state.locationQuery!.isNotEmpty;
      case BackgroundStep.complete:
        return true;
    }
  }

  /// Submit onboarding data (Module 1 + 2) to the BFF. Persisted server-side
  /// keyed on the authenticated user; idempotent across re-submits.
  Future<void> submit() async {
    await OnboardingService().submit(state);
  }
}


/// Computed provider: Can proceed with current onboarding step
@riverpod
bool canProceedOnboarding(Ref ref) {
  final currentStep = ref.watch(currentOnboardingStepProvider);
  final data = ref.watch(onboardingDataProvider);

  return switch (currentStep) {
    OnboardingStep.age =>
      data.birthdate != null && isValidDatingAge(data.birthdate!),
    OnboardingStep.gender => data.gender != null,
    OnboardingStep.pronoun => data.pronouns.isNotEmpty || data.customPronoun != null,
    OnboardingStep.complete => true,
  };
}

/// Single source of truth for the dating age rule: [birthdate] must place the
/// user between 18 and 100 years old (inclusive), accounting for whether this
/// year's birthday has already passed.
bool isValidDatingAge(DateTime birthdate) {
  final now = DateTime.now();
  var age = now.year - birthdate.year;
  if (now.month < birthdate.month ||
      (now.month == birthdate.month && now.day < birthdate.day)) {
    age--;
  }
  return age >= 18 && age <= 100;
}

/// Computed provider: Can proceed with current orientation step
@riverpod
bool canProceedOrientation(Ref ref) {
  final currentStep = ref.watch(currentOrientationStepProvider);
  final data = ref.watch(onboardingDataProvider);

  return switch (currentStep) {
    OrientationStep.sexualOrientation => data.sexualOrientation != null,
    OrientationStep.datingPreference => data.datingPreferences.isNotEmpty,
    OrientationStep.datingGoals => data.datingGoalIds.isNotEmpty && data.datingGoalIds.length <= 2,
    OrientationStep.complete => true,
  };
}
