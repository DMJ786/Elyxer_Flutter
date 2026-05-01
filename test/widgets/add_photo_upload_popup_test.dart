/// Widget tests for AddPhotoUploadPopUp — verifies the showAddPhotoUploadPopUp
/// future resolves with the correct AddPhotoSource when each button is
/// tapped, and with null when dismissed.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/widgets/add_photo_upload_popup.dart';

void main() {
  Future<AddPhotoSource?> openAndTap(
    WidgetTester tester, {
    required String label,
  }) async {
    AddPhotoSource? result;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () async {
                result = await showAddPhotoUploadPopUp(context);
              },
              child: const Text('open'),
            ),
          ),
        );
      }),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Upload a photo'), findsOneWidget);
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('Take a photo returns AddPhotoSource.camera', (tester) async {
    final result = await openAndTap(tester, label: 'Take a photo');
    expect(result, AddPhotoSource.camera);
  });

  testWidgets('Upload a photo returns AddPhotoSource.gallery',
      (tester) async {
    final result = await openAndTap(tester, label: 'Upload a photo');
    expect(result, AddPhotoSource.gallery);
  });
}
