/// Dio interceptor that retries failed requests with exponential backoff.
///
/// Retries on:
///   - Network failures (no response)
///   - 5xx server errors
///   - 408 Request Timeout
///   - 429 Too Many Requests (respects `Retry-After` header if present)
///
/// Does NOT retry on:
///   - 4xx client errors (except 408/429)
///   - Cancelled requests
///   - Requests explicitly opting out via `extra['skipRetry'] = true`
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;

  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
  }) : _dio = dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    if (options.extra['skipRetry'] == true) {
      handler.next(err);
      return;
    }

    final attempt = (options.extra['retryAttempt'] as int?) ?? 0;
    if (attempt >= maxRetries || !_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final delay = _delayFor(attempt, err);
    await Future<void>.delayed(delay);

    options.extra['retryAttempt'] = attempt + 1;

    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    // Network-level failures with no response.
    if (err.response == null) {
      return err.type != DioExceptionType.cancel &&
          err.type != DioExceptionType.badCertificate;
    }

    final status = err.response!.statusCode ?? 0;
    return status >= 500 || status == 408 || status == 429;
  }

  Duration _delayFor(int attempt, DioException err) {
    // Honor Retry-After when the server gives us one (seconds form only).
    final retryAfter = err.response?.headers.value('retry-after');
    if (retryAfter != null) {
      final seconds = int.tryParse(retryAfter);
      if (seconds != null && seconds > 0) {
        return Duration(seconds: math.min(seconds, 30));
      }
    }
    // Exponential backoff: 1s, 2s, 4s.
    final multiplier = math.pow(2, attempt).toInt();
    return baseDelay * multiplier;
  }
}
