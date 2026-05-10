/// Tests for Module 5 providers — step navigation, data mutators,
/// and per-step canProceed validation.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/models/photo_verification_models.dart';
import 'package:dating_app_verification/providers/photo_verification_provider.dart';

void main() {
  group('CurrentPhotoVerificationStep', () {
    test('initializes at height', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(
        container.read(currentPhotoVerificationStepProvider),
        PhotoVerificationStep.height,
      );
    });

    test('next() advances through every step until complete', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(currentPhotoVerificationStepProvider.notifier);

      notifier.next();
      expect(container.read(currentPhotoVerificationStepProvider),
          PhotoVerificationStep.language);
      notifier.next();
      expect(container.read(currentPhotoVerificationStepProvider),
          PhotoVerificationStep.photos);
      notifier.next();
      expect(container.read(currentPhotoVerificationStepProvider),
          PhotoVerificationStep.complete);
    });

    test('next() does nothing once at complete', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(currentPhotoVerificationStepProvider.notifier);
      notifier.goTo(PhotoVerificationStep.complete);
      notifier.next();
      expect(container.read(currentPhotoVerificationStepProvider),
          PhotoVerificationStep.complete);
    });

    test('previous() walks back to height and stops', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(currentPhotoVerificationStepProvider.notifier);
      notifier.goTo(PhotoVerificationStep.complete);

      notifier.previous();
      expect(container.read(currentPhotoVerificationStepProvider),
          PhotoVerificationStep.photos);
      notifier.previous();
      notifier.previous();
      expect(container.read(currentPhotoVerificationStepProvider),
          PhotoVerificationStep.height);
      notifier.previous();
      expect(container.read(currentPhotoVerificationStepProvider),
          PhotoVerificationStep.height);
    });

    test('goTo() jumps directly to any step', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentPhotoVerificationStepProvider.notifier)
          .goTo(PhotoVerificationStep.photos);
      expect(container.read(currentPhotoVerificationStepProvider),
          PhotoVerificationStep.photos);
    });
  });

  group('PhotoVerificationDataNotifier — height', () {
    test('setHeightFeet stores feet+inches and switches unit', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(photoVerificationDataProvider.notifier)
          .setHeightFeet(feet: 5, inches: 9);
      final data = container.read(photoVerificationDataProvider);
      expect(data.heightFeet, 5);
      expect(data.heightInches, 9);
      expect(data.heightUnit, HeightUnit.feet);
    });

    test('setHeightCm stores cm and switches unit', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(photoVerificationDataProvider.notifier)
          .setHeightCm(180);
      final data = container.read(photoVerificationDataProvider);
      expect(data.heightCm, 180);
      expect(data.heightUnit, HeightUnit.cm);
    });

    test('setHeightUnit toggles without clearing the other unit value', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photoVerificationDataProvider.notifier);
      notifier.setHeightFeet(feet: 5, inches: 7);
      notifier.setHeightUnit(HeightUnit.cm);
      final data = container.read(photoVerificationDataProvider);
      expect(data.heightUnit, HeightUnit.cm);
      expect(data.heightFeet, 5);
      expect(data.heightInches, 7);
    });
  });

  group('PhotoVerificationDataNotifier — languages', () {
    test('addLanguage appends; removeLanguage strips', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photoVerificationDataProvider.notifier);
      notifier.addLanguage('English');
      notifier.addLanguage('Hindi');
      expect(container.read(photoVerificationDataProvider).languages,
          ['English', 'Hindi']);
      notifier.removeLanguage('English');
      expect(container.read(photoVerificationDataProvider).languages,
          ['Hindi']);
    });

    test('addLanguage ignores duplicates', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photoVerificationDataProvider.notifier);
      notifier.addLanguage('English');
      notifier.addLanguage('English');
      expect(container.read(photoVerificationDataProvider).languages,
          ['English']);
    });

    test('addLanguage caps at kMaxLanguages (6)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photoVerificationDataProvider.notifier);
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
          container.read(photoVerificationDataProvider).languages;
      expect(selected.length, kMaxLanguages);
      expect(selected, isNot(contains('Arabic'))); // 7th is rejected
    });
  });

  group('PhotoVerificationDataNotifier — photos', () {
    test('addPhoto appends; removePhotoAt removes by index', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photoVerificationDataProvider.notifier);
      notifier.addPhoto('/tmp/a.jpg');
      notifier.addPhoto('/tmp/b.jpg');
      expect(container.read(photoVerificationDataProvider).photos,
          ['/tmp/a.jpg', '/tmp/b.jpg']);
      notifier.removePhotoAt(0);
      expect(container.read(photoVerificationDataProvider).photos,
          ['/tmp/b.jpg']);
    });

    test('addPhoto caps at kMaxPhotos (5)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photoVerificationDataProvider.notifier);
      for (var i = 0; i < kMaxPhotos + 2; i++) {
        notifier.addPhoto('/tmp/$i.jpg');
      }
      expect(
        container.read(photoVerificationDataProvider).photos.length,
        kMaxPhotos,
      );
    });

    test('removePhotoAt is a no-op for out-of-range indices', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photoVerificationDataProvider.notifier);
      notifier.addPhoto('/tmp/a.jpg');
      notifier.removePhotoAt(5);
      notifier.removePhotoAt(-1);
      expect(container.read(photoVerificationDataProvider).photos,
          ['/tmp/a.jpg']);
    });
  });

  group('PhotoVerificationDataNotifier — selfie', () {
    test('setSelfie / clearSelfie toggle path and verified flag', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier =
          container.read(photoVerificationDataProvider.notifier);
      notifier.setSelfie('/tmp/selfie.jpg');
      notifier.markSelfieVerified();
      var data = container.read(photoVerificationDataProvider);
      expect(data.selfiePhotoPath, '/tmp/selfie.jpg');
      expect(data.selfieVerified, isTrue);

      notifier.clearSelfie();
      data = container.read(photoVerificationDataProvider);
      expect(data.selfiePhotoPath, isNull);
      expect(data.selfieVerified, isFalse);
    });
  });

  group('canProceedPhotoVerification', () {
    test('height step always allows proceed (skippable)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      // Default step is height.
      expect(container.read(canProceedPhotoVerificationProvider), isTrue);
    });

    test('language step always allows proceed (skippable)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentPhotoVerificationStepProvider.notifier)
          .goTo(PhotoVerificationStep.language);
      expect(container.read(canProceedPhotoVerificationProvider), isTrue);
    });

    test('photos step requires kMinPhotos before proceeding', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentPhotoVerificationStepProvider.notifier)
          .goTo(PhotoVerificationStep.photos);

      final dataNotifier =
          container.read(photoVerificationDataProvider.notifier);

      // 0 photos — blocked
      expect(container.read(canProceedPhotoVerificationProvider), isFalse);

      // 3 photos — still blocked (just under the threshold)
      for (var i = 0; i < kMinPhotos - 1; i++) {
        dataNotifier.addPhoto('/tmp/$i.jpg');
      }
      expect(container.read(canProceedPhotoVerificationProvider), isFalse);

      // 4 photos — allowed
      dataNotifier.addPhoto('/tmp/last.jpg');
      expect(container.read(canProceedPhotoVerificationProvider), isTrue);
    });

    test('complete step always proceeds', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentPhotoVerificationStepProvider.notifier)
          .goTo(PhotoVerificationStep.complete);
      expect(container.read(canProceedPhotoVerificationProvider), isTrue);
    });
  });
}
