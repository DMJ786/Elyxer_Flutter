/// Widget tests for PhotoErrorPopUp.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/widgets/photo_error_popup.dart';

void main() {
  Future<void> openPopup(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showPhotoErrorPopUp(context),
              child: const Text('open'),
            ),
          ),
        );
      }),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders title, body, and Ok button', (tester) async {
    await openPopup(tester);
    expect(
      find.text('Some photos did not meet our guidelines and were removed'),
      findsOneWidget,
    );
    expect(
      find.text('Please upload a different photo to continue.'),
      findsOneWidget,
    );
    expect(find.text('Ok'), findsOneWidget);
  });

  testWidgets('Ok dismisses the dialog', (tester) async {
    await openPopup(tester);
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
    expect(find.text('Ok'), findsNothing);
  });
}
