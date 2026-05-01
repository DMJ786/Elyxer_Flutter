/// Widget tests for SelfieConfirmationView. The Image.file widget is
/// expected to fail to render in tests (no real file at the test
/// path) — we suppress the resulting flutter error and assert on the
/// structural pieces (heading, disclaimer, buttons).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dating_app_verification/screens/photos_verification/selfie_confirmation_view.dart';

void main() {
  // Image.file pointed at a non-existent path will throw inside the
  // image-loading isolate. That surfaces as an exception in the test
  // runner — swallow it so the structural assertions still pass.
  setUp(() {
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('Cannot open file') ||
          message.contains('FileSystemException') ||
          message.contains('Unable to load asset')) {
        return; // expected for synthetic XFile path
      }
      FlutterError.presentError(details);
    };
  });

  Widget host({
    required VoidCallback onRetake,
    required VoidCallback onSubmit,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SelfieConfirmationView(
          selfieFile: XFile('/tmp/nonexistent.jpg'),
          onRetake: onRetake,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  testWidgets('renders heading, disclaimer, and action buttons',
      (tester) async {
    await tester.pumpWidget(host(onRetake: () {}, onSubmit: () {}));
    expect(find.text('Confirm your selfie'), findsOneWidget);
    expect(
      find.text('Please review your photo and submit to proceed.'),
      findsOneWidget,
    );
    expect(
      find.text('This photo will be visible on your profile.'),
      findsOneWidget,
    );
    expect(find.text('Retake'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('Retake dispatches onRetake', (tester) async {
    var retakes = 0;
    await tester.pumpWidget(
      host(onRetake: () => retakes++, onSubmit: () {}),
    );
    await tester.tap(find.text('Retake'));
    expect(retakes, 1);
  });

  testWidgets('Submit dispatches onSubmit', (tester) async {
    var submits = 0;
    await tester.pumpWidget(
      host(onRetake: () {}, onSubmit: () => submits++),
    );
    await tester.tap(find.text('Submit'));
    expect(submits, 1);
  });
}
