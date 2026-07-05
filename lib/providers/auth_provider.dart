/// Authentication Provider
/// Riverpod state management for Firebase OAuth 2.0
/// Run: flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/app_user.dart';
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
    // Guard: if Firebase hasn't been configured (placeholder values), skip SDK calls
    // so the rest of the app remains runnable without flutterfire configure.
    if (Firebase.apps.isEmpty) {
      return const AuthState(status: AuthStatus.unauthenticated);
    }

    // Subscribe to auth state changes reactively (C3).
    // The subscription is cancelled automatically when this provider is disposed.
    final subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      // Don't stomp an in-flight explicit sign-in operation.
      if (state.status == AuthStatus.loading) return;
      state = AuthState(
        status: user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        user: user != null ? AppUser.fromFirebase(user) : null,
      );
    });
    ref.onDispose(subscription.cancel);

    final currentUser = FirebaseAuth.instance.currentUser;
    return AuthState(
      status: currentUser != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      user: currentUser != null ? AppUser.fromFirebase(currentUser) : null,
    );
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  Future<void> signInWithGoogle() async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final service = ref.read(authServiceProvider);
      final credential = await service.signInWithGoogle().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException(
          'Sign-in timed out. Please check your connection and try again.',
        ),
      );
      // Guard: user may have pressed cancel while sign-in was in flight.
      if (state.status != AuthStatus.loading) return;
      final fbUser = credential.user;
      if (fbUser == null) {
        state = const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Google sign-in completed but returned no user.',
        );
        return;
      }
      state = AuthState(
        status: AuthStatus.authenticated,
        user: AppUser.fromFirebase(fbUser),
        lastProvider: SignInMethod.google,
      );
    } on TimeoutException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message ?? 'Sign-in timed out.',
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
      final credential = await service.signInWithApple().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException(
          'Sign-in timed out. Please check your connection and try again.',
        ),
      );
      // Guard: user may have pressed cancel while sign-in was in flight.
      if (state.status != AuthStatus.loading) return;
      final fbUser = credential.user;
      if (fbUser == null) {
        state = const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Apple sign-in completed but returned no user.',
        );
        return;
      }
      state = AuthState(
        status: AuthStatus.authenticated,
        user: AppUser.fromFirebase(fbUser),
        lastProvider: SignInMethod.apple,
      );
    } on TimeoutException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message ?? 'Sign-in timed out.',
      );
    } on FirebaseAuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message ?? 'Apple sign-in failed.',
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      // Only silence a deliberate user cancellation; surface all other codes.
      if (e.code == AuthorizationErrorCode.canceled) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      } else {
        state = AuthState(
          status: AuthStatus.error,
          errorMessage: e.message,
        );
      }
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
