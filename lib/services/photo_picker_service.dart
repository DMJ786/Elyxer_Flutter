/// Photo picker service — abstraction over image_picker + permission_handler.
///
/// The real impl wraps both packages so the UI doesn't touch platform
/// channels directly. Tests use [FakePhotoPickerService] via
/// `photoPickerServiceProvider.overrideWithValue(...)`.
library;

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result of a photo pick attempt — sealed for exhaustive pattern matching.
sealed class PhotoPickResult {
  const PhotoPickResult();
}

/// User picked a photo successfully.
class PhotoPickSuccess extends PhotoPickResult {
  final XFile file;
  const PhotoPickSuccess(this.file);
}

/// User dismissed the picker without choosing.
class PhotoPickCancelled extends PhotoPickResult {
  const PhotoPickCancelled();
}

/// Required permission was denied. When [permanently] is true, the user
/// has selected "Don't ask again" — UI should offer to open Settings.
class PhotoPickPermissionDenied extends PhotoPickResult {
  final bool permanently;
  const PhotoPickPermissionDenied({required this.permanently});
}

/// Picker threw — usually a platform/IO error.
class PhotoPickError extends PhotoPickResult {
  final Object error;
  const PhotoPickError(this.error);
}

/// Camera preference (the camera the OS opens by default — user can still
/// switch in the native UI on most devices).
enum PhotoCameraDevice { front, rear }

abstract class PhotoPickerService {
  Future<PhotoPickResult> pickFromCamera({
    PhotoCameraDevice preferred = PhotoCameraDevice.rear,
  });

  Future<PhotoPickResult> pickFromGallery();

  /// Forwards to permission_handler's openAppSettings(). UI calls this
  /// when [PhotoPickPermissionDenied.permanently] is true.
  Future<void> openSettings();
}

/// Production implementation. Default ctor is parameterless so it can be
/// constructed from the Riverpod provider; pass in a custom [picker] for
/// test overrides that still want the real permission flow.
class ImagePickerPhotoPickerService implements PhotoPickerService {
  ImagePickerPhotoPickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  // Reasonable defaults for dating-app profile photos. Larger source
  // images will be downscaled by image_picker before returning.
  static const int _kImageQuality = 85;
  static const double _kMaxDim = 1920;

  @override
  Future<PhotoPickResult> pickFromCamera({
    PhotoCameraDevice preferred = PhotoCameraDevice.rear,
  }) async {
    final denial = await _ensurePermission(Permission.camera);
    if (denial != null) return denial;

    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: preferred == PhotoCameraDevice.front
            ? CameraDevice.front
            : CameraDevice.rear,
        imageQuality: _kImageQuality,
        maxWidth: _kMaxDim,
        maxHeight: _kMaxDim,
      );
      return file == null
          ? const PhotoPickCancelled()
          : PhotoPickSuccess(file);
    } catch (e) {
      return PhotoPickError(e);
    }
  }

  @override
  Future<PhotoPickResult> pickFromGallery() async {
    // Photo library permission is named differently across platforms but
    // permission_handler exposes the right one as Permission.photos on
    // both iOS and Android 13+. Older Android uses storage scope
    // (handled by image_picker internally for legacy SDKs).
    final denial = await _ensurePermission(Permission.photos);
    if (denial != null) return denial;

    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: _kImageQuality,
        maxWidth: _kMaxDim,
        maxHeight: _kMaxDim,
      );
      return file == null
          ? const PhotoPickCancelled()
          : PhotoPickSuccess(file);
    } catch (e) {
      return PhotoPickError(e);
    }
  }

  @override
  Future<void> openSettings() => openAppSettings();

  /// Returns null on grant; a typed denial result otherwise.
  Future<PhotoPickResult?> _ensurePermission(Permission p) async {
    final status = await p.status;
    if (status.isGranted || status.isLimited) return null;

    final result = await p.request();
    if (result.isGranted || result.isLimited) return null;

    return PhotoPickPermissionDenied(
      permanently: result.isPermanentlyDenied,
    );
  }
}

/// Test fake. Configure the canned results via fields, then assert on
/// the call counters after exercising the UI.
class FakePhotoPickerService implements PhotoPickerService {
  PhotoPickResult cameraResult = const PhotoPickCancelled();
  PhotoPickResult galleryResult = const PhotoPickCancelled();

  int cameraCalls = 0;
  int galleryCalls = 0;
  int openSettingsCalls = 0;
  PhotoCameraDevice? lastCameraPreference;

  @override
  Future<PhotoPickResult> pickFromCamera({
    PhotoCameraDevice preferred = PhotoCameraDevice.rear,
  }) async {
    cameraCalls++;
    lastCameraPreference = preferred;
    return cameraResult;
  }

  @override
  Future<PhotoPickResult> pickFromGallery() async {
    galleryCalls++;
    return galleryResult;
  }

  @override
  Future<void> openSettings() async {
    openSettingsCalls++;
  }
}
