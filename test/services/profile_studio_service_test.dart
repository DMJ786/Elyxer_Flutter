/// MockProfileStudioService (issue #72): the local, no-backend generator the
/// USE_MOCK_PROFILE_STUDIO flag switches on. Locks its contract so the local
/// Create-My-Profile flow stays deterministic.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:dating_app_verification/models/profile_studio_models.dart';
import 'package:dating_app_verification/services/profile_studio_service.dart';

void main() {
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
}
