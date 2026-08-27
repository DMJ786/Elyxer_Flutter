/// Background (Module 4) API service.
///
/// Persists the user's education level, profession (industry + role), and
/// location to the BFF `POST /submitBackground` endpoint. The Firebase ID
/// token is attached automatically by the [ApiClient]'s auth interceptor.
library;

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/network/api_exceptions.dart';
import '../models/onboarding_models.dart';

class BackgroundService {
  BackgroundService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  static const String _path = '/submitBackground';

  /// Submits [data]'s Module 4 fields and returns the persisted profile row.
  /// Throws an [ApiException] subtype on a non-2xx response.
  Future<Map<String, dynamic>> submit(OnboardingData data) async {
    final response = await _dio.post<dynamic>(_path, data: buildBody(data));
    final status = response.statusCode ?? 0;

    if (status >= 200 && status < 300) {
      final body = response.data;
      if (body is Map && body['profile'] is Map) {
        return Map<String, dynamic>.from(body['profile'] as Map);
      }
      return <String, dynamic>{};
    }

    throw _mapError(status, response.data);
  }

  /// Builds the JSON request body. Education level maps to its BFF wire
  /// value; latitude/longitude pass through as numbers (the server converts
  /// them to a PostGIS point). Keys are camelCase to match the endpoint.
  static Map<String, dynamic> buildBody(OnboardingData data) {
    return {
      'industry': data.industry,
      'role': data.role,
      'educationLevel': data.educationLevel?.wireValue,
      'locationQuery': data.locationQuery,
      'latitude': data.latitude,
      'longitude': data.longitude,
    };
  }

  ApiException _mapError(int status, Object? data) {
    final message = _extractMessage(data) ?? 'Background submit failed';
    if (status == 401 || status == 403) {
      return AuthException(message, statusCode: status);
    }
    if (status == 400 || status == 422) {
      return ValidationException(message, statusCode: status);
    }
    if (status >= 500) {
      return ServerException(message, statusCode: status);
    }
    return ClientException(message, statusCode: status);
  }

  String? _extractMessage(Object? data) {
    if (data is Map && data['error'] is String) return data['error'] as String;
    return null;
  }
}
