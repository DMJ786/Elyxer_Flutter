/// Authentication Provider
/// Riverpod state management for Firebase OAuth 2.0
/// Run: flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'package:firebase_auth/firebase_auth.dart';
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
    // Sync current Firebase user into initial state
    final user = FirebaseAuth.instance.currentUser;
    return AuthState(
      status: user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      user: user,
    );
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  Future<void> signInWithGoogle() async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final service = ref.read(authServiceProvider);
      final credential = await service.signInWithGoogle();
      state = AuthState(
        status: AuthStatus.authenticated,
        user: credential.user,
        lastProvider: SignInMethod.google,
      );
    } on FirebaseAuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message ?? 'Google sign-in failed.',
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
      final credential = await service.signInWithApple();
      state = AuthState(
        status: AuthStatus.authenticated,
        user: credential.user,
        lastProvider: SignInMethod.apple,
      );
    } on FirebaseAuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message ?? 'Apple sign-in failed.',
      );
    } catch (_) {
      // User cancelled native Apple sheet — treat as unauthenticated (no error UI)
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
