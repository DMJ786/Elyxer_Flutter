/// Onboarding Provider
/// Manages onboarding flow state and navigation
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/onboarding_models.dart';

part 'onboarding_provider.g.dart';

/// Current onboarding step provider
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

/// Current Module 4 step provider
@Riverpod(keepAlive: true)
class CurrentModule4Step extends _$CurrentModule4Step {
  @override
  Module4Step build() => Module4Step.education;

  void next() {
    if (!state.isLast) {
      state = Module4Step.values[state.index + 1];
    }
  }

  void previous() {
    if (state.index > 0) {
      state = Module4Step.values[state.index - 1];
    }
  }

  void goTo(Module4Step step) {
    state = step;
  }
}

/// Onboarding data provider
@Riverpod(keepAlive: true)
class OnboardingDataNotifier extends _$OnboardingDataNotifier {
  @override
  OnboardingData build() => const OnboardingData();

  void updateBirthdate(DateTime date) {
    print('DEBUG updateBirthdate BEFORE: state.birthdate=${state.birthdate}');
    state = state.copyWith(birthdate: date);
    print('DEBUG updateBirthdate AFTER: state.birthdate=${state.birthdate}');
    print('DEBUG updateBirthdate: date passed=$date');
  }

  void updateGender(Gender gender) {
    state = state.copyWith(gender: gender);
  }

  void updateCustomGenderIdentity(String? identity) {
    state = state.copyWith(customGenderIdentity: identity);
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

  /// Validate if current step can proceed
  bool canProceed(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.age:
        return state.birthdate != null && _isAgeValid();
      case OnboardingStep.gender:
        return state.gender != null;
      case OnboardingStep.pronoun:
        return state.pronouns.isNotEmpty || state.customPronoun != null;
      case OnboardingStep.sexualOrientation:
        return state.sexualOrientation != null;
      case OnboardingStep.datingPreference:
        return state.datingPreferences.isNotEmpty;
      case OnboardingStep.datingGoals:
        return state.datingGoalIds.isNotEmpty && state.datingGoalIds.length <= 2;
      case OnboardingStep.complete:
        // Complete step can always proceed (it's the final step)
        return true;
    }
  }

  bool _isAgeValid() {
    if (state.birthdate == null) {
      print('DEBUG _isAgeValid: birthdate is null');
      return false;
    }

    final now = DateTime.now();
    final birthdate = state.birthdate!;

    // Calculate actual age considering if birthday has passed this year
    var age = now.year - birthdate.year;

    // If birthday hasn't occurred yet this year, subtract 1
    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }

    print('DEBUG _isAgeValid: birthdate=$birthdate, age=$age, valid=${age >= 18 && age <= 100}');
    return age >= 18 && age <= 100; // Minimum age 18
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

  /// Validate if Module 4 step can proceed
  bool canProceedModule4(Module4Step step) {
    switch (step) {
      case Module4Step.education:
        return (state.industry != null && state.industry!.isNotEmpty) ||
            (state.role != null && state.role!.isNotEmpty);
      case Module4Step.profession:
        return state.educationLevel != null;
      case Module4Step.location:
        return state.locationQuery != null && state.locationQuery!.isNotEmpty;
      case Module4Step.complete:
        return true;
    }
  }

  /// Submit onboarding data
  Future<void> submit() async {
    // TODO: Implement API call to submit onboarding data
    // await ref.read(verificationServiceProvider).submitOnboarding(state);
  }
}
