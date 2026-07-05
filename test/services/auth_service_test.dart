/// Unit tests for AuthService
///
/// Uses mocktail to inject fake FirebaseAuth / GoogleSignIn instances so tests
/// run without a real Firebase project.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dating_app_verification/services/auth_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthService service;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    // Default no-op stub so tests that don't explicitly care about
    // signOut() don't trip on AuthService.signInWithGoogle calling it
    // before signIn() (a deliberate step to force the account chooser).
    when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
    service = AuthService(auth: mockAuth, googleSignIn: mockGoogleSignIn);
  });

  // ---------------------------------------------------------------------------
  // currentUser
  // ---------------------------------------------------------------------------

  group('currentUser', () {
    test('returns null when no user is signed in', () {
      when(() => mockAuth.currentUser).thenReturn(null);
      expect(service.currentUser, isNull);
    });

    test('returns the Firebase user when signed in', () {
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      expect(service.currentUser, same(mockUser));
    });
  });

  // ---------------------------------------------------------------------------
  // authStateChanges
  // ---------------------------------------------------------------------------

  group('authStateChanges', () {
    test('exposes the FirebaseAuth authStateChanges stream', () {
      final stream = Stream<User?>.value(null);
      when(() => mockAuth.authStateChanges()).thenAnswer((_) => stream);
      expect(service.authStateChanges, equals(stream));
    });
  });

  // ---------------------------------------------------------------------------
  // signInWithGoogle (mobile path — googleSignIn returns null ⇒ cancellation)
  // ---------------------------------------------------------------------------

  group('signInWithGoogle', () {
    test('throws FirebaseAuthException when Google sign-in is cancelled', () async {
      // Simulate user dismissing the account-picker.
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      expect(
        () => service.signInWithGoogle(),
        throwsA(
          isA<FirebaseAuthException>().having(
            (e) => e.code,
            'code',
            'sign_in_cancelled',
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // signOut
  // ---------------------------------------------------------------------------

  group('signOut', () {
    test('calls signOut on both FirebaseAuth and GoogleSignIn', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      await service.signOut();

      verify(() => mockAuth.signOut()).called(1);
      verify(() => mockGoogleSignIn.signOut()).called(1);
    });

    test('propagates errors from FirebaseAuth.signOut', () async {
      when(() => mockAuth.signOut()).thenThrow(
        FirebaseAuthException(code: 'unknown'),
      );
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      expect(() => service.signOut(), throwsA(isA<FirebaseAuthException>()));
    });
  });
}
