/// BackgroundService tests.
///
/// buildBody unit-tests the education wire mapping and lat/lng passthrough;
/// the http_mock_adapter tests exercise the real Dio round trip — success
/// parsing (incl. server-projected coordinates) and error mapping.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dating_app_verification/core/network/api_exceptions.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/services/background_service.dart';

void main() {
  const sample = OnboardingData(
    industry: 'Software',
    role: 'Engineer',
    educationLevel: EducationLevel.postgraduate,
    locationQuery: 'Bengaluru, India',
    latitude: 12.9716,
    longitude: 77.5946,
  );

  group('buildBody', () {
    test('maps education level to its wire value and passes lat/lng', () {
      final body = BackgroundService.buildBody(sample);

      expect(body['industry'], 'Software');
      expect(body['role'], 'Engineer');
      expect(body['educationLevel'], 'postgraduate');
      expect(body['locationQuery'], 'Bengaluru, India');
      expect(body['latitude'], 12.9716);
      expect(body['longitude'], 77.5946);
    });

    test('serializes null education/location as null', () {
      final body = BackgroundService.buildBody(const OnboardingData());

      expect(body['educationLevel'], isNull);
      expect(body['latitude'], isNull);
      expect(body['longitude'], isNull);
    });

    test('maps preferNotToSay to the snake_case wire value', () {
      final body = BackgroundService.buildBody(
        const OnboardingData(educationLevel: EducationLevel.preferNotToSay),
      );
      expect(body['educationLevel'], 'prefer_not_to_say');
    });
  });

  group('submit', () {
    late Dio dio;
    late DioAdapter adapter;
    late BackgroundService service;

    setUp(() {
      dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.test',
          validateStatus: (_) => true,
        ),
      );
      adapter = DioAdapter(dio: dio);
      service = BackgroundService(dio: dio);
    });

    test('returns the persisted profile (with projected coords) on 200', () async {
      adapter.onPost(
        '/submitBackground',
        (server) => server.reply(200, {
          'profile': {
            'user_id': 'u1',
            'education_level': 'postgraduate',
            'latitude': 12.9716,
            'longitude': 77.5946,
          },
        }),
        data: BackgroundService.buildBody(sample),
      );

      final profile = await service.submit(sample);

      expect(profile['user_id'], 'u1');
      expect(profile['latitude'], 12.9716);
      expect(profile['longitude'], 77.5946);
    });

    test('throws ValidationException on 400 (bad coordinates)', () {
      adapter.onPost(
        '/submitBackground',
        (server) =>
            server.reply(400, {'error': 'latitude must be between -90 and 90.'}),
        data: BackgroundService.buildBody(sample),
      );

      expect(
        () => service.submit(sample),
        throwsA(isA<ValidationException>()),
      );
    });

    test('throws AuthException on 401', () {
      adapter.onPost(
        '/submitBackground',
        (server) => server.reply(401, {'error': 'Missing Authorization header.'}),
        data: BackgroundService.buildBody(sample),
      );

      expect(
        () => service.submit(sample),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
