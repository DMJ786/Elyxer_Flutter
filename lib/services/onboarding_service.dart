/// Onboarding API service.
///
/// Persists the user's Module 1 (age, gender, pronouns) and Module 2
/// (sexual orientation, dating preferences, dating goals) selections to the
/// BFF `POST /submitOnboarding` endpoint. The Firebase ID token is attached
/// automatically by the [ApiClient]'s auth interceptor.
library;

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/network/api_exceptions.dart';
import '../models/onboarding_models.dart';

class OnboardingService {
  OnboardingService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  static const String _path = '/submitOnboarding';

  /// Submits [data] and returns the persisted profile row from the server.
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

  /// Builds the JSON request body, mapping enums to their BFF wire values and
  /// the birthdate to an ISO `YYYY-MM-DD` string. Keys are camelCase to match
  /// the endpoint contract (same convention as `submitUsername`).
  static Map<String, dynamic> buildBody(OnboardingData data) {
    return {
      'birthdate': data.birthdate == null ? null : _isoDate(data.birthdate!),
      'gender': data.gender?.wireValue,
      'customGenderIdentity': data.customGenderIdentity,
      'genderIdentityOptionIds': data.genderIdentityOptionIds,
      'pronouns': data.pronouns,
      'customPronoun': data.customPronoun,
      'showGenderOnProfile': data.showGenderOnProfile,
      'showPronounsOnProfile': data.showPronounsOnProfile,
      'sexualOrientation': data.sexualOrientation?.wireValue,
      'showSexualOrientationOnProfile': data.showSexualOrientationOnProfile,
      'datingPreferences':
          data.datingPreferences.map((p) => p.wireValue).toList(),
      'datingGoalIds': data.datingGoalIds,
    };
  }

  static String _isoDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  ApiException _mapError(int status, Object? data) {
    final message = _extractMessage(data) ?? 'Onboarding submit failed';
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
