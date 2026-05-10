/// Auth state models — plain Dart, no Firebase or Freezed dependency.
/// Freezed version lands alongside firebase_auth in PR #2.
library;

import 'app_user.dart';

enum AuthStatus { unauthenticated, loading, authenticated, error }

enum SignInMethod { phone, google, apple }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.lastProvider,
  });

  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;
  final SignInMethod? lastProvider;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? errorMessage,
    SignInMethod? lastProvider,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        lastProvider: lastProvider ?? this.lastProvider,
      );
}
