/// AuthInterceptor tests.
///
/// Verifies the interceptor attaches the Firebase ID token as a bearer header,
/// skips the header when nobody is signed in, and refreshes-and-retries exactly
/// once on a 401. Firebase is never booted — the token source is injected via a
/// fake [IdTokenProvider], and HTTP is faked with a tiny [HttpClientAdapter].
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/core/network/auth_interceptor.dart';

/// Records the `Authorization` header seen on each outgoing request and returns
/// a caller-supplied status code per call index.
class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter(this.statusForCall);

  /// Maps a 0-based call index to the HTTP status to return.
  final int Function(int callIndex) statusForCall;

  final List<String?> authHeaders = [];
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    authHeaders.add(options.headers['Authorization'] as String?);
    final status = statusForCall(callCount);
    callCount++;
    return ResponseBody.fromString(
      '{}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Fake ID-token source. Returns `stale-token` until a forced refresh, then
/// `fresh-token`. Returns `null` when [signedIn] is false.
class _FakeTokenProvider {
  _FakeTokenProvider({this.signedIn = true});

  bool signedIn;
  int forceRefreshCalls = 0;
  int totalCalls = 0;
  bool _refreshed = false;

  Future<String?> call({bool forceRefresh = false}) async {
    totalCalls++;
    if (forceRefresh) {
      forceRefreshCalls++;
      _refreshed = true;
    }
    if (!signedIn) return null;
    return _refreshed ? 'fresh-token' : 'stale-token';
  }
}

/// Builds a Dio wired with only the [AuthInterceptor] under test, mirroring the
/// production client's `validateStatus: (_) => true` so a 401 arrives as a
/// normal Response (not a thrown DioException).
Dio _dioWith(_RecordingAdapter adapter, _FakeTokenProvider provider) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://example.test',
      validateStatus: (_) => true,
    ),
  );
  dio.httpClientAdapter = adapter;
  dio.interceptors.add(AuthInterceptor(dio: dio, tokenProvider: provider.call));
  return dio;
}

void main() {
  group('AuthInterceptor', () {
    test('attaches Bearer header when a user is signed in', () async {
      final adapter = _RecordingAdapter((_) => 200);
      final provider = _FakeTokenProvider(signedIn: true);
      final dio = _dioWith(adapter, provider);

      final res = await dio.get<dynamic>('/ping');

      expect(res.statusCode, 200);
      expect(adapter.callCount, 1);
      expect(adapter.authHeaders.single, 'Bearer stale-token');
    });

    test('sends no header when no user is signed in', () async {
      final adapter = _RecordingAdapter((_) => 200);
      final provider = _FakeTokenProvider(signedIn: false);
      final dio = _dioWith(adapter, provider);

      final res = await dio.get<dynamic>('/ping');

      expect(res.statusCode, 200);
      expect(adapter.callCount, 1);
      expect(adapter.authHeaders.single, isNull);
    });

    test('401 triggers exactly one refresh + retry, then succeeds', () async {
      // First call 401, second call (post-refresh) 200.
      final adapter = _RecordingAdapter((call) => call == 0 ? 401 : 200);
      final provider = _FakeTokenProvider(signedIn: true);
      final dio = _dioWith(adapter, provider);

      final res = await dio.get<dynamic>('/secure');

      expect(res.statusCode, 200);
      expect(provider.forceRefreshCalls, 1, reason: 'refresh exactly once');
      expect(adapter.callCount, 2, reason: 'original + one retry');
      expect(adapter.authHeaders, ['Bearer stale-token', 'Bearer fresh-token']);
    });

    test('repeated 401 propagates after a single retry', () async {
      // Every call 401, even after refresh.
      final adapter = _RecordingAdapter((_) => 401);
      final provider = _FakeTokenProvider(signedIn: true);
      final dio = _dioWith(adapter, provider);

      final res = await dio.get<dynamic>('/secure');

      expect(res.statusCode, 401, reason: 'final 401 reaches the caller');
      expect(provider.forceRefreshCalls, 1, reason: 'no infinite refresh loop');
      expect(adapter.callCount, 2, reason: 'original + exactly one retry');
    });

    test('401 with no signed-in user is not retried', () async {
      final adapter = _RecordingAdapter((_) => 401);
      final provider = _FakeTokenProvider(signedIn: false);
      final dio = _dioWith(adapter, provider);

      final res = await dio.get<dynamic>('/secure');

      expect(res.statusCode, 401);
      expect(provider.forceRefreshCalls, 1, reason: 'one refresh attempt');
      expect(adapter.callCount, 1, reason: 'no retry without a token');
      expect(adapter.authHeaders.single, isNull);
    });
  });
}
