/// Photos & Selfie Verification Providers (Module 5)
/// Step navigation, mutable data, and per-step proceed validation.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/photos_verification_models.dart';

part 'photos_verification_provider.g.dart';

/// Tracks the current step in the photos verification flow.
/// keepAlive: state persists if user navigates away and back.
@Riverpod(keepAlive: true)
class CurrentPhotosVerificationStep extends _$CurrentPhotosVerificationStep {
  @override
  PhotosVerificationStep build() => PhotosVerificationStep.height;

  void next() {
    if (!state.isLast) {
      state = PhotosVerificationStep.values[state.index + 1];
    }
  }

  void previous() {
    if (state.index > 0) {
      state = PhotosVerificationStep.values[state.index - 1];
    }
  }

  void goTo(PhotosVerificationStep step) {
    state = step;
  }
}

/// Holds mutable Module 5 data with typed mutators.
@Riverpod(keepAlive: true)
class PhotosVerificationDataNotifier
    extends _$PhotosVerificationDataNotifier {
  @override
  PhotosVerificationData build() => const PhotosVerificationData();

  // ----- Height -----

  void setHeightUnit(HeightUnit unit) {
    state = state.copyWith(heightUnit: unit);
  }

  void setHeightFeet({required int feet, required int inches}) {
    state = state.copyWith(
      heightFeet: feet,
      heightInches: inches,
      heightUnit: HeightUnit.feet,
    );
  }

  void setHeightCm(int cm) {
    state = state.copyWith(
      heightCm: cm,
      heightUnit: HeightUnit.cm,
    );
  }

  // ----- Languages -----

  void addLanguage(String language) {
    if (state.languages.contains(language)) return;
    if (state.languages.length >= kMaxLanguages) return;
    state = state.copyWith(languages: [...state.languages, language]);
  }

  void removeLanguage(String language) {
    state = state.copyWith(
      languages: state.languages.where((l) => l != language).toList(),
    );
  }

  // ----- Photos -----

  void addPhoto(String filePath) {
    if (state.photos.length >= kMaxPhotos) return;
    state = state.copyWith(photos: [...state.photos, filePath]);
  }

  void removePhotoAt(int index) {
    if (index < 0 || index >= state.photos.length) return;
    final updated = [...state.photos]..removeAt(index);
    state = state.copyWith(photos: updated);
  }

  // ----- Selfie -----

  void setSelfie(String filePath) {
    state = state.copyWith(selfiePhotoPath: filePath);
  }

  void clearSelfie() {
    state = state.copyWith(
      selfiePhotoPath: null,
      selfieVerified: false,
    );
  }

  void markSelfieVerified() {
    state = state.copyWith(selfieVerified: true);
  }
}

/// Computed: can the user proceed from the current step?
/// Mirrors canProceedOnboarding / canProceedOrientation.
@riverpod
bool canProceedPhotosVerification(Ref ref) {
  final currentStep = ref.watch(currentPhotosVerificationStepProvider);
  final data = ref.watch(photosVerificationDataProvider);

  return switch (currentStep) {
    // Height is skippable — always allow Next
    PhotosVerificationStep.height => true,
    // Language is skippable — always allow Next
    PhotosVerificationStep.language => true,
    // Photos require minimum to proceed; selfie remains optional
    PhotosVerificationStep.photos => data.photos.length >= kMinPhotos,
    PhotosVerificationStep.complete => true,
  };
}
