/// Custom exception types for API/network errors.
///
/// All exceptions thrown by [ApiClient] / interceptors derive from
/// [ApiException], so callers can catch a single base type and inspect
/// subtype if they need to react differently to auth vs validation vs
/// network failures.
library;

sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? cause;

  const ApiException(this.message, {this.statusCode, this.cause});

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

/// Connection / timeout / DNS / TLS failure. No HTTP response received.
class NetworkException extends ApiException {
  const NetworkException(super.message, {super.cause});
}

/// 401 / 403. Token missing, expired, or insufficient scope.
class AuthException extends ApiException {
  const AuthException(super.message, {super.statusCode, super.cause});
}

/// 400 / 422. Server rejected the request payload.
class ValidationException extends ApiException {
  /// Optional field-level errors keyed by field name (e.g. `{"email": "invalid"}`).
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    super.statusCode,
    super.cause,
    this.fieldErrors,
  });
}

/// 5xx. Server-side failure; the retry interceptor will have already
/// burned its retries by the time this is thrown.
class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode, super.cause});
}

/// 4xx other than 401/403/422. Caller should treat as a hard client error.
class ClientException extends ApiException {
  const ClientException(super.message, {super.statusCode, super.cause});
}
