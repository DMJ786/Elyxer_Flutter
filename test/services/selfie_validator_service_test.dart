/// Unit tests for the SelfieValidatorService abstraction.
/// The MlKitSelfieValidatorService impl wraps platform channels
/// (google_mlkit_face_detection); we test the sealed result types,
/// reason copy, and the FakeSelfieValidatorService used by widget
/// tests. End-to-end ML behavior is verified manually on device.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dating_app_verification/services/selfie_validator_service.dart';

void main() {
  group('FakeSelfieValidatorService', () {
    test('records calls and last file', () async {
      final fake = FakeSelfieValidatorService();
      final file = XFile('/tmp/selfie.jpg');
      await fake.validate(file);
      await fake.validate(XFile('/tmp/selfie2.jpg'));
      expect(fake.calls, 2);
      expect(fake.lastFile?.path, '/tmp/selfie2.jpg');
    });

    test('returns the configured result', () async {
      final fake = FakeSelfieValidatorService();
      fake.result = const SelfieInvalid(SelfieRejectionReason.eyesClosed);
      final result = await fake.validate(XFile('/tmp/x.jpg'));
      expect(result, isA<SelfieInvalid>());
      expect((result as SelfieInvalid).reason,
          SelfieRejectionReason.eyesClosed);
    });

    test('counts dispose invocations', () {
      final fake = FakeSelfieValidatorService();
      fake.dispose();
      fake.dispose();
      expect(fake.disposeCalls, 2);
    });
  });

  group('SelfieRejectionReason.displayMessage', () {
    test('every reason has user-facing copy', () {
      for (final reason in SelfieRejectionReason.values) {
        expect(reason.displayMessage, isNotEmpty);
      }
    });

    test('messages are reason-distinct', () {
      final messages = SelfieRejectionReason.values
          .map((r) => r.displayMessage)
          .toSet();
      expect(messages.length, SelfieRejectionReason.values.length);
    });
  });

  group('SelfieValidationResult sealed pattern matching', () {
    String describe(SelfieValidationResult r) => switch (r) {
          SelfieValid() => 'valid',
          SelfieInvalid(:final reason) => 'invalid:${reason.name}',
          SelfieValidationError(:final error) => 'error:$error',
        };

    test('exhaustive switch covers every variant', () {
      expect(describe(const SelfieValid()), 'valid');
      expect(
        describe(const SelfieInvalid(SelfieRejectionReason.noFace)),
        'invalid:noFace',
      );
      expect(
        describe(
          const SelfieInvalid(SelfieRejectionReason.multipleFaces),
        ),
        'invalid:multipleFaces',
      );
      expect(
        describe(const SelfieValidationError('boom')),
        'error:boom',
      );
    });
  });
}
