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

  /// Validate if current step can proceed
  bool canProceed(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.age:
        return state.birthdate != null && _isAgeValid();
      case OnboardingStep.gender:
        return state.gender != null;
      case OnboardingStep.pronoun:
        return state.pronouns.isNotEmpty || state.customPronoun != null;
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

  /// Submit onboarding data
  Future<void> submit() async {
    // TODO: Implement API call to submit onboarding data
    // await ref.read(verificationServiceProvider).submitOnboarding(state);
  }
}
