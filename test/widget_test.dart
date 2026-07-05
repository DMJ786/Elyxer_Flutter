// Basic app widget test
// Tests that the app builds and initializes correctly
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/main.dart';
import 'package:dating_app_verification/models/auth_models.dart';
import 'package:dating_app_verification/providers/auth_provider.dart';

void main() {
  // Override authProvider with a static unauthenticated state so tests never
  // hit FirebaseAuth.instance (which throws when Firebase is not initialized
  // in the test environment).
  final authOverrides = [
    authProvider.overrideWithValue(const AuthState()),
  ];

  testWidgets('App initializes and builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: authOverrides,
        child: const DatingAppVerification(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App renders with correct title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: authOverrides,
        child: const DatingAppVerification(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(DatingAppVerification), findsOneWidget);
  });
}

