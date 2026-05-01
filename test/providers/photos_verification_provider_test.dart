/// Tests for Module 5 providers — step navigation, data mutators,
/// and per-step canProceed validation.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/models/photos_verification_models.dart';
import 'package:dating_app_verification/providers/photos_verification_provider.dart';

void main() {
  group('CurrentPhotosVerificationStep', () {
    test('initializes at height', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(
        container.read(currentPhotosVerificationStepProvider),
        PhotosVerificationStep.height,
      );
    });

    test('next() advances through every step until complete', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(currentPhotosVerificationStepProvider.notifier);

      notifier.next();
      expect(container.read(currentPhotosVerificationStepProvider),
          PhotosVerificationStep.language);
      notifier.next();
      expect(container.read(currentPhotosVerificationStepProvider),
          PhotosVerificationStep.photos);
      notifier.next();
      expect(container.read(currentPhotosVerificationStepProvider),
          PhotosVerificationStep.complete);
    });

    test('next() does nothing once at complete', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(currentPhotosVerificationStepProvider.notifier);
      notifier.goTo(PhotosVerificationStep.complete);
      notifier.next();
      expect(container.read(currentPhotosVerificationStepProvider),
          PhotosVerificationStep.complete);
    });

    test('previous() walks back to height and stops', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(currentPhotosVerificationStepProvider.notifier);
      notifier.goTo(PhotosVerificationStep.complete);

      notifier.previous();
      expect(container.read(currentPhotosVerificationStepProvider),
          PhotosVerificationStep.photos);
      notifier.previous();
      notifier.previous();
      expect(container.read(currentPhotosVerificationStepProvider),
          PhotosVerificationStep.height);
      notifier.previous();
      expect(container.read(currentPhotosVerificationStepProvider),
          PhotosVerificationStep.height);
    });

    test('goTo() jumps directly to any step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentPhotosVerificationStepProvider.notifier)
          .goTo(PhotosVerificationStep.photos);
      expect(container.read(currentPhotosVerificationStepProvider),
          PhotosVerificationStep.photos);
    });
  });

  group('PhotosVerificationDataNotifier — height', () {
    test('setHeightFeet stores feet+inches and switches unit', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(photosVerificationDataProvider.notifier)
          .setHeightFeet(feet: 5, inches: 9);
      final data = container.read(photosVerificationDataProvider);
      expect(data.heightFeet, 5);
      expect(data.heightInches, 9);
      expect(data.heightUnit, HeightUnit.feet);
    });

    test('setHeightCm stores cm and switches unit', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(photosVerificationDataProvider.notifier)
          .setHeightCm(180);
      final data = container.read(photosVerificationDataProvider);
      expect(data.heightCm, 180);
      expect(data.heightUnit, HeightUnit.cm);
    });

    test('setHeightUnit toggles without clearing the other unit value', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photosVerificationDataProvider.notifier);
      notifier.setHeightFeet(feet: 5, inches: 7);
      notifier.setHeightUnit(HeightUnit.cm);
      final data = container.read(photosVerificationDataProvider);
      expect(data.heightUnit, HeightUnit.cm);
      expect(data.heightFeet, 5);
      expect(data.heightInches, 7);
    });
  });

  group('PhotosVerificationDataNotifier — languages', () {
    test('addLanguage appends; removeLanguage strips', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photosVerificationDataProvider.notifier);
      notifier.addLanguage('English');
      notifier.addLanguage('Hindi');
      expect(container.read(photosVerificationDataProvider).languages,
          ['English', 'Hindi']);
      notifier.removeLanguage('English');
      expect(container.read(photosVerificationDataProvider).languages,
          ['Hindi']);
    });

    test('addLanguage ignores duplicates', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photosVerificationDataProvider.notifier);
      notifier.addLanguage('English');
      notifier.addLanguage('English');
      expect(container.read(photosVerificationDataProvider).languages,
          ['English']);
    });

    test('addLanguage caps at kMaxLanguages (6)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photosVerificationDataProvider.notifier);
      const langs = [
        'English',
        'Hindi',
        'Spanish',
        'French',
        'German',
        'Mandarin',
        'Arabic',
      ];
      for (final l in langs) {
        notifier.addLanguage(l);
      }
      final selected =
          container.read(photosVerificationDataProvider).languages;
      expect(selected.length, kMaxLanguages);
      expect(selected, isNot(contains('Arabic'))); // 7th is rejected
    });
  });

  group('PhotosVerificationDataNotifier — photos', () {
    test('addPhoto appends; removePhotoAt removes by index', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photosVerificationDataProvider.notifier);
      notifier.addPhoto('/tmp/a.jpg');
      notifier.addPhoto('/tmp/b.jpg');
      expect(container.read(photosVerificationDataProvider).photos,
          ['/tmp/a.jpg', '/tmp/b.jpg']);
      notifier.removePhotoAt(0);
      expect(container.read(photosVerificationDataProvider).photos,
          ['/tmp/b.jpg']);
    });

    test('addPhoto caps at kMaxPhotos (5)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photosVerificationDataProvider.notifier);
      for (var i = 0; i < kMaxPhotos + 2; i++) {
        notifier.addPhoto('/tmp/$i.jpg');
      }
      expect(
        container.read(photosVerificationDataProvider).photos.length,
        kMaxPhotos,
      );
    });

    test('removePhotoAt is a no-op for out-of-range indices', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photosVerificationDataProvider.notifier);
      notifier.addPhoto('/tmp/a.jpg');
      notifier.removePhotoAt(5);
      notifier.removePhotoAt(-1);
      expect(container.read(photosVerificationDataProvider).photos,
          ['/tmp/a.jpg']);
    });
  });

  group('PhotosVerificationDataNotifier — selfie', () {
    test('setSelfie / clearSelfie toggle path and verified flag', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photosVerificationDataProvider.notifier);
      notifier.setSelfie('/tmp/selfie.jpg');
      notifier.markSelfieVerified();
      var data = container.read(photosVerificationDataProvider);
      expect(data.selfiePhotoPath, '/tmp/selfie.jpg');
      expect(data.selfieVerified, isTrue);

      notifier.clearSelfie();
      data = container.read(photosVerificationDataProvider);
      expect(data.selfiePhotoPath, isNull);
      expect(data.selfieVerified, isFalse);
    });
  });

  group('canProceedPhotosVerification', () {
    test('height step always allows proceed (skippable)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      // Default step is height.
      expect(container.read(canProceedPhotosVerificationProvider), isTrue);
    });

    test('language step always allows proceed (skippable)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentPhotosVerificationStepProvider.notifier)
          .goTo(PhotosVerificationStep.language);
      expect(container.read(canProceedPhotosVerificationProvider), isTrue);
    });

    test('photos step requires kMinPhotos before proceeding', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentPhotosVerificationStepProvider.notifier)
          .goTo(PhotosVerificationStep.photos);

      final dataNotifier =
          container.read(photosVerificationDataProvider.notifier);

      // 0 photos — blocked
      expect(container.read(canProceedPhotosVerificationProvider), isFalse);

      // 3 photos — still blocked (just under the threshold)
      for (var i = 0; i < kMinPhotos - 1; i++) {
        dataNotifier.addPhoto('/tmp/$i.jpg');
      }
      expect(container.read(canProceedPhotosVerificationProvider), isFalse);

      // 4 photos — allowed
      dataNotifier.addPhoto('/tmp/last.jpg');
      expect(container.read(canProceedPhotosVerificationProvider), isTrue);
    });

    test('complete step always proceeds', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentPhotosVerificationStepProvider.notifier)
          .goTo(PhotosVerificationStep.complete);
      expect(container.read(canProceedPhotosVerificationProvider), isTrue);
    });
  });
}
