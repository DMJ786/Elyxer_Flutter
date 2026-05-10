/// Authentication Service — stub implementation.
/// Firebase Auth, Google Sign-In, and Sign in with Apple are wired up in PR #2
/// (Bundle 1) alongside firebase_core and the FlutterFire configure.
library;

class AuthService {
  AuthService();

  /// Sign in with Google — not yet implemented (requires firebase_auth / PR #2).
  Future<void> signInWithGoogle() async {
    throw UnimplementedError('Google sign-in requires firebase_auth (PR #2).');
  }

  /// Sign in with Apple — not yet implemented (requires firebase_auth / PR #2).
  Future<void> signInWithApple() async {
    throw UnimplementedError('Apple sign-in requires firebase_auth (PR #2).');
  }

  /// Sign out — no-op until Firebase lands in PR #2.
  Future<void> signOut() async {}
}
