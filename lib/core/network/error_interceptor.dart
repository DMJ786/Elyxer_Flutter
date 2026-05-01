/// Dio interceptor that converts low-level [DioException]s into the app's
/// [ApiException] hierarchy. Callers always work with `ApiException` and
/// don't need to know about Dio.
library;

import 'package:dio/dio.dart';

import 'api_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _mapToApiException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
        message: apiException.message,
      ),
    );
  }

  ApiException _mapToApiException(DioException err) {
    // No HTTP response — connection-level failure.
    if (err.response == null) {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException('Request timed out', cause: err);
        case DioExceptionType.connectionError:
          return NetworkException('No internet connection', cause: err);
        case DioExceptionType.cancel:
          return NetworkException('Request cancelled', cause: err);
        case DioExceptionType.badCertificate:
          return NetworkException('TLS certificate rejected', cause: err);
        case DioExceptionType.badResponse:
        case DioExceptionType.unknown:
          return NetworkException(
            err.message ?? 'Unknown network error',
            cause: err,
          );
      }
    }

    final status = err.response!.statusCode ?? 0;
    final data = err.response!.data;
    final serverMessage = _extractMessage(data) ?? 'Request failed';

    if (status == 401 || status == 403) {
      return AuthException(serverMessage, statusCode: status, cause: err);
    }
    if (status == 400 || status == 422) {
      return ValidationException(
        serverMessage,
        statusCode: status,
        cause: err,
        fieldErrors: _extractFieldErrors(data),
      );
    }
    if (status >= 500) {
      return ServerException(serverMessage, statusCode: status, cause: err);
    }
    return ClientException(serverMessage, statusCode: status, cause: err);
  }

  String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      // Cloud Functions HttpsError envelope: { "error": { "message": "..." } }
      final error = data['error'];
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
      if (data['message'] is String) return data['message'] as String;
    }
    return null;
  }

  Map<String, String>? _extractFieldErrors(Object? data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'] ?? data['fieldErrors'];
      if (errors is Map) {
        return errors.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        );
      }
    }
    return null;
  }
}
