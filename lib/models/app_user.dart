/// Simple user model — no Firebase dependency.
/// Will be wired to firebase_auth in PR #2.
library;

class AppUser {
  const AppUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  /// Builds an [AppUser] from a Firebase User object once firebase_auth lands.
  factory AppUser.fromFirebase(dynamic user) => AppUser(
        uid: (user.uid as String?) ?? '',
        displayName: user.displayName as String?,
        email: user.email as String?,
        photoUrl: user.photoURL as String?,
      );
}
