/// Tests for PhotosVerificationData (Module 5 model)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/models/photos_verification_models.dart';

void main() {
  group('PhotosVerificationData defaults', () {
    test('has empty selections and feet as default unit', () {
      const data = PhotosVerificationData();
      expect(data.heightFeet, isNull);
      expect(data.heightInches, isNull);
      expect(data.heightCm, isNull);
      expect(data.heightUnit, HeightUnit.feet);
      expect(data.languages, isEmpty);
      expect(data.photos, isEmpty);
      expect(data.selfiePhotoPath, isNull);
      expect(data.selfieVerified, isFalse);
    });
  });

  group('PhotosVerificationData copyWith', () {
    test('copies fields without mutating the original', () {
      const original = PhotosVerificationData();
      final updated = original.copyWith(
        heightFeet: 5,
        heightInches: 9,
        languages: ['English', 'Spanish'],
      );
      expect(original.heightFeet, isNull);
      expect(original.languages, isEmpty);
      expect(updated.heightFeet, 5);
      expect(updated.heightInches, 9);
      expect(updated.languages, ['English', 'Spanish']);
    });

    test('preserves unmentioned fields', () {
      const original = PhotosVerificationData(
        heightFeet: 5,
        heightInches: 7,
        heightUnit: HeightUnit.feet,
      );
      final updated = original.copyWith(languages: ['Tamil']);
      expect(updated.heightFeet, 5);
      expect(updated.heightInches, 7);
      expect(updated.heightUnit, HeightUnit.feet);
      expect(updated.languages, ['Tamil']);
    });
  });

  group('PhotosVerificationData equality', () {
    test('two identical instances are equal', () {
      const a = PhotosVerificationData(
        heightCm: 170,
        heightUnit: HeightUnit.cm,
        languages: ['English'],
      );
      const b = PhotosVerificationData(
        heightCm: 170,
        heightUnit: HeightUnit.cm,
        languages: ['English'],
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('different values are not equal', () {
      const a = PhotosVerificationData(heightCm: 170);
      const b = PhotosVerificationData(heightCm: 171);
      expect(a, isNot(b));
    });
  });

  group('PhotosVerificationStep', () {
    test('isLast is true only for complete', () {
      expect(PhotosVerificationStep.height.isLast, isFalse);
      expect(PhotosVerificationStep.language.isLast, isFalse);
      expect(PhotosVerificationStep.photos.isLast, isFalse);
      expect(PhotosVerificationStep.complete.isLast, isTrue);
    });

    test('values are in declared order', () {
      expect(PhotosVerificationStep.values, [
        PhotosVerificationStep.height,
        PhotosVerificationStep.language,
        PhotosVerificationStep.photos,
        PhotosVerificationStep.complete,
      ]);
    });
  });

  group('HeightUnit', () {
    test('displayLabel returns FT/CM', () {
      expect(HeightUnit.feet.displayLabel, 'FT');
      expect(HeightUnit.cm.displayLabel, 'CM');
    });
  });

  group('SupportedLanguages', () {
    test('contains canonical entries used by the language screen', () {
      expect(SupportedLanguages.all, contains('English'));
      expect(SupportedLanguages.all, contains('Hindi'));
      expect(SupportedLanguages.all, contains('Tamil'));
    });

    test('has no duplicates', () {
      final set = SupportedLanguages.all.toSet();
      expect(set.length, SupportedLanguages.all.length);
    });
  });
}
