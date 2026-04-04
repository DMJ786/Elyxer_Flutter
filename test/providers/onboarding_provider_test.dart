/// Onboarding Provider Tests
/// Tests for onboarding and orientation providers including validation logic
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/providers/onboarding_provider.dart';

void main() {
  group('CurrentOnboardingStep provider', () {
    test('should initialize with age step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final step = container.read(currentOnboardingStepProvider);
      expect(step, equals(OnboardingStep.age));
    });

    test('next() should advance step correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOnboardingStepProvider.notifier);

      // Start at age
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.age);

      // Advance to gender
      notifier.next();
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.gender);

      // Advance to pronoun
      notifier.next();
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.pronoun);

      // Advance to complete
      notifier.next();
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.complete);
    });

    test('next() should not advance past complete step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOnboardingStepProvider.notifier);

      // Move to complete step
      notifier.goTo(OnboardingStep.complete);
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.complete);

      // Try to advance past complete
      notifier.next();
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.complete);
    });

    test('previous() should go back correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOnboardingStepProvider.notifier);

      // Move to complete
      notifier.goTo(OnboardingStep.complete);
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.complete);

      // Go back to pronoun
      notifier.previous();
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.pronoun);

      // Go back to gender
      notifier.previous();
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.gender);

      // Go back to age
      notifier.previous();
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.age);
    });

    test('previous() should not go below index 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOnboardingStepProvider.notifier);

      // Start at age (index 0)
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.age);

      // Try to go back from age
      notifier.previous();
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.age);
    });

    test('goTo() should set the correct step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOnboardingStepProvider.notifier);

      // Jump to pronoun
      notifier.goTo(OnboardingStep.pronoun);
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.pronoun);

      // Jump to complete
      notifier.goTo(OnboardingStep.complete);
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.complete);

      // Jump back to gender
      notifier.goTo(OnboardingStep.gender);
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.gender);
    });
  });

  group('CurrentOrientationStep provider', () {
    test('should initialize with sexualOrientation step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final step = container.read(currentOrientationStepProvider);
      expect(step, equals(OrientationStep.sexualOrientation));
    });

    test('next() should advance step correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOrientationStepProvider.notifier);

      // Start at sexualOrientation
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.sexualOrientation,
      );

      // Advance to datingPreference
      notifier.next();
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.datingPreference,
      );

      // Advance to datingGoals
      notifier.next();
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.datingGoals,
      );

      // Advance to complete
      notifier.next();
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.complete,
      );
    });

    test('next() should not advance past complete step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOrientationStepProvider.notifier);

      // Move to complete step
      notifier.goTo(OrientationStep.complete);
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.complete,
      );

      // Try to advance past complete
      notifier.next();
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.complete,
      );
    });

    test('previous() should go back correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOrientationStepProvider.notifier);

      // Move to complete
      notifier.goTo(OrientationStep.complete);

      // Go back to datingGoals
      notifier.previous();
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.datingGoals,
      );

      // Go back to datingPreference
      notifier.previous();
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.datingPreference,
      );

      // Go back to sexualOrientation
      notifier.previous();
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.sexualOrientation,
      );
    });

    test('previous() should not go below index 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOrientationStepProvider.notifier);

      // Start at sexualOrientation (index 0)
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.sexualOrientation,
      );

      // Try to go back from sexualOrientation
      notifier.previous();
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.sexualOrientation,
      );
    });

    test('goTo() should set the correct step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(currentOrientationStepProvider.notifier);

      // Jump to datingGoals
      notifier.goTo(OrientationStep.datingGoals);
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.datingGoals,
      );

      // Jump to complete
      notifier.goTo(OrientationStep.complete);
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.complete,
      );

      // Jump back to datingPreference
      notifier.goTo(OrientationStep.datingPreference);
      expect(
        container.read(currentOrientationStepProvider),
        OrientationStep.datingPreference,
      );
    });
  });

  group('canProceedOnboarding provider - age step', () {
    test('should return false when no age is set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to age
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.age);

      // No birthdate set
      expect(container.read(canProceedOnboardingProvider), isFalse);
    });

    test('should return true when valid age is set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to age
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.age);

      // Set valid birthdate (25 years old)
      final birthdate = DateTime.now().subtract(const Duration(days: 365 * 25));
      container.read(onboardingDataProvider.notifier).updateBirthdate(birthdate);

      expect(container.read(canProceedOnboardingProvider), isTrue);
    });

    test('should return false when age is under 18', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to age
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.age);

      // Set birthdate for 17 years old
      final birthdate = DateTime.now().subtract(const Duration(days: 365 * 17));
      container.read(onboardingDataProvider.notifier).updateBirthdate(birthdate);

      expect(container.read(canProceedOnboardingProvider), isFalse);
    });

    test('should return false when age is over 100', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to age
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.age);

      // Set birthdate for 101 years old (365.25 days per year for accuracy)
      final daysFor101Years = (365.25 * 101).round();
      final birthdate = DateTime.now().subtract(Duration(days: daysFor101Years));
      container.read(onboardingDataProvider.notifier).updateBirthdate(birthdate);

      expect(container.read(canProceedOnboardingProvider), isFalse);
    });

    test('should return true for exactly 18 years old', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to age
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.age);

      // Set birthdate for exactly 18 years old
      final birthdate = DateTime(
        DateTime.now().year - 18,
        DateTime.now().month,
        DateTime.now().day,
      );
      container.read(onboardingDataProvider.notifier).updateBirthdate(birthdate);

      expect(container.read(canProceedOnboardingProvider), isTrue);
    });
  });

  group('canProceedOnboarding provider - gender step', () {
    test('should return false when no gender is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to gender
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.gender);

      expect(container.read(canProceedOnboardingProvider), isFalse);
    });

    test('should return true when gender is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to gender
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.gender);

      // Select a gender
      container.read(onboardingDataProvider.notifier).updateGender(Gender.woman);

      expect(container.read(canProceedOnboardingProvider), isTrue);
    });

    test('should return true for all gender options', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.gender);

      for (final gender in Gender.values) {
        container.read(onboardingDataProvider.notifier).updateGender(gender);
        expect(container.read(canProceedOnboardingProvider), isTrue);
      }
    });
  });

  group('canProceedOnboarding provider - pronoun step', () {
    test('should return false when no pronoun is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to pronoun
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.pronoun);

      expect(container.read(canProceedOnboardingProvider), isFalse);
    });

    test('should return true when at least one pronoun is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to pronoun
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.pronoun);

      // Toggle a pronoun
      container.read(onboardingDataProvider.notifier).togglePronoun('She/Her');

      expect(container.read(canProceedOnboardingProvider), isTrue);
    });

    test('should return true when custom pronoun is provided', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to pronoun
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.pronoun);

      // Set custom pronoun
      container.read(onboardingDataProvider.notifier).updateCustomPronoun('Ze/Hir');

      expect(container.read(canProceedOnboardingProvider), isTrue);
    });

    test('should return true when multiple pronouns are selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to pronoun
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.pronoun);

      // Toggle multiple pronouns
      container.read(onboardingDataProvider.notifier).togglePronoun('She/Her');
      container.read(onboardingDataProvider.notifier).togglePronoun('They/Them');

      expect(container.read(canProceedOnboardingProvider), isTrue);
    });
  });

  group('canProceedOnboarding provider - complete step', () {
    test('should return true for complete step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to complete
      container.read(currentOnboardingStepProvider.notifier).goTo(OnboardingStep.complete);

      expect(container.read(canProceedOnboardingProvider), isTrue);
    });
  });

  group('canProceedOrientation provider - sexualOrientation step', () {
    test('should return false when no sexual orientation is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to sexualOrientation
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.sexualOrientation,
      );

      expect(container.read(canProceedOrientationProvider), isFalse);
    });

    test('should return true when sexual orientation is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to sexualOrientation
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.sexualOrientation,
      );

      // Select orientation
      container.read(onboardingDataProvider.notifier).updateSexualOrientation(
        SexualOrientation.bisexual,
      );

      expect(container.read(canProceedOrientationProvider), isTrue);
    });

    test('should return true for all sexual orientation options', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.sexualOrientation,
      );

      for (final orientation in SexualOrientation.values) {
        container.read(onboardingDataProvider.notifier).updateSexualOrientation(orientation);
        expect(container.read(canProceedOrientationProvider), isTrue);
      }
    });
  });

  group('canProceedOrientation provider - datingPreference step', () {
    test('should return false when no dating preference is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to datingPreference
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingPreference,
      );

      expect(container.read(canProceedOrientationProvider), isFalse);
    });

    test('should return true when at least one dating preference is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to datingPreference
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingPreference,
      );

      // Toggle a preference
      container.read(onboardingDataProvider.notifier).toggleDatingPreference(
        DatingPreference.women,
      );

      expect(container.read(canProceedOrientationProvider), isTrue);
    });

    test('should return true when multiple dating preferences are selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to datingPreference
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingPreference,
      );

      // Toggle multiple preferences
      container.read(onboardingDataProvider.notifier).toggleDatingPreference(
        DatingPreference.women,
      );
      container.read(onboardingDataProvider.notifier).toggleDatingPreference(
        DatingPreference.nonBinary,
      );

      expect(container.read(canProceedOrientationProvider), isTrue);
    });
  });

  group('canProceedOrientation provider - datingGoals step', () {
    test('should return false when no dating goals are selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to datingGoals
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingGoals,
      );

      expect(container.read(canProceedOrientationProvider), isFalse);
    });

    test('should return true when 1 dating goal is selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to datingGoals
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingGoals,
      );

      // Toggle one goal
      container.read(onboardingDataProvider.notifier).toggleDatingGoal('long_term');

      expect(container.read(canProceedOrientationProvider), isTrue);
    });

    test('should return true when 2 dating goals are selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to datingGoals
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingGoals,
      );

      // Toggle two goals
      container.read(onboardingDataProvider.notifier).toggleDatingGoal('long_term');
      container.read(onboardingDataProvider.notifier).toggleDatingGoal('casual');

      expect(container.read(canProceedOrientationProvider), isTrue);
    });

    test('should enforce max 2 selections', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to datingGoals
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingGoals,
      );

      // Try to add 3 goals
      container.read(onboardingDataProvider.notifier).toggleDatingGoal('long_term');
      container.read(onboardingDataProvider.notifier).toggleDatingGoal('casual');
      container.read(onboardingDataProvider.notifier).toggleDatingGoal('friendship');

      // Should only have 2 goals
      final goals = container.read(onboardingDataProvider).datingGoalIds;
      expect(goals.length, equals(2));
      expect(container.read(canProceedOrientationProvider), isTrue);
    });
  });

  group('canProceedOrientation provider - complete step', () {
    test('should return true for complete step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set step to complete
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.complete,
      );

      expect(container.read(canProceedOrientationProvider), isTrue);
    });
  });

  group('OnboardingDataNotifier', () {
    test('should toggle pronouns correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      // Add a pronoun
      notifier.togglePronoun('She/Her');
      expect(
        container.read(onboardingDataProvider).pronouns,
        contains('She/Her'),
      );

      // Remove the pronoun
      notifier.togglePronoun('She/Her');
      expect(
        container.read(onboardingDataProvider).pronouns,
        isNot(contains('She/Her')),
      );
    });

    test('should toggle dating preferences correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      // Add a preference
      notifier.toggleDatingPreference(DatingPreference.women);
      expect(
        container.read(onboardingDataProvider).datingPreferences,
        contains(DatingPreference.women),
      );

      // Remove the preference
      notifier.toggleDatingPreference(DatingPreference.women);
      expect(
        container.read(onboardingDataProvider).datingPreferences,
        isNot(contains(DatingPreference.women)),
      );
    });

    test('should toggle gender visibility', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      // Initially false
      expect(container.read(onboardingDataProvider).showGenderOnProfile, isFalse);

      // Toggle to true
      notifier.toggleShowGenderOnProfile();
      expect(container.read(onboardingDataProvider).showGenderOnProfile, isTrue);

      // Toggle back to false
      notifier.toggleShowGenderOnProfile();
      expect(container.read(onboardingDataProvider).showGenderOnProfile, isFalse);
    });
  });

  group('OnboardingDataNotifier - Gender Identity Options', () {
    test('updateGender should clear genderIdentityOptionIds', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      // Set gender and add identity options
      notifier.updateGender(Gender.man);
      notifier.updateGenderIdentityOptions(['man', 'cisgender_man']);
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds.length,
        equals(2),
      );

      // Change gender — identity options should be cleared
      notifier.updateGender(Gender.woman);
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        isEmpty,
      );
      expect(
        container.read(onboardingDataProvider).gender,
        equals(Gender.woman),
      );
    });

    test('updateGenderIdentityOptions should replace entire list', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      notifier.updateGenderIdentityOptions(['man', 'transgender_man']);
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        equals(['man', 'transgender_man']),
      );

      // Replace with different list
      notifier.updateGenderIdentityOptions(['cisgender_man']);
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        equals(['cisgender_man']),
      );
    });

    test('updateGenderIdentityOptions with empty list should clear selections', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      notifier.updateGenderIdentityOptions(['man', 'cisgender_man']);
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds.length,
        equals(2),
      );

      notifier.updateGenderIdentityOptions([]);
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        isEmpty,
      );
    });

    test('toggleGenderIdentityOption should add when not present', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      notifier.toggleGenderIdentityOption('transgender_man');
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        contains('transgender_man'),
      );
    });

    test('toggleGenderIdentityOption should remove when already present', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      // Add then remove
      notifier.toggleGenderIdentityOption('transgender_man');
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        contains('transgender_man'),
      );

      notifier.toggleGenderIdentityOption('transgender_man');
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        isNot(contains('transgender_man')),
      );
    });

    test('toggleGenderIdentityOption should support multiple selections', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      notifier.toggleGenderIdentityOption('man');
      notifier.toggleGenderIdentityOption('cisgender_man');
      notifier.toggleGenderIdentityOption('transmasculine');

      final ids = container.read(onboardingDataProvider).genderIdentityOptionIds;
      expect(ids.length, equals(3));
      expect(ids, contains('man'));
      expect(ids, contains('cisgender_man'));
      expect(ids, contains('transmasculine'));
    });

    test('toggleGenderIdentityOption should only remove the toggled item', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      notifier.toggleGenderIdentityOption('man');
      notifier.toggleGenderIdentityOption('cisgender_man');

      // Remove one
      notifier.toggleGenderIdentityOption('man');

      final ids = container.read(onboardingDataProvider).genderIdentityOptionIds;
      expect(ids.length, equals(1));
      expect(ids, contains('cisgender_man'));
      expect(ids, isNot(contains('man')));
    });

    test('updateGenderIdentityOption should wrap single id in list', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      notifier.updateGenderIdentityOption('transgender_man');
      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        equals(['transgender_man']),
      );
    });

    test('updateGenderIdentityOption with null should clear list', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingDataProvider.notifier);

      notifier.updateGenderIdentityOptions(['man', 'cisgender_man']);
      notifier.updateGenderIdentityOption(null);

      expect(
        container.read(onboardingDataProvider).genderIdentityOptionIds,
        isEmpty,
      );
    });
  });
}
