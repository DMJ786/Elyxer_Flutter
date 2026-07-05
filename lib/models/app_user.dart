/// AppUser — Freezed model representing an authenticated user.
///
/// Wraps the essential fields from firebase_auth.User while remaining
/// Freezed-friendly (value equality, immutability, no raw SDK reference stored
/// outside this file).
library;

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
  }) = _AppUser;

  /// Construct an [AppUser] from a raw Firebase [User].
  factory AppUser.fromFirebase(User user) => AppUser(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );
}
