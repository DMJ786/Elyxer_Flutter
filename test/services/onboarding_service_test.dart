/// OnboardingService tests.
///
/// buildBody unit-tests the enum/date wire mapping; the http_mock_adapter
/// tests exercise the real Dio round trip — success parsing and error mapping.
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dating_app_verification/core/network/api_exceptions.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/services/onboarding_service.dart';

void main() {
  // A representative fully-populated selection.
  final sample = OnboardingData(
    birthdate: DateTime(1998, 5, 20),
    gender: Gender.nonBinary,
    genderIdentityOptionIds: const ['a'],
    pronouns: const ['They/Them'],
    showGenderOnProfile: true,
    sexualOrientation: SexualOrientation.queer,
    datingPreferences: const [
      DatingPreference.men,
      DatingPreference.openToAll,
    ],
    datingGoalIds: const ['long_term'],
  );

  group('buildBody', () {
    test('maps enums and date to their BFF wire values', () {
      final body = OnboardingService.buildBody(sample);

      expect(body['birthdate'], '1998-05-20');
      expect(body['gender'], 'non_binary');
      expect(body['sexualOrientation'], 'queer');
      expect(body['datingPreferences'], ['men', 'open_to_all']);
      expect(body['showGenderOnProfile'], true);
      expect(body['pronouns'], ['They/Them']);
    });

    test('serializes null birthdate/gender as null', () {
      final body = OnboardingService.buildBody(const OnboardingData());

      expect(body['birthdate'], isNull);
      expect(body['gender'], isNull);
      expect(body['sexualOrientation'], isNull);
      expect(body['datingPreferences'], isEmpty);
    });
  });

  group('submit', () {
    late Dio dio;
    late DioAdapter adapter;
    late OnboardingService service;

    setUp(() {
      // Mirror the production client's validateStatus so non-2xx arrives as a
      // Response (not a thrown DioException) for the service to map.
      dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.test',
          validateStatus: (_) => true,
        ),
      );
      adapter = DioAdapter(dio: dio);
      service = OnboardingService(dio: dio);
    });

    test('returns the persisted profile on 200', () async {
      adapter.onPost(
        '/submitOnboarding',
        (server) => server.reply(200, {
          'profile': {'user_id': 'u1', 'gender': 'non_binary'},
        }),
        // Matching the body also asserts the enum/date wire mapping is sent.
        data: OnboardingService.buildBody(sample),
      );

      final profile = await service.submit(sample);

      expect(profile['user_id'], 'u1');
      expect(profile['gender'], 'non_binary');
    });

    test('throws ValidationException on 400', () {
      adapter.onPost(
        '/submitOnboarding',
        (server) => server.reply(400, {'error': 'Invalid gender: x'}),
        data: OnboardingService.buildBody(sample),
      );

      expect(
        () => service.submit(sample),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.message,
            'message',
            'Invalid gender: x',
          ),
        ),
      );
    });

    test('throws AuthException on 401', () {
      adapter.onPost(
        '/submitOnboarding',
        (server) => server.reply(401, {'error': 'Missing Authorization header.'}),
        data: OnboardingService.buildBody(sample),
      );

      expect(
        () => service.submit(sample),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
