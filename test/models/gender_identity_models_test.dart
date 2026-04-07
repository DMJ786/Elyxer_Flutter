/// Gender Identity Models Tests
/// Tests for GenderIdentityOption and GenderIdentityOptions
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/models/gender_identity_models.dart';

void main() {
  group('GenderIdentityOption', () {
    test('should store id and label correctly', () {
      const option = GenderIdentityOption(id: 'test_id', label: 'Test Label');
      expect(option.id, equals('test_id'));
      expect(option.label, equals('Test Label'));
    });

    test('should be const constructible', () {
      const option = GenderIdentityOption(id: 'a', label: 'A');
      expect(option, isNotNull);
    });
  });

  group('GenderIdentityOptions.man', () {
    test('should have 6 options', () {
      expect(GenderIdentityOptions.man.length, equals(6));
    });

    test('should contain expected identity options', () {
      final ids = GenderIdentityOptions.man.map((o) => o.id).toList();
      expect(ids, contains('man'));
      expect(ids, contains('cisgender_man'));
      expect(ids, contains('intersex_man'));
      expect(ids, contains('transgender_man'));
      expect(ids, contains('transmasculine'));
      expect(ids, contains('man_and_nonbinary'));
    });

    test('should have correct labels', () {
      final labels = GenderIdentityOptions.man.map((o) => o.label).toList();
      expect(labels, contains('Man'));
      expect(labels, contains('Cis man'));
      expect(labels, contains('Intersex Man'));
      expect(labels, contains('Trans man'));
      expect(labels, contains('Transmasculine'));
      expect(labels, contains('Man & Nonbinary'));
    });

    test('each option should have non-empty id and label', () {
      for (final option in GenderIdentityOptions.man) {
        expect(option.id.isNotEmpty, isTrue);
        expect(option.label.isNotEmpty, isTrue);
      }
    });

    test('should have unique ids', () {
      final ids = GenderIdentityOptions.man.map((o) => o.id).toSet();
      expect(ids.length, equals(GenderIdentityOptions.man.length));
    });
  });

  group('GenderIdentityOptions.woman', () {
    test('should have 6 options', () {
      expect(GenderIdentityOptions.woman.length, equals(6));
    });

    test('should contain expected identity options', () {
      final ids = GenderIdentityOptions.woman.map((o) => o.id).toList();
      expect(ids, contains('woman'));
      expect(ids, contains('cisgender_woman'));
      expect(ids, contains('intersex_woman'));
      expect(ids, contains('transgender_woman'));
      expect(ids, contains('transfeminine'));
      expect(ids, contains('woman_and_nonbinary'));
    });

    test('should have correct labels', () {
      final labels = GenderIdentityOptions.woman.map((o) => o.label).toList();
      expect(labels, contains('Woman'));
      expect(labels, contains('Cis woman'));
      expect(labels, contains('Intersex Woman'));
      expect(labels, contains('Trans woman'));
      expect(labels, contains('Transfeminine'));
      expect(labels, contains('Woman & Nonbinary'));
    });

    test('each option should have non-empty id and label', () {
      for (final option in GenderIdentityOptions.woman) {
        expect(option.id.isNotEmpty, isTrue);
        expect(option.label.isNotEmpty, isTrue);
      }
    });

    test('should have unique ids', () {
      final ids = GenderIdentityOptions.woman.map((o) => o.id).toSet();
      expect(ids.length, equals(GenderIdentityOptions.woman.length));
    });
  });

  group('GenderIdentityOptions.nonBinary', () {
    test('should have 14 options', () {
      expect(GenderIdentityOptions.nonBinary.length, equals(14));
    });

    test('should contain expected identity options', () {
      final ids = GenderIdentityOptions.nonBinary.map((o) => o.id).toList();
      expect(ids, contains('agender'));
      expect(ids, contains('bigender'));
      expect(ids, contains('genderfluid'));
      expect(ids, contains('genderqueer'));
      expect(ids, contains('gender_nonconfirming'));
      expect(ids, contains('gender_questioning'));
      expect(ids, contains('gender_variant'));
      expect(ids, contains('intersex'));
      expect(ids, contains('neutrois'));
      expect(ids, contains('nonbinary_man'));
      expect(ids, contains('pangender'));
      expect(ids, contains('polygender'));
      expect(ids, contains('transgender'));
      expect(ids, contains('two_spirit'));
    });

    test('should have correct labels', () {
      final labels =
          GenderIdentityOptions.nonBinary.map((o) => o.label).toList();
      expect(labels, contains('Agender'));
      expect(labels, contains('Bigender'));
      expect(labels, contains('Genderfluid'));
      expect(labels, contains('Genderqueer'));
      expect(labels, contains('Gender nonconfirming'));
      expect(labels, contains('Gender questioning'));
      expect(labels, contains('Gender variant'));
      expect(labels, contains('Intersex'));
      expect(labels, contains('Neutrois'));
      expect(labels, contains('Nonbinary man'));
      expect(labels, contains('Pangender'));
      expect(labels, contains('Polygender'));
      expect(labels, contains('Transgender'));
      expect(labels, contains('Two-Spirit'));
    });

    test('each option should have non-empty id and label', () {
      for (final option in GenderIdentityOptions.nonBinary) {
        expect(option.id.isNotEmpty, isTrue);
        expect(option.label.isNotEmpty, isTrue);
      }
    });

    test('should have unique ids', () {
      final ids = GenderIdentityOptions.nonBinary.map((o) => o.id).toSet();
      expect(ids.length, equals(GenderIdentityOptions.nonBinary.length));
    });
  });

  group('GenderIdentityOptions cross-list', () {
    test('man, woman, and nonBinary should have no overlapping ids', () {
      final manIds = GenderIdentityOptions.man.map((o) => o.id).toSet();
      final womanIds = GenderIdentityOptions.woman.map((o) => o.id).toSet();
      final nbIds = GenderIdentityOptions.nonBinary.map((o) => o.id).toSet();

      expect(manIds.intersection(womanIds), isEmpty);
      expect(manIds.intersection(nbIds), isEmpty);
      expect(womanIds.intersection(nbIds), isEmpty);
    });
  });
}
