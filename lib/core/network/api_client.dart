/// Singleton Dio HTTP client wired with auth, error, and retry interceptors.
///
/// Usage:
/// ```dart
/// final response = await ApiClient.instance.dio.post('/auth/submitUsername', data: {...});
/// ```
///
/// For tests, construct a fresh instance via [ApiClient.test] and inject a
/// mock [Dio] (e.g. via `http_mock_adapter`).
library;

import 'package:dio/dio.dart';

import '../config/env.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'retry_interceptor.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  static ApiClient? _instance;

  /// Lazily-built singleton. Safe to call from anywhere.
  static ApiClient get instance => _instance ??= _build();

  /// Reset the singleton. Tests only.
  static void resetForTesting() {
    _instance = null;
  }

  /// Build a fresh client (used by [instance] and tests).
  factory ApiClient.test({Dio? dio}) {
    return ApiClient._(dio ?? _buildDio());
  }

  static ApiClient _build() {
    final dio = _buildDio();
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(RetryInterceptor(dio: dio));
    // AuthInterceptor runs last: it attaches the Firebase ID token on every
    // request and refreshes-and-retries once on a 401.
    dio.interceptors.add(AuthInterceptor(dio: dio));
    return ApiClient._(dio);
  }

  static Dio _buildDio() {
    return Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        responseType: ResponseType.json,
        // Don't auto-throw on 4xx/5xx — let ErrorInterceptor map them.
        validateStatus: (_) => true,
      ),
    );
  }
}
