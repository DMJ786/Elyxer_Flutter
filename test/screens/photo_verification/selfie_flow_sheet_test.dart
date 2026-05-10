/// Widget tests for SelfieFlowSheet — state machine routing.
/// Both PhotoPickerService and SelfieValidatorService are stubbed
/// with fakes so tests run with zero platform-channel calls.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dating_app_verification/providers/photo_picker_provider.dart';
import 'package:dating_app_verification/providers/photo_verification_provider.dart';
import 'package:dating_app_verification/providers/selfie_validator_provider.dart';
import 'package:dating_app_verification/screens/photo_verification/selfie_flow_sheet.dart';
import 'package:dating_app_verification/services/photo_picker_service.dart';
import 'package:dating_app_verification/services/selfie_validator_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Flow sheet renders SelfieCaptureView (face guide 300px + Spacer +
    // capture button stack) — needs a phone-shaped surface to lay out.
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.implicitView!;
    view.physicalSize = const Size(400, 900);
    view.devicePixelRatio = 1.0;
  });

  tearDownAll(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.implicitView!;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  setUp(() {
    FlutterError.onError = (details) {
      final msg = details.exceptionAsString();
      if (msg.contains('Cannot open file') ||
          msg.contains('FileSystemException') ||
          msg.contains('Unable to load asset')) {
        return;
      }
      FlutterError.presentError(details);
    };
  });

  Future<ProviderContainer> openSheet(
    WidgetTester tester, {
    required FakePhotoPickerService picker,
    required FakeSelfieValidatorService validator,
  }) async {
    final container = ProviderContainer(overrides: [
      photoPickerServiceProvider.overrideWithValue(picker),
      selfieValidatorServiceProvider.overrideWithValue(validator),
    ]);
    addTearDown(container.dispose);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () => showSelfieFlowSheet(context),
              child: const Text('open'),
            ),
          );
        }),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('initial state shows the capture view', (tester) async {
    await openSheet(
      tester,
      picker: FakePhotoPickerService(),
      validator: FakeSelfieValidatorService(),
    );
    expect(find.text('Take a clear selfie'), findsOneWidget);
  });

  testWidgets(
      'capture → SelfieValid → confirmation state (front camera used)',
      (tester) async {
    final picker = FakePhotoPickerService()
      ..cameraResult = PhotoPickSuccess(XFile('/tmp/ok.jpg'));
    final validator = FakeSelfieValidatorService()
      ..result = const SelfieValid();

    await openSheet(tester, picker: picker, validator: validator);
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();

    expect(find.text('Confirm your selfie'), findsOneWidget);
    expect(picker.cameraCalls, 1);
    expect(picker.lastCameraPreference, PhotoCameraDevice.front);
    expect(validator.calls, 1);
  });

  testWidgets('capture → SelfieInvalid(noFace) → rejection with reason',
      (tester) async {
    final picker = FakePhotoPickerService()
      ..cameraResult = PhotoPickSuccess(XFile('/tmp/x.jpg'));
    final validator = FakeSelfieValidatorService()
      ..result = const SelfieInvalid(SelfieRejectionReason.noFace);

    await openSheet(tester, picker: picker, validator: validator);
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();

    expect(find.text('We are unable to use this selfie'), findsOneWidget);
    expect(
      find.text(SelfieRejectionReason.noFace.displayMessage),
      findsOneWidget,
    );
  });

  testWidgets(
      'capture → SelfieValidationError → rejection without specific reason',
      (tester) async {
    final picker = FakePhotoPickerService()
      ..cameraResult = PhotoPickSuccess(XFile('/tmp/x.jpg'));
    final validator = FakeSelfieValidatorService()
      ..result = const SelfieValidationError('boom');

    await openSheet(tester, picker: picker, validator: validator);
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();

    expect(find.text('We are unable to use this selfie'), findsOneWidget);
    expect(
      find.text("Something went wrong. Let's try again."),
      findsOneWidget,
    );
  });

  testWidgets('capture → PhotoPickError → rejection state', (tester) async {
    final picker = FakePhotoPickerService()
      ..cameraResult = const PhotoPickError('camera died');
    final validator = FakeSelfieValidatorService();

    await openSheet(tester, picker: picker, validator: validator);
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();

    expect(find.text('We are unable to use this selfie'), findsOneWidget);
    expect(validator.calls, 0); // never called when picker errors
  });

  testWidgets('capture → cancelled → stay on capture', (tester) async {
    final picker = FakePhotoPickerService(); // default = Cancelled
    final validator = FakeSelfieValidatorService();

    await openSheet(tester, picker: picker, validator: validator);
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();

    // Still on capture state — no confirmation, no rejection.
    expect(find.text('Take a clear selfie'), findsOneWidget);
    expect(find.text('Confirm your selfie'), findsNothing);
    expect(find.text('We are unable to use this selfie'), findsNothing);
  });

  testWidgets('rejection → Retake returns to capture state', (tester) async {
    final picker = FakePhotoPickerService()
      ..cameraResult = PhotoPickSuccess(XFile('/tmp/x.jpg'));
    final validator = FakeSelfieValidatorService()
      ..result = const SelfieInvalid(SelfieRejectionReason.noFace);

    await openSheet(tester, picker: picker, validator: validator);
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();
    expect(find.text('We are unable to use this selfie'), findsOneWidget);

    await tester.tap(find.text('Retake'));
    await tester.pumpAndSettle();

    expect(find.text('Take a clear selfie'), findsOneWidget);
    expect(find.text('We are unable to use this selfie'), findsNothing);
  });

  testWidgets('confirmation → Submit saves selfie + closes the sheet',
      (tester) async {
    final picker = FakePhotoPickerService()
      ..cameraResult = PhotoPickSuccess(XFile('/tmp/ok.jpg'));
    final validator = FakeSelfieValidatorService()
      ..result = const SelfieValid();

    final container =
        await openSheet(tester, picker: picker, validator: validator);

    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pumpAndSettle();
    expect(find.text('Confirm your selfie'), findsOneWidget);

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    final data = container.read(photoVerificationDataProvider);
    expect(data.selfiePhotoPath, '/tmp/ok.jpg');
    expect(data.selfieVerified, isTrue);
    // Sheet should be dismissed — open button visible again.
    expect(find.text('open'), findsOneWidget);
  });
}
