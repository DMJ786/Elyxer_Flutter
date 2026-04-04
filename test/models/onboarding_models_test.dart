/// Onboarding Models Tests
/// Tests for OnboardingStep and OrientationStep enums
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/models/gender_identity_models.dart';

void main() {
  group('OnboardingStep enum', () {
    test('should have correct enum values in order', () {
      expect(OnboardingStep.values.length, equals(4));
      expect(OnboardingStep.values[0], equals(OnboardingStep.age));
      expect(OnboardingStep.values[1], equals(OnboardingStep.gender));
      expect(OnboardingStep.values[2], equals(OnboardingStep.pronoun));
      expect(OnboardingStep.values[3], equals(OnboardingStep.complete));
    });

    test('should have correct index values', () {
      expect(OnboardingStep.age.index, equals(0));
      expect(OnboardingStep.gender.index, equals(1));
      expect(OnboardingStep.pronoun.index, equals(2));
      expect(OnboardingStep.complete.index, equals(3));
    });

    test('isLast should return true only for complete step', () {
      expect(OnboardingStep.age.isLast, isFalse);
      expect(OnboardingStep.gender.isLast, isFalse);
      expect(OnboardingStep.pronoun.isLast, isFalse);
      expect(OnboardingStep.complete.isLast, isTrue);
    });

    test('should have a complete step', () {
      expect(OnboardingStep.values, contains(OnboardingStep.complete));
    });

    test('complete should be the last value in enum', () {
      expect(
        OnboardingStep.values.last,
        equals(OnboardingStep.complete),
      );
    });
  });

  group('OrientationStep enum', () {
    test('should have correct enum values in order', () {
      expect(OrientationStep.values.length, equals(4));
      expect(
        OrientationStep.values[0],
        equals(OrientationStep.sexualOrientation),
      );
      expect(
        OrientationStep.values[1],
        equals(OrientationStep.datingPreference),
      );
      expect(OrientationStep.values[2], equals(OrientationStep.datingGoals));
      expect(OrientationStep.values[3], equals(OrientationStep.complete));
    });

    test('should have correct index values', () {
      expect(OrientationStep.sexualOrientation.index, equals(0));
      expect(OrientationStep.datingPreference.index, equals(1));
      expect(OrientationStep.datingGoals.index, equals(2));
      expect(OrientationStep.complete.index, equals(3));
    });

    test('isLast should return true only for complete step', () {
      expect(OrientationStep.sexualOrientation.isLast, isFalse);
      expect(OrientationStep.datingPreference.isLast, isFalse);
      expect(OrientationStep.datingGoals.isLast, isFalse);
      expect(OrientationStep.complete.isLast, isTrue);
    });

    test('should have a complete step', () {
      expect(OrientationStep.values, contains(OrientationStep.complete));
    });

    test('complete should be the last value in enum', () {
      expect(
        OrientationStep.values.last,
        equals(OrientationStep.complete),
      );
    });
  });

  group('Gender enum', () {
    test('should have correct display names', () {
      expect(Gender.man.displayName, equals('Man'));
      expect(Gender.woman.displayName, equals('Woman'));
      expect(Gender.nonBinary.displayName, equals('Non-Binary'));
      expect(Gender.other.displayName, equals('Other'));
    });

    test('identityOptions should return man options for Gender.man', () {
      final options = Gender.man.identityOptions;
      expect(options, equals(GenderIdentityOptions.man));
      expect(options.length, equals(6));
    });

    test('identityOptions should return woman options for Gender.woman', () {
      final options = Gender.woman.identityOptions;
      expect(options, equals(GenderIdentityOptions.woman));
      expect(options.length, equals(6));
    });

    test('identityOptions should return nonBinary options for Gender.nonBinary', () {
      final options = Gender.nonBinary.identityOptions;
      expect(options, equals(GenderIdentityOptions.nonBinary));
      expect(options.length, equals(14));
    });

    test('identityOptions should return empty list for Gender.other', () {
      final options = Gender.other.identityOptions;
      expect(options, isEmpty);
    });
  });

  group('SexualOrientation enum', () {
    test('should have correct display names', () {
      expect(SexualOrientation.straight.displayName, equals('Straight'));
      expect(SexualOrientation.gay.displayName, equals('Gay'));
      expect(SexualOrientation.lesbian.displayName, equals('Lesbian'));
      expect(SexualOrientation.bisexual.displayName, equals('Bisexual'));
      expect(SexualOrientation.pansexual.displayName, equals('Pansexual'));
      expect(SexualOrientation.asexual.displayName, equals('Asexual'));
      expect(SexualOrientation.queer.displayName, equals('Queer'));
    });
  });

  group('DatingPreference enum', () {
    test('should have correct display names', () {
      expect(DatingPreference.men.displayName, equals('Men'));
      expect(DatingPreference.women.displayName, equals('Women'));
      expect(DatingPreference.nonBinary.displayName, equals('Non-Binary'));
      expect(DatingPreference.openToAll.displayName, equals('Open to All'));
    });
  });

  group('DatingGoal', () {
    test('should have all predefined goals', () {
      expect(DatingGoal.all.length, equals(5));
      
      final goalIds = DatingGoal.all.map((g) => g.id).toList();
      expect(goalIds, contains('long_term'));
      expect(goalIds, contains('casual'));
      expect(goalIds, contains('friendship'));
      expect(goalIds, contains('fun'));
      expect(goalIds, contains('unsure'));
    });

    test('should have title and subtitle for each goal', () {
      for (final goal in DatingGoal.all) {
        expect(goal.id.isNotEmpty, isTrue);
        expect(goal.title.isNotEmpty, isTrue);
        expect(goal.subtitle.isNotEmpty, isTrue);
      }
    });
  });

  group('Pronouns', () {
    test('should have all predefined pronouns', () {
      expect(Pronouns.all.length, equals(14));
      expect(Pronouns.all, contains('She/Her'));
      expect(Pronouns.all, contains('He/Him'));
      expect(Pronouns.all, contains('They/Them'));
      expect(Pronouns.all, contains('Co/Co'));
      expect(Pronouns.all, contains('Ze/Zir'));
      expect(Pronouns.all, contains('Xe/Xim'));
      expect(Pronouns.all, contains('Ey/Em'));
      expect(Pronouns.all, contains('Ve/Ver'));
      expect(Pronouns.all, contains('Per/Per'));
      expect(Pronouns.all, contains('She/They'));
      expect(Pronouns.all, contains('He/They'));
      expect(Pronouns.all, contains('Any/All'));
      expect(Pronouns.all, contains('Fae/Faer'));
      expect(Pronouns.all, contains('It/Its'));
    });
  });

  group('OnboardingData', () {
    test('should initialize with default values', () {
      const data = OnboardingData();
      
      expect(data.birthdate, isNull);
      expect(data.gender, isNull);
      expect(data.customGenderIdentity, isNull);
      expect(data.genderIdentityOptionIds, isEmpty);
      expect(data.pronouns, isEmpty);
      expect(data.customPronoun, isNull);
      expect(data.showGenderOnProfile, isFalse);
      expect(data.showPronounsOnProfile, isFalse);
      expect(data.sexualOrientation, isNull);
      expect(data.showSexualOrientationOnProfile, isFalse);
      expect(data.datingPreferences, isEmpty);
      expect(data.datingGoalIds, isEmpty);
    });

    test('should support copyWith for birthdate', () {
      const data = OnboardingData();
      final now = DateTime.now();
      final updated = data.copyWith(birthdate: now);
      
      expect(updated.birthdate, equals(now));
      expect(updated.gender, isNull); // Other fields unchanged
    });

    test('should support copyWith for gender', () {
      const data = OnboardingData();
      final updated = data.copyWith(gender: Gender.woman);
      
      expect(updated.gender, equals(Gender.woman));
      expect(updated.birthdate, isNull); // Other fields unchanged
    });

    test('should support copyWith for pronouns', () {
      const data = OnboardingData();
      final updated = data.copyWith(pronouns: ['She/Her', 'They/Them']);
      
      expect(updated.pronouns, equals(['She/Her', 'They/Them']));
      expect(updated.customPronoun, isNull); // Other fields unchanged
    });

    test('should support copyWith for sexual orientation', () {
      const data = OnboardingData();
      final updated = data.copyWith(
        sexualOrientation: SexualOrientation.bisexual,
      );
      
      expect(updated.sexualOrientation, equals(SexualOrientation.bisexual));
    });

    test('should support copyWith for dating preferences', () {
      const data = OnboardingData();
      final updated = data.copyWith(
        datingPreferences: [DatingPreference.women, DatingPreference.nonBinary],
      );
      
      expect(updated.datingPreferences.length, equals(2));
      expect(updated.datingPreferences, contains(DatingPreference.women));
      expect(updated.datingPreferences, contains(DatingPreference.nonBinary));
    });

    test('should support copyWith for dating goals', () {
      const data = OnboardingData();
      final updated = data.copyWith(datingGoalIds: ['long_term', 'casual']);
      
      expect(updated.datingGoalIds, equals(['long_term', 'casual']));
    });

    test('should initialize genderIdentityOptionIds as empty list', () {
      const data = OnboardingData();
      expect(data.genderIdentityOptionIds, isA<List<String>>());
      expect(data.genderIdentityOptionIds, isEmpty);
    });

    test('should support copyWith for genderIdentityOptionIds', () {
      const data = OnboardingData();
      final updated = data.copyWith(
        genderIdentityOptionIds: ['man', 'transgender_man'],
      );

      expect(updated.genderIdentityOptionIds.length, equals(2));
      expect(updated.genderIdentityOptionIds, contains('man'));
      expect(updated.genderIdentityOptionIds, contains('transgender_man'));
    });

    test('copyWith genderIdentityOptionIds should not affect other fields', () {
      const data = OnboardingData();
      final updated = data.copyWith(
        gender: Gender.man,
        genderIdentityOptionIds: ['cisgender_man'],
      );

      expect(updated.gender, equals(Gender.man));
      expect(updated.genderIdentityOptionIds, equals(['cisgender_man']));
      expect(updated.birthdate, isNull);
      expect(updated.pronouns, isEmpty);
    });

    test('copyWith should allow clearing genderIdentityOptionIds', () {
      final data = const OnboardingData().copyWith(
        genderIdentityOptionIds: ['man', 'cisgender_man'],
      );
      expect(data.genderIdentityOptionIds.length, equals(2));

      final cleared = data.copyWith(genderIdentityOptionIds: []);
      expect(cleared.genderIdentityOptionIds, isEmpty);
    });
  });
}
