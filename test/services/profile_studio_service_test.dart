/// Profile Studio service tests.
///
/// - MockProfileStudioService (issue #72): the local, no-backend generator the
///   USE_MOCK_PROFILE_STUDIO flag switches on — locks its canned-copy contract.
/// - HttpProfileStudioService (issue #39): status-code mapping, most importantly
///   that a 429 surfaces as a distinct ProfileStudioGenerateRateLimited result
///   (not a generic error).
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dating_app_verification/models/profile_studio_models.dart';
import 'package:dating_app_verification/services/profile_studio_service.dart';

void main() {
  group('MockProfileStudioService', () {
    final service = MockProfileStudioService(delay: Duration.zero);

    test('returns success echoing the inspiration + a full profile', () async {
      final result = await service.generate(
        const ProfileStudioGenerateRequest(
          inspirationText: 'weekends on trails, chai in hand',
          tone: ProfileTone.natural,
        ),
      );

      expect(result, isA<ProfileStudioGenerateSuccess>());
      final data = (result as ProfileStudioGenerateSuccess).data;
      expect(data.tone, ProfileTone.natural);
      expect(data.myStory, isNotEmpty);
      expect(data.interests, isNotEmpty);
      expect(data.narratives, isNotEmpty);
      expect(data.joinMeFor, isNotEmpty);
      // Inspiration is carried through to the refined state.
      expect(
        data.inspiration,
        isA<InspirationInputTyped>().having(
          (i) => i.text,
          'text',
          'weekends on trails, chai in hand',
        ),
      );
    });

    test('tone changes the generated story', () async {
      Future<String> storyFor(ProfileTone tone) async {
        final r = await service.generate(
          ProfileStudioGenerateRequest(inspirationText: 'x', tone: tone),
        );
        return (r as ProfileStudioGenerateSuccess).data.myStory;
      }

      expect(await storyFor(ProfileTone.natural),
          isNot(equals(await storyFor(ProfileTone.elegant))));
    });
  });

  group('HttpProfileStudioService', () {
    late Dio dio;
    late DioAdapter adapter;
    late HttpProfileStudioService service;

    const request = ProfileStudioGenerateRequest(
      inspirationText: 'weekends on trails, chai in hand',
      tone: ProfileTone.natural,
    );

    setUp(() {
      // Mirror the production client's validateStatus so non-2xx arrives as a
      // Response for the service to branch on.
      dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.test',
          validateStatus: (_) => true,
        ),
      );
      adapter = DioAdapter(dio: dio);
      service = HttpProfileStudioService(dio: dio);
    });

    test('429 maps to ProfileStudioGenerateRateLimited with the server message',
        () async {
      const msg =
          "You've reached today's limit of 5 generations. Come back tomorrow.";
      adapter.onPost(
        '/generateProfileStudio',
        (server) => server.reply(429, {'error': msg}),
        data: request.toJson(),
      );

      final result = await service.generate(request);

      expect(result, isA<ProfileStudioGenerateRateLimited>());
      expect((result as ProfileStudioGenerateRateLimited).message, msg);
    });

    test('429 without a body falls back to a friendly default message',
        () async {
      adapter.onPost(
        '/generateProfileStudio',
        (server) => server.reply(429, <String, dynamic>{}),
        data: request.toJson(),
      );

      final result = await service.generate(request);

      expect(result, isA<ProfileStudioGenerateRateLimited>());
      expect(
        (result as ProfileStudioGenerateRateLimited).message,
        contains('tomorrow'),
      );
    });

    test('400 maps to a client error (not rate-limited)', () async {
      adapter.onPost(
        '/generateProfileStudio',
        (server) => server.reply(400, {'error': 'Add at least 10 characters.'}),
        data: request.toJson(),
      );

      final result = await service.generate(request);

      expect(result, isA<ProfileStudioGenerateClientError>());
    });

    test('200 maps to success and parses the profile', () async {
      adapter.onPost(
        '/generateProfileStudio',
        (server) => server.reply(200, {
          'myStory': 'A grounded story.',
          'interests': ['Trails', 'Chai'],
          'narratives': [
            {'id': 'silent_observer', 'title': 'Silent Observer', 'content': 'x'},
          ],
          'joinMeFor': ['A long walk'],
        }),
        data: request.toJson(),
      );

      final result = await service.generate(request);

      expect(result, isA<ProfileStudioGenerateSuccess>());
      final data = (result as ProfileStudioGenerateSuccess).data;
      expect(data.myStory, 'A grounded story.');
      expect(data.interests, ['Trails', 'Chai']);
      expect(data.narratives.single.title, 'Silent Observer');
    });
  });
}
