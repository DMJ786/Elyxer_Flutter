/// Widget tests for AddPhotoScreen — grid composition, helper-text
/// gating, and structural integrity. Filled-state and picker-tap
/// behavior is exercised in the SelfieFlowSheet tests + manual QA
/// (Image.file rendering and modal dispatch are out of scope here).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/models/photos_verification_models.dart';
import 'package:dating_app_verification/providers/photo_picker_provider.dart';
import 'package:dating_app_verification/providers/photos_verification_provider.dart';
import 'package:dating_app_verification/screens/photos_verification/add_photo_screen.dart';
import 'package:dating_app_verification/services/photo_picker_service.dart';
import 'package:dating_app_verification/widgets/photo_grid_slot.dart';
import 'package:dating_app_verification/widgets/selfie_grid_slot.dart';

void main() {
  // Filled photo slots use Image.file with synthetic paths in tests —
  // suppress the ensuing file-not-found errors so structural assertions
  // still surface.
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

  Future<ProviderContainer> pumpScreen(
    WidgetTester tester, {
    int initialPhotoCount = 0,
  }) async {
    final container = ProviderContainer(overrides: [
      photoPickerServiceProvider.overrideWithValue(FakePhotoPickerService()),
    ]);
    addTearDown(container.dispose);

    // Pre-seed the photo data via the notifier so the screen reflects state.
    final notifier =
        container.read(photosVerificationDataProvider.notifier);
    for (var i = 0; i < initialPhotoCount; i++) {
      notifier.addPhoto('/tmp/photo$i.jpg');
    }

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(body: AddPhotoScreen()),
      ),
    ));
    return container;
  }

  testWidgets('renders heading and subtitle', (tester) async {
    await pumpScreen(tester);
    expect(find.text('Add your best photos'), findsOneWidget);
    expect(
      find.text('Candid and natural photos make the best impression.'),
      findsOneWidget,
    );
  });

  testWidgets('renders 5 photo slots and 1 selfie slot in the grid',
      (tester) async {
    await pumpScreen(tester);
    expect(find.byType(PhotoGridSlot), findsNWidgets(kMaxPhotos));
    expect(find.byType(SelfieGridSlot), findsOneWidget);
  });

  testWidgets('helper text is visible when photos count is below minimum',
      (tester) async {
    await pumpScreen(tester);
    expect(
      find.text('Minimum $kMinPhotos photos required to continue.'),
      findsOneWidget,
    );
  });

  testWidgets('helper text disappears once minimum is reached',
      (tester) async {
    // Pre-seed kMinPhotos photos via the data notifier so the helper
    // is gated off when the screen builds.
    await pumpScreen(tester, initialPhotoCount: kMinPhotos);
    expect(
      find.text('Minimum $kMinPhotos photos required to continue.'),
      findsNothing,
    );
  });
}
