/// Profile Studio Provider (Module 6)
/// Riverpod state for inspiration input, refined profile edits, and tone.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/profile_studio_models.dart';

part 'profile_studio_provider.g.dart';

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
