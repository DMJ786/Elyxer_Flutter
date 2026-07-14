/// AppUser model tests.
///
/// Covers the Freezed wrapper introduced to replace the raw
/// firebase_auth.User in AuthState: field mapping from a Firebase User,
/// null handling for the optional fields, value equality, and copyWith.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dating_app_verification/models/app_user.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppUser.fromFirebase', () {
    test('maps every field from a fully-populated Firebase User', () {
      final user = MockUser();
      when(() => user.uid).thenReturn('uid-123');
      when(() => user.email).thenReturn('alice@example.com');
      when(() => user.displayName).thenReturn('Alice');
      when(() => user.photoURL).thenReturn('https://cdn.example.com/a.png');
      when(() => user.phoneNumber).thenReturn('+15551234567');

      final appUser = AppUser.fromFirebase(user);

      expect(appUser.uid, 'uid-123');
      expect(appUser.email, 'alice@example.com');
      expect(appUser.displayName, 'Alice');
      expect(appUser.photoUrl, 'https://cdn.example.com/a.png');
      expect(appUser.phoneNumber, '+15551234567');
    });

    test('keeps optional fields null when the Firebase User has none', () {
      final user = MockUser();
      when(() => user.uid).thenReturn('uid-456');
      when(() => user.email).thenReturn(null);
      when(() => user.displayName).thenReturn(null);
      when(() => user.photoURL).thenReturn(null);
      when(() => user.phoneNumber).thenReturn(null);

      final appUser = AppUser.fromFirebase(user);

      expect(appUser.uid, 'uid-456');
      expect(appUser.email, isNull);
      expect(appUser.displayName, isNull);
      expect(appUser.photoUrl, isNull);
      expect(appUser.phoneNumber, isNull);
    });

    test('maps Firebase photoURL onto the photoUrl field', () {
      final user = MockUser();
      when(() => user.uid).thenReturn('uid-789');
      when(() => user.email).thenReturn(null);
      when(() => user.displayName).thenReturn(null);
      when(() => user.photoURL).thenReturn('https://cdn.example.com/p.jpg');
      when(() => user.phoneNumber).thenReturn(null);

      expect(
        AppUser.fromFirebase(user).photoUrl,
        'https://cdn.example.com/p.jpg',
      );
    });
  });

  group('AppUser value semantics', () {
    test('two instances with identical fields are equal (value equality)', () {
      const a = AppUser(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'A',
        photoUrl: 'https://x/a.png',
        phoneNumber: '+1',
      );
      const b = AppUser(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'A',
        photoUrl: 'https://x/a.png',
        phoneNumber: '+1',
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('instances differing in any field are not equal', () {
      const base = AppUser(uid: 'u1', email: 'a@b.com');

      expect(base, isNot(equals(const AppUser(uid: 'u2', email: 'a@b.com'))));
      expect(base, isNot(equals(const AppUser(uid: 'u1', email: 'c@d.com'))));
    });

    test('copyWith overrides only the named field', () {
      const original = AppUser(uid: 'u1', email: 'a@b.com', displayName: 'A');

      final updated = original.copyWith(email: 'new@b.com');

      expect(updated.uid, 'u1');
      expect(updated.email, 'new@b.com');
      expect(updated.displayName, 'A');
      expect(updated, isNot(equals(original)));
    });
  });
}
