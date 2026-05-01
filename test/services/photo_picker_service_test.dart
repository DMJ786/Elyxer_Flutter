/// Unit tests for the PhotoPickerService abstraction.
/// The real impl wraps platform channels and is exercised via manual
/// QA / integration tests; these tests cover the sealed result types
/// and the FakePhotoPickerService used by widget tests.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dating_app_verification/services/photo_picker_service.dart';

void main() {
  group('FakePhotoPickerService', () {
    test('counts camera and gallery calls separately', () async {
      final fake = FakePhotoPickerService();
      await fake.pickFromCamera();
      await fake.pickFromGallery();
      await fake.pickFromGallery();
      expect(fake.cameraCalls, 1);
      expect(fake.galleryCalls, 2);
    });

    test('returns the configured camera result', () async {
      final fake = FakePhotoPickerService();
      fake.cameraResult = PhotoPickSuccess(XFile('/tmp/a.jpg'));
      final result = await fake.pickFromCamera();
      expect(result, isA<PhotoPickSuccess>());
      expect((result as PhotoPickSuccess).file.path, '/tmp/a.jpg');
    });

    test('returns the configured gallery result', () async {
      final fake = FakePhotoPickerService();
      fake.galleryResult =
          const PhotoPickPermissionDenied(permanently: true);
      final result = await fake.pickFromGallery();
      expect(result, isA<PhotoPickPermissionDenied>());
      expect((result as PhotoPickPermissionDenied).permanently, isTrue);
    });

    test('records the camera preference', () async {
      final fake = FakePhotoPickerService();
      await fake.pickFromCamera(preferred: PhotoCameraDevice.front);
      expect(fake.lastCameraPreference, PhotoCameraDevice.front);
    });

    test('counts openSettings invocations', () async {
      final fake = FakePhotoPickerService();
      await fake.openSettings();
      await fake.openSettings();
      expect(fake.openSettingsCalls, 2);
    });
  });

  group('PhotoPickResult sealed pattern matching', () {
    String describe(PhotoPickResult r) => switch (r) {
          PhotoPickSuccess(:final file) => 'success:${file.path}',
          PhotoPickCancelled() => 'cancelled',
          PhotoPickPermissionDenied(:final permanently) =>
            permanently ? 'denied-permanent' : 'denied',
          PhotoPickError(:final error) => 'error:$error',
        };

    test('exhaustive switch covers every variant', () {
      expect(describe(PhotoPickSuccess(XFile('/a.jpg'))), 'success:/a.jpg');
      expect(describe(const PhotoPickCancelled()), 'cancelled');
      expect(
        describe(const PhotoPickPermissionDenied(permanently: false)),
        'denied',
      );
      expect(
        describe(const PhotoPickPermissionDenied(permanently: true)),
        'denied-permanent',
      );
      expect(describe(const PhotoPickError('boom')), 'error:boom');
    });
  });
}
