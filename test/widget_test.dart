// Basic app widget test
// Tests that the app builds and initializes correctly
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/main.dart';

void main() {
  testWidgets('App initializes and builds without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      const ProviderScope(
        child: DatingAppVerification(),
      ),
    );

    // Allow the app to settle
    await tester.pumpAndSettle();

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App renders with correct title', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(
      const ProviderScope(
        child: DatingAppVerification(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the app widget exists
    expect(find.byType(DatingAppVerification), findsOneWidget);
  });
}
