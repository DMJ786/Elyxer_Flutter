/// Selfie validator service — on-device ML Kit face detection.
///
/// Runs entirely on-device (no cloud, no biometric data leaves the
/// phone). Used after image_picker returns a selfie XFile to decide
/// whether the selfie flow shows the confirmation or rejection state.
///
/// What this DOES check:
///   - Exactly one face is in the frame
///   - Face takes up at least 15% of the image area
///   - Both eyes read open with probability ≥ 0.4
///
/// What this does NOT check (out of scope for MVP):
///   - Liveness (anti-photo-spoofing) — needs cloud SDK
///   - Face match against profile photos — needs server-side embedding
library;

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

/// Reasons a selfie can be rejected. Each maps to user-facing copy on
/// the SelfieRejectionView.
enum SelfieRejectionReason {
  noFace,
  multipleFaces,
  faceTooSmall,
  eyesClosed;

  String get displayMessage {
    switch (this) {
      case SelfieRejectionReason.noFace:
        return "We couldn't see your face clearly. Try again in good lighting.";
      case SelfieRejectionReason.multipleFaces:
        return 'Please be alone in the photo.';
      case SelfieRejectionReason.faceTooSmall:
        return 'Move closer so your face fills more of the frame.';
      case SelfieRejectionReason.eyesClosed:
        return 'Try again with both eyes open.';
    }
  }
}

/// Sealed result type — exhaustive pattern matching at call sites.
sealed class SelfieValidationResult {
  const SelfieValidationResult();
}

class SelfieValid extends SelfieValidationResult {
  const SelfieValid();
}

class SelfieInvalid extends SelfieValidationResult {
  final SelfieRejectionReason reason;
  const SelfieInvalid(this.reason);
}

class SelfieValidationError extends SelfieValidationResult {
  final Object error;
  const SelfieValidationError(this.error);
}

abstract class SelfieValidatorService {
  Future<SelfieValidationResult> validate(XFile file);

  /// Releases the underlying detector. Call from a Riverpod onDispose.
  void dispose();
}

/// Production implementation using google_mlkit_face_detection.
///
/// The FaceDetector instance is created lazily on first validate() call
/// and kept alive for the app lifetime — creating it is expensive
/// (model load + native init) so we don't recreate per-selfie.
class MlKitSelfieValidatorService implements SelfieValidatorService {
  /// Face bounding box must occupy at least this fraction of the image.
  /// Lower than this → user is far from the camera or framed poorly.
  static const double _kMinFaceAreaRatio = 0.15;

  /// Both eyes must read open with at least this probability. Lenient
  /// threshold so squinting / low-light doesn't false-reject.
  static const double _kMinEyeOpenProbability = 0.4;

  late final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(
      // Need classification for eye-open probabilities.
      enableClassification: true,
      enableLandmarks: false,
      enableContours: false,
      // Accurate is slower than fast but the latency is acceptable for
      // a one-shot post-capture check (~200-500ms).
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  @override
  Future<SelfieValidationResult> validate(XFile file) async {
    // ML Kit face detection is Android/iOS only — the underlying native
    // model can't load in a browser. Auto-pass on web so design review
    // and dev flows aren't blocked; real validation runs on device.
    if (kIsWeb) return const SelfieValid();

    try {
      final inputImage = InputImage.fromFilePath(file.path);
      final faces = await _detector.processImage(inputImage);

      if (faces.isEmpty) {
        return const SelfieInvalid(SelfieRejectionReason.noFace);
      }
      if (faces.length > 1) {
        return const SelfieInvalid(SelfieRejectionReason.multipleFaces);
      }
      final face = faces.first;

      // Compute face area ratio (we need image dimensions for this; ML
      // Kit returns the bounding box in image-pixel coordinates). Use
      // XFile.readAsBytes() so the same code path works on all platforms
      // when the web guard above is later relaxed.
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final decoded = frame.image;
      final imageArea = decoded.width * decoded.height;
      decoded.dispose();
      codec.dispose();
      if (imageArea > 0) {
        final faceArea =
            face.boundingBox.width * face.boundingBox.height;
        if (faceArea / imageArea < _kMinFaceAreaRatio) {
          return const SelfieInvalid(SelfieRejectionReason.faceTooSmall);
        }
      }

      // Eye-open check — only assert if classification gave us values.
      final left = face.leftEyeOpenProbability;
      final right = face.rightEyeOpenProbability;
      if (left != null &&
          right != null &&
          (left < _kMinEyeOpenProbability ||
              right < _kMinEyeOpenProbability)) {
        return const SelfieInvalid(SelfieRejectionReason.eyesClosed);
      }

      return const SelfieValid();
    } catch (e) {
      return SelfieValidationError(e);
    }
  }

  @override
  void dispose() {
    _detector.close();
  }
}

/// Test fake. Set [result] to control return; assert on call counters.
class FakeSelfieValidatorService implements SelfieValidatorService {
  SelfieValidationResult result = const SelfieValid();
  int calls = 0;
  int disposeCalls = 0;
  XFile? lastFile;

  @override
  Future<SelfieValidationResult> validate(XFile file) async {
    calls++;
    lastFile = file;
    return result;
  }

  @override
  void dispose() {
    disposeCalls++;
  }
}
