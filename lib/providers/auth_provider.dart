/// Authentication Provider
/// Riverpod state management for Firebase OAuth 2.0
/// Run: flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

// ---------------------------------------------------------------------------
// Service provider
// ---------------------------------------------------------------------------

@riverpod
AuthService authService(Ref ref) => AuthService();

// ---------------------------------------------------------------------------
// Auth state — persists across the entire app lifetime
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Firebase is not yet configured in this PR — start unauthenticated.
    // Reactive auth-state subscription is added when firebase_auth lands in PR #2.
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  Future<void> signInWithGoogle() async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final service = ref.read(authServiceProvider);
      await service.signInWithGoogle().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException(
          'Sign-in timed out. Please check your connection and try again.',
        ),
      );
      // When Firebase lands in PR #2, the service will update state via
      // authStateChanges stream. For now this path is unreachable (stub throws).
    } on TimeoutException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message ?? 'Sign-in timed out.',
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Apple Sign-In
  // ---------------------------------------------------------------------------

  Future<void> signInWithApple() async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final service = ref.read(authServiceProvider);
      await service.signInWithApple().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException(
          'Sign-in timed out. Please check your connection and try again.',
        ),
      );
      // When Firebase lands in PR #2, the service will update state via
      // authStateChanges stream. For now this path is unreachable (stub throws).
    } on TimeoutException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message ?? 'Sign-in timed out.',
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Cancel an in-flight sign-in (M6)
  // ---------------------------------------------------------------------------

  /// Reverts the loading state. Any in-flight Future will see the state is
  /// no longer [AuthStatus.loading] and will discard its result.
  void cancelSignIn() {
    if (state.status == AuthStatus.loading) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  // ---------------------------------------------------------------------------
  // Phone — marks intent; actual OTP is handled by VerificationFlowScreen
  // ---------------------------------------------------------------------------

  void selectPhoneSignIn() {
    state = state.copyWith(lastProvider: SignInMethod.phone);
  }

  // ---------------------------------------------------------------------------
  // Sign-out
  // ---------------------------------------------------------------------------

  Future<void> signOut() async {
    final service = ref.read(authServiceProvider);
    await service.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  // ---------------------------------------------------------------------------
  // Error dismissal
  // ---------------------------------------------------------------------------

  void clearError() {
    if (state.status == AuthStatus.error) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }
}

// ---------------------------------------------------------------------------
// Convenience derived provider — true if any user is logged in
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
bool isAuthenticated(Ref ref) {
  return ref.watch(authProvider).isAuthenticated;
}
