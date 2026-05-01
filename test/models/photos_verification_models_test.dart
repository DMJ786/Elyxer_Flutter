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
    test('primary catalog includes all 22 scheduled Indian languages', () {
      const scheduled = [
        'Assamese', 'Bengali', 'Bodo', 'Dogri', 'Gujarati', 'Hindi',
        'Kannada', 'Kashmiri', 'Konkani', 'Maithili', 'Malayalam',
        'Manipuri', 'Marathi', 'Nepali', 'Odia', 'Punjabi', 'Sanskrit',
        'Santali', 'Sindhi', 'Tamil', 'Telugu', 'Urdu',
      ];
      for (final lang in scheduled) {
        expect(SupportedLanguages.primary, contains(lang),
            reason: '$lang should be in primary catalog');
      }
    });

    test('primary catalog includes English', () {
      expect(SupportedLanguages.primary, contains('English'));
    });

    test('international catalog has agreed common second-languages', () {
      expect(SupportedLanguages.international, contains('Spanish'));
      expect(SupportedLanguages.international, contains('Mandarin'));
      expect(SupportedLanguages.international, contains('Arabic'));
    });

    test('all catalog has no duplicates', () {
      final set = SupportedLanguages.all.toSet();
      expect(set.length, SupportedLanguages.all.length);
    });

    test('total catalog size is in the agreed ~50 range', () {
      // Hard floor + ceiling so a careless edit doesn't drift the catalog.
      expect(SupportedLanguages.all.length, inInclusiveRange(45, 55));
    });
  });

  group('rankLanguageSuggestions', () {
    test('returns empty list for empty query', () {
      expect(
        rankLanguageSuggestions(query: '', selected: const []),
        isEmpty,
      );
      expect(
        rankLanguageSuggestions(query: '   ', selected: const []),
        isEmpty,
      );
    });

    test('excludes already-selected languages', () {
      final result = rankLanguageSuggestions(
        query: 'eng',
        selected: const ['English'],
      );
      expect(result, isNot(contains('English')));
    });

    test('prefix match outranks substring match across catalogs', () {
      // 'in' matches: Indonesian (prefix intl), Hindi/Sindhi (substring
      // primary), Mandarin (substring intl). Prefix wins regardless of
      // primary/international tier.
      final result =
          rankLanguageSuggestions(query: 'in', selected: const []);
      final indonesianIdx = result.indexOf('Indonesian');
      final hindiIdx = result.indexOf('Hindi');
      expect(indonesianIdx, isNonNegative);
      expect(hindiIdx, isNonNegative);
      expect(indonesianIdx, lessThan(hindiIdx),
          reason: 'Indonesian (prefix) must rank above Hindi (substring)');
    });

    test('primary outranks international on prefix-match ties', () {
      // 'P' is a prefix of: Punjabi (primary), Persian/Portuguese (intl).
      final result =
          rankLanguageSuggestions(query: 'P', selected: const []);
      final punjabiIdx = result.indexOf('Punjabi');
      final persianIdx = result.indexOf('Persian');
      expect(punjabiIdx, isNonNegative);
      expect(persianIdx, isNonNegative);
      expect(punjabiIdx, lessThan(persianIdx),
          reason: 'Punjabi (primary) must rank above Persian (intl)');
    });

    test('alphabetical tiebreak within same rank', () {
      // 'P' prefix in international: Persian, Portuguese.
      final result =
          rankLanguageSuggestions(query: 'P', selected: const []);
      final persianIdx = result.indexOf('Persian');
      final portugueseIdx = result.indexOf('Portuguese');
      expect(persianIdx, lessThan(portugueseIdx));
    });

    test('caps results at kMaxSuggestions (10)', () {
      // 'a' matches a large set across primary + international.
      final result =
          rankLanguageSuggestions(query: 'a', selected: const []);
      expect(result.length, lessThanOrEqualTo(kMaxSuggestions));
      expect(result.length, equals(10),
          reason: 'with 49-entry catalog, "a" should saturate the cap');
    });

    test('case-insensitive', () {
      final lower =
          rankLanguageSuggestions(query: 'tam', selected: const []);
      final upper =
          rankLanguageSuggestions(query: 'TAM', selected: const []);
      expect(lower, equals(upper));
      expect(lower, contains('Tamil'));
    });
  });
}
