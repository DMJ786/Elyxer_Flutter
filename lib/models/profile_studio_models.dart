/// Profile Studio Models (Module 6)
/// Data models for Profile Studio flow: inspiration → refined profile.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_studio_models.freezed.dart';

/// Tone for the refined profile.
enum ProfileTone {
  natural,
  elegant;

  String get displayName {
    switch (this) {
      case ProfileTone.natural:
        return 'Natural';
      case ProfileTone.elegant:
        return 'Elegant';
    }
  }

  String get subtitle {
    switch (this) {
      case ProfileTone.natural:
        return 'Casual & warm — like you talking to a friend';
      case ProfileTone.elegant:
        return 'Refined & considered — a curated introduction';
    }
  }
}

/// Steps in Module 6 flow.
enum ProfileStudioStep {
  intro,
  inspiration,
  refined,
  complete;

  bool get isLast => this == ProfileStudioStep.complete;
}

/// A single narrative card on the refined profile.
@freezed
abstract class Narrative with _$Narrative {
  const factory Narrative({
    required String id,
    required String title,
    required String content,
  }) = _Narrative;
}

/// Predefined inspiration prompts shown in the input carousel.
@freezed
abstract class InspirationSuggestion with _$InspirationSuggestion {
  const factory InspirationSuggestion({
    required String id,
    required String text,
    @Default(<String>['HOBBIES', 'LIFESTYLE', 'INTENT']) List<String> tags,
  }) = _InspirationSuggestion;

  static const List<InspirationSuggestion> all = <InspirationSuggestion>[
    InspirationSuggestion(
      id: 's1',
      text:
          'Weekends on trail, chai in hand. I sketch, I cook, I get lost in flea markets. Looking for someone who finds magic in the ordinary.',
    ),
    InspirationSuggestion(
      id: 's2',
      text:
          'Vinyl records, late-night jazz, and a deep love for hole-in-the-wall restaurants.',
    ),
    InspirationSuggestion(
      id: 's3',
      text:
          'Early mornings, quiet bookshops, and someone who thinks Sunday should last all week.',
    ),
    InspirationSuggestion(
      id: 's4',
      text:
          'I hike, I bake, I have strong opinions about coffee. Looking for a partner in curiosity.',
    ),
    InspirationSuggestion(
      id: 's5',
      text:
          'Museum wanderer, farmer-market regular, terrible at karaoke but always game.',
    ),
  ];
}

/// Word-limit spec per Figma. Centralised so we can align with designer.
class WordLimits {
  WordLimits._();

  /// L2-L4 free-form inspiration input.
  static const int inspirationInput = 40;

  /// L2-L4 when a preset suggestion is selected (locked to suggestion length).
  static const int inspirationUsed = 25;

  /// L7 MyStory bottom-sheet.
  static const int myStory = 25;

  /// L8 Interests: max 6 interests, each up to 2 words.
  static const int interestsMax = 6;
  static const int interestWordLimit = 2;

  /// L9/L10 Narrative title + content.
  static const int narrativeTitle = 4;
  static const int narrativeContent = 25;

  /// L11 JoinMeFor: max 3 experiences, each up to 5 words.
  static const int joinMeForMax = 3;
  static const int joinMeForWordLimit = 5;
}

/// State for the inspiration input field (L2-L4).
@freezed
sealed class InspirationInputState with _$InspirationInputState {
  const factory InspirationInputState.empty() = InspirationInputEmpty;

  const factory InspirationInputState.typed({
    required String text,
    required int wordLimit,
  }) = InspirationInputTyped;

  const factory InspirationInputState.used({
    required String suggestionId,
    required String text,
    required int wordLimit,
  }) = InspirationInputUsed;
}

/// Aggregate Profile Studio state.
@freezed
abstract class ProfileStudioData with _$ProfileStudioData {
  const factory ProfileStudioData({
    @Default(InspirationInputState.empty()) InspirationInputState inspiration,
    @Default('') String myStory,
    @Default(<String>[]) List<String> interests,
    @Default(<Narrative>[]) List<Narrative> narratives,
    @Default(<String>[]) List<String> joinMeFor,
    @Default(ProfileTone.natural) ProfileTone tone,
  }) = _ProfileStudioData;
}
