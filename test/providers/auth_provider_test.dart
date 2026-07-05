/// Unit tests for AuthNotifier state transitions.
///
/// Firebase is never initialized in this test environment.  AuthNotifier.build()
/// guards with Firebase.apps.isEmpty and returns unauthenticated, so every test
/// starts from a clean, predictable state without needing a real Firebase project.
///
/// authServiceProvider is overridden with a MockAuthService so sign-in delegates
/// are fully controllable in tests.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:dating_app_verification/models/auth_models.dart';
import 'package:dating_app_verification/providers/auth_provider.dart';
import 'package:dating_app_verification/services/auth_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class MockAuthService extends Mock implements AuthService {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Creates a [ProviderContainer] that injects [mockService] in place of the
/// real [AuthService] so no Firebase call escapes into the test environment.
ProviderContainer _makeContainer(MockAuthService mockService) {
  final container = ProviderContainer(
    overrides: [
      authServiceProvider.overrideWithValue(mockService),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late MockAuthService mockService;

  setUp(() {
    mockService = MockAuthService();
  });

  // ---------------------------------------------------------------------------
  // Initial state
  // ---------------------------------------------------------------------------

  group('initial state', () {
    test('is unauthenticated when Firebase is not initialized', () {
      // Firebase.apps.isEmpty == true in test environment → build() returns
      // unauthenticated without touching FirebaseAuth.instance.
      final container = _makeContainer(mockService);
      final state = container.read(authProvider);

      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // signInWithGoogle
  // ---------------------------------------------------------------------------

  group('signInWithGoogle', () {
    test('sets error state on FirebaseAuthException', () async {
      when(() => mockService.signInWithGoogle()).thenThrow(
        FirebaseAuthException(code: 'network-request-failed', message: 'No internet'),
      );

      final container = _makeContainer(mockService);
      await container.read(authProvider.notifier).signInWithGoogle();
      final state = container.read(authProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, contains('No internet'));
    });

    test('sets error state on unexpected exception', () async {
      when(() => mockService.signInWithGoogle()).thenThrow(Exception('unexpected'));

      final container = _makeContainer(mockService);
      await container.read(authProvider.notifier).signInWithGoogle();
      final state = container.read(authProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  // signInWithApple
  // ---------------------------------------------------------------------------

  group('signInWithApple', () {
    test('sets error state on FirebaseAuthException', () async {
      when(() => mockService.signInWithApple()).thenThrow(
        FirebaseAuthException(code: 'invalid-credential', message: 'Bad credential'),
      );

      final container = _makeContainer(mockService);
      await container.read(authProvider.notifier).signInWithApple();
      final state = container.read(authProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, contains('Bad credential'));
    });

    test('sets error state on generic exception', () async {
      when(() => mockService.signInWithApple()).thenThrow(Exception('unknown'));

      final container = _makeContainer(mockService);
      await container.read(authProvider.notifier).signInWithApple();
      final state = container.read(authProvider);

      expect(state.status, AuthStatus.error);
    });

    // H3: SignInWithAppleAuthorizationException handling
    test('silently sets unauthenticated when user cancels Apple sheet', () async {
      when(() => mockService.signInWithApple()).thenThrow(
        SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.canceled,
          message: 'User canceled',
        ),
      );

      final container = _makeContainer(mockService);
      await container.read(authProvider.notifier).signInWithApple();
      final state = container.read(authProvider);

      // Cancellation must NOT produce an error — just unauthenticated.
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.errorMessage, isNull);
    });

    test('sets error state for non-canceled Apple authorization errors', () async {
      when(() => mockService.signInWithApple()).thenThrow(
        SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.failed,
          message: 'Authorization failed',
        ),
      );

      final container = _makeContainer(mockService);
      await container.read(authProvider.notifier).signInWithApple();
      final state = container.read(authProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  // signOut
  // ---------------------------------------------------------------------------

  group('signOut', () {
    test('sets state to unauthenticated', () async {
      when(() => mockService.signOut()).thenAnswer((_) async {});

      final container = _makeContainer(mockService);
      await container.read(authProvider.notifier).signOut();
      final state = container.read(authProvider);

      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      verify(() => mockService.signOut()).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // clearError
  // ---------------------------------------------------------------------------

  group('clearError', () {
    test('resets error state to unauthenticated', () async {
      when(() => mockService.signInWithGoogle()).thenThrow(
        FirebaseAuthException(code: 'cancelled'),
      );

      final container = _makeContainer(mockService);
      await container.read(authProvider.notifier).signInWithGoogle();
      expect(container.read(authProvider).status, AuthStatus.error);

      container.read(authProvider.notifier).clearError();
      expect(container.read(authProvider).status, AuthStatus.unauthenticated);
    });

    test('is a no-op when state is not error', () {
      final container = _makeContainer(mockService);
      // Initial state is unauthenticated, not error.
      container.read(authProvider.notifier).clearError();
      expect(container.read(authProvider).status, AuthStatus.unauthenticated);
    });
  });

  // ---------------------------------------------------------------------------
  // selectPhoneSignIn
  // ---------------------------------------------------------------------------

  group('selectPhoneSignIn', () {
    test('sets lastProvider to phone without changing status', () {
      final container = _makeContainer(mockService);
      container.read(authProvider.notifier).selectPhoneSignIn();
      final state = container.read(authProvider);

      expect(state.lastProvider, SignInMethod.phone);
      expect(state.status, AuthStatus.unauthenticated);
    });
  });
}
