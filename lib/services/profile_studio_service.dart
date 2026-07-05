/// Profile Studio LLM service — sends the user's inspiration text +
/// tone to the backend and receives a full structured profile.
///
/// The real endpoint (`POST /profile-studio/generate` on the Cloud
/// Functions BFF) is not shipped yet. This file wires up the client
/// contract so the UI can be built and demoed end-to-end today; when
/// the endpoint lands, swap [profileStudioServiceProvider]'s default
/// from [MockProfileStudioService] to [HttpProfileStudioService].
///
/// The prompt / model choice live server-side (Anthropic Claude via the
/// BFF) so the API key is never bundled with the app — see the
/// architectural memo in the Module 6 PR description.
library;

import 'dart:async';

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/profile_studio_models.dart';

/// Request body for a generation call.
class ProfileStudioGenerateRequest {
  const ProfileStudioGenerateRequest({
    required this.inspirationText,
    required this.tone,
  });

  final String inspirationText;
  final ProfileTone tone;

  Map<String, Object?> toJson() => <String, Object?>{
        'inspirationText': inspirationText,
        'tone': tone.name,
      };
}

/// Sealed result — exhaustive matching at the call site keeps the UI
/// honest about the error paths (no silent try/catches).
sealed class ProfileStudioGenerateResult {
  const ProfileStudioGenerateResult();
}

class ProfileStudioGenerateSuccess extends ProfileStudioGenerateResult {
  const ProfileStudioGenerateSuccess(this.data);
  final ProfileStudioData data;
}

/// Non-retryable client-side problem (bad input, unauthorized, etc.).
class ProfileStudioGenerateClientError extends ProfileStudioGenerateResult {
  const ProfileStudioGenerateClientError(this.message);
  final String message;
}

/// Retryable server/network problem. Caller can offer a "Try again" CTA.
class ProfileStudioGenerateServerError extends ProfileStudioGenerateResult {
  const ProfileStudioGenerateServerError(this.error);
  final Object error;
}

abstract class ProfileStudioService {
  Future<ProfileStudioGenerateResult> generate(
    ProfileStudioGenerateRequest request,
  );
}

/// Dev-time mock. Simulates a 1.2s server round-trip and returns
/// deterministic canned copy so the loading UX and Refined screen can
/// be exercised without a backend.
class MockProfileStudioService implements ProfileStudioService {
  MockProfileStudioService({
    this.delay = const Duration(milliseconds: 1200),
  });

  final Duration delay;

  @override
  Future<ProfileStudioGenerateResult> generate(
    ProfileStudioGenerateRequest request,
  ) async {
    await Future<void>.delayed(delay);
    return ProfileStudioGenerateSuccess(_mockDataFor(request));
  }

  ProfileStudioData _mockDataFor(ProfileStudioGenerateRequest request) {
    final bool elegant = request.tone == ProfileTone.elegant;
    return ProfileStudioData(
      inspiration: InspirationInputState.typed(
        text: request.inspirationText,
        wordLimit: WordLimits.inspirationInput,
      ),
      tone: request.tone,
      myStory: elegant
          ? 'A quiet grounding runs through my days — the discipline of good work, and the grace to make room for what lasts: honest company, patient conversation, and small, well-kept rituals.'
          : 'I bring the same focus to my personal life as I do my work — balanced, curious, and always leaving room for the small moments that matter most.',
      interests: const <String>[
        'Deep curiosity',
        'Steady growth',
        'Nature',
        'Deep Conversation',
        'Agriculture',
      ],
      narratives: const <Narrative>[
        Narrative(
          id: 'silent_observer',
          title: 'The Silent Observer',
          content:
              'I find that staying grounded helps me tackle big challenges without losing sight of the small, joyful moments in between.',
        ),
        Narrative(
          id: 'eyes_for_detail',
          title: 'Eyes for detail',
          content:
              'Whether at my desk or out in the world, I try to lead with empathy and a really open mind.',
        ),
      ],
      joinMeFor: const <String>[
        'A long evening walk',
        'Grabbing a quiet coffee',
        'Checking out local art',
      ],
    );
  }
}

/// Production impl — POSTs to the BFF and parses the structured
/// response. Kept off the default provider until the server endpoint is
/// live so we don't ship a broken code path.
class HttpProfileStudioService implements ProfileStudioService {
  HttpProfileStudioService({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  static const String _path = '/profile-studio/generate';

  @override
  Future<ProfileStudioGenerateResult> generate(
    ProfileStudioGenerateRequest request,
  ) async {
    try {
      final Response<Map<String, Object?>> response =
          await _dio.post<Map<String, Object?>>(
        _path,
        data: request.toJson(),
      );

      final int status = response.statusCode ?? 500;
      if (status >= 400 && status < 500) {
        final String msg =
            (response.data?['message'] as String?) ?? 'Request rejected.';
        return ProfileStudioGenerateClientError(msg);
      }
      if (status >= 500 || response.data == null) {
        return ProfileStudioGenerateServerError(
          'Unexpected status $status',
        );
      }

      return ProfileStudioGenerateSuccess(
        _parseResponse(response.data!, request.tone),
      );
    } catch (e) {
      return ProfileStudioGenerateServerError(e);
    }
  }

  ProfileStudioData _parseResponse(
    Map<String, Object?> json,
    ProfileTone tone,
  ) {
    final List<Object?> narrativesJson =
        (json['narratives'] as List<Object?>?) ?? const <Object?>[];
    return ProfileStudioData(
      tone: tone,
      myStory: (json['myStory'] as String?) ?? '',
      interests: ((json['interests'] as List<Object?>?) ?? const <Object?>[])
          .whereType<String>()
          .toList(),
      narratives: <Narrative>[
        for (final Object? n in narrativesJson)
          if (n is Map<String, Object?>)
            Narrative(
              id: (n['id'] as String?) ?? 'n_${narrativesJson.indexOf(n)}',
              title: (n['title'] as String?) ?? '',
              content: (n['content'] as String?) ?? '',
            ),
      ],
      joinMeFor: ((json['joinMeFor'] as List<Object?>?) ?? const <Object?>[])
          .whereType<String>()
          .toList(),
    );
  }
}
