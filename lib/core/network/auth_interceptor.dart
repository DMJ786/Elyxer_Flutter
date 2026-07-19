/// Dio interceptor that injects the caller's Firebase ID token as a
/// `Authorization: Bearer <token>` header on every outgoing request, and
/// transparently refreshes it once on a 401.
///
/// Server contract: every Cloud Function verifies the bearer token via
/// `functions/src/auth/verifyIdToken.ts` (Bearer scheme, `Authorization`
/// header). A request with no signed-in user goes out header-less and the
/// server answers 401 — that is expected and left for the caller to handle
/// (bounce to `/signin`).
///
/// The ID-token source is injected as [IdTokenProvider] so unit tests can
/// supply a fake without booting Firebase; the default binds to
/// `FirebaseAuth.instance.currentUser`.
library;

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Returns the current user's Firebase ID token, or `null` when nobody is
/// signed in. Pass `forceRefresh: true` to bypass the cached token and mint
/// a fresh one (used after a 401).
typedef IdTokenProvider = Future<String?> Function({bool forceRefresh});

/// Marks a request as having already been retried after a token refresh, so a
/// second 401 propagates to the caller instead of looping forever.
const String _authRetriedFlag = 'authRetried';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final IdTokenProvider _getIdToken;

  AuthInterceptor({required Dio dio, IdTokenProvider? tokenProvider})
    : _dio = dio,
      _getIdToken = tokenProvider ?? _firebaseIdToken;

  /// Default provider — reads the token off the live Firebase user.
  static Future<String?> _firebaseIdToken({bool forceRefresh = false}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Future<String?>.value(null);
    return user.getIdToken(forceRefresh);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // A failure to read the token must not block the request — send it
    // header-less and let the server reply 401.
    try {
      final token = await _getIdToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Swallow: proceed without the header.
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final options = response.requestOptions;
    final alreadyRetried = options.extra[_authRetriedFlag] == true;

    // Only intervene on a first-time 401 for a signed-in user.
    if (response.statusCode != 401 || alreadyRetried) {
      handler.next(response);
      return;
    }

    String? freshToken;
    try {
      freshToken = await _getIdToken(forceRefresh: true);
    } catch (_) {
      // Refresh failed — surface the original 401.
      handler.next(response);
      return;
    }

    // No user (or empty token): nothing to retry with, let the 401 through.
    if (freshToken == null || freshToken.isEmpty) {
      handler.next(response);
      return;
    }

    options
      ..extra[_authRetriedFlag] = true
      ..headers['Authorization'] = 'Bearer $freshToken';

    try {
      final retried = await _dio.fetch<dynamic>(options);
      handler.resolve(retried);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }
}
