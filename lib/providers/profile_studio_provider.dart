/// Profile Studio Provider (Module 6)
/// Riverpod state for inspiration input, refined profile edits, and tone.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/profile_studio_models.dart';
import '../services/profile_studio_service.dart';

part 'profile_studio_provider.g.dart';

/// The active service impl. Defaults to the mock so dev + design review
/// work with no backend; swap to [HttpProfileStudioService] once the
/// BFF endpoint (`POST /profile-studio/generate`) is deployed.
@Riverpod(keepAlive: true)
ProfileStudioService profileStudioService(Ref ref) =>
    MockProfileStudioService();

/// Async state of the LLM generation call. `AsyncValue.data` after a
/// successful call — screens read this to know when to swap from the
/// loading state to the Refined screen.
@Riverpod(keepAlive: true)
class ProfileStudioGeneration extends _$ProfileStudioGeneration {
  @override
  AsyncValue<ProfileStudioData?> build() =>
      const AsyncValue<ProfileStudioData?>.data(null);

  /// Kick off a generation. Pulls the current inspiration text + tone
  /// from [profileStudioDataProvider] and sends it to the service.
  /// On success: writes the response into [profileStudioDataProvider]
  /// AND surfaces AsyncValue.data(newData) so the container can advance.
  /// On error: exposes AsyncValue.error for the UI to show a retry hint.
  Future<void> run() async {
    final ProfileStudioData current = ref.read(profileStudioDataProvider);
    final String inspirationText = switch (current.inspiration) {
      InspirationInputEmpty() => '',
      InspirationInputTyped(:final String text) => text,
      InspirationInputUsed(:final String text) => text,
    };

    if (inspirationText.trim().isEmpty) {
      state = AsyncValue<ProfileStudioData?>.error(
        StateError('Add a few words of inspiration first.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue<ProfileStudioData?>.loading();

    final ProfileStudioService service = ref.read(profileStudioServiceProvider);
    final ProfileStudioGenerateResult result = await service.generate(
      ProfileStudioGenerateRequest(
        inspirationText: inspirationText,
        tone: current.tone,
      ),
    );

    switch (result) {
      case ProfileStudioGenerateSuccess(:final ProfileStudioData data):
        ref.read(profileStudioDataProvider.notifier).replace(data);
        state = AsyncValue<ProfileStudioData?>.data(data);
      case ProfileStudioGenerateClientError(:final String message):
        state = AsyncValue<ProfileStudioData?>.error(
          StateError(message),
          StackTrace.current,
        );
      case ProfileStudioGenerateServerError(:final Object error):
        state = AsyncValue<ProfileStudioData?>.error(
          error,
          StackTrace.current,
        );
    }
  }

  /// Reset back to idle — used after the container navigates away.
  void reset() =>
      state = const AsyncValue<ProfileStudioData?>.data(null);
}

@Riverpod(keepAlive: true)
class CurrentProfileStudioStep extends _$CurrentProfileStudioStep {
  @override
  ProfileStudioStep build() => ProfileStudioStep.intro;

  void next() {
    if (!state.isLast) {
      state = ProfileStudioStep.values[state.index + 1];
    }
  }

  void previous() {
    if (state.index > 0) {
      state = ProfileStudioStep.values[state.index - 1];
    }
  }

  void goTo(ProfileStudioStep step) => state = step;
}

@Riverpod(keepAlive: true)
class ProfileStudioDataNotifier extends _$ProfileStudioDataNotifier {
  @override
  ProfileStudioData build() => const ProfileStudioData(
        narratives: <Narrative>[
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
      );

  void clearInspiration() {
    state = state.copyWith(inspiration: const InspirationInputState.empty());
  }

  void typeInspiration(String text) {
    state = state.copyWith(
      inspiration: InspirationInputState.typed(
        text: text,
        wordLimit: WordLimits.inspirationInput,
      ),
    );
  }

  void useInspiration(InspirationSuggestion suggestion) {
    state = state.copyWith(
      inspiration: InspirationInputState.used(
        suggestionId: suggestion.id,
        text: suggestion.text,
        wordLimit: WordLimits.inspirationUsed,
      ),
    );
  }

  void setTone(ProfileTone tone) {
    state = state.copyWith(tone: tone);
  }

  void updateMyStory(String story) {
    state = state.copyWith(myStory: story);
  }

  void setInterests(List<String> interests) {
    state = state.copyWith(
      interests: interests.take(WordLimits.interestsMax).toList(),
    );
  }

  void updateNarrative(String id, {String? title, String? content}) {
    state = state.copyWith(
      narratives: <Narrative>[
        for (final n in state.narratives)
          if (n.id == id)
            n.copyWith(
              title: title ?? n.title,
              content: content ?? n.content,
            )
          else
            n,
      ],
    );
  }

  void setJoinMeFor(List<String> experiences) {
    state = state.copyWith(
      joinMeFor: experiences.take(WordLimits.joinMeForMax).toList(),
    );
  }

  /// Overwrite the entire aggregate — used when the LLM returns a
  /// generated profile. Preserves the current inspiration so the user
  /// can see what they typed on the way to the Refined screen.
  void replace(ProfileStudioData next) {
    state = next.copyWith(inspiration: state.inspiration);
  }
}

/// Count words in a string (matches Figma word-count semantics).
int countWords(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return 0;
  return trimmed.split(RegExp(r'\s+')).length;
}

/// True when the inspiration input has enough content to enable Create My Profile.
@riverpod
bool canCreateProfile(Ref ref) {
  final ProfileStudioData data = ref.watch(profileStudioDataProvider);
  final InspirationInputState inspiration = data.inspiration;
  if (inspiration is InspirationInputUsed) return true;
  if (inspiration is InspirationInputTyped) return countWords(inspiration.text) > 0;
  return false;
}
