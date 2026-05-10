/// Widget tests for SelfieRejectionView — reason copy + callbacks.
/// Tests pump with attemptedFile=null so Image.file isn't rendered;
/// the visual blur path is exercised in manual QA.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/screens/photo_verification/selfie_rejection_view.dart';
import 'package:dating_app_verification/services/selfie_validator_service.dart';

void main() {
  Widget host({
    required SelfieRejectionReason? reason,
    required VoidCallback onRetake,
    required VoidCallback onAddLater,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SelfieRejectionView(
          attemptedFile: null,
          reason: reason,
          onRetake: onRetake,
          onAddLater: onAddLater,
        ),
      ),
    );
  }

  testWidgets('renders heading + reason copy when provided', (tester) async {
    await tester.pumpWidget(host(
      reason: SelfieRejectionReason.noFace,
      onRetake: () {},
      onAddLater: () {},
    ));
    expect(find.text('We are unable to use this selfie'), findsOneWidget);
    expect(
      find.text(SelfieRejectionReason.noFace.displayMessage),
      findsOneWidget,
    );
    expect(find.text('Retake'), findsOneWidget);
    expect(find.text('Add later'), findsOneWidget);
  });

  testWidgets('renders generic copy when reason is null', (tester) async {
    await tester.pumpWidget(host(
      reason: null,
      onRetake: () {},
      onAddLater: () {},
    ));
    expect(
      find.text("Something went wrong. Let's try again."),
      findsOneWidget,
    );
  });

  testWidgets('Retake dispatches onRetake', (tester) async {
    var retakes = 0;
    await tester.pumpWidget(host(
      reason: SelfieRejectionReason.eyesClosed,
      onRetake: () => retakes++,
      onAddLater: () {},
    ));
    await tester.tap(find.text('Retake'));
    expect(retakes, 1);
  });

  testWidgets('Add later dispatches onAddLater', (tester) async {
    var skips = 0;
    await tester.pumpWidget(host(
      reason: SelfieRejectionReason.faceTooSmall,
      onRetake: () {},
      onAddLater: () => skips++,
    ));
    await tester.tap(find.text('Add later'));
    expect(skips, 1);
  });

  testWidgets('reason-specific copy maps correctly', (tester) async {
    for (final reason in SelfieRejectionReason.values) {
      await tester.pumpWidget(host(
        reason: reason,
        onRetake: () {},
        onAddLater: () {},
      ));
      expect(find.text(reason.displayMessage), findsOneWidget,
          reason: 'displayMessage for $reason should render');
    }
  });
}
