/// Authentication Models
/// Freezed immutable state for Firebase OAuth flow
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_models.freezed.dart';

/// Authentication status
enum AuthStatus {
  /// No user signed in
  unauthenticated,

  /// Auth operation in progress (loading spinner)
  loading,

  /// User successfully authenticated
  authenticated,

  /// An error occurred during auth
  error,
}

/// Sign-in method selected by the user
enum SignInMethod {
  google,
  apple,
  phone,
}

/// Immutable authentication state
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.unauthenticated) AuthStatus status,
    User? user,
    @Default(null) String? errorMessage,
    @Default(null) SignInMethod? lastProvider,
  }) = _AuthState;

  /// Convenience: user is signed in
  const AuthState._();
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
}
