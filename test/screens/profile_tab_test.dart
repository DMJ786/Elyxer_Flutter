/// Profile tab wiring (issue #66): the Profile tab lands on the refined
/// profile view (via Profile Studio), not the old "Coming soon" placeholder,
/// and the Module 6 edit sheets still open.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dating_app_verification/models/profile_studio_models.dart';
import 'package:dating_app_verification/screens/profile_studio/profile_studio_screen.dart';
import 'package:dating_app_verification/screens/profile_studio/edit_sheets/my_story_edit_sheet.dart';

Widget _profileTab() => const ProviderScope(
      child: MaterialApp(
        home: ProfileStudioScreen(
          initialStep: ProfileStudioStep.refined,
          asProfileTab: true,
        ),
      ),
    );

/// Give the harness a tall phone viewport so the refined column lays out
/// without overflowing the default 800×600 test surface.
void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(400, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  testWidgets('Profile tab lands on the refined profile, not a placeholder',
      (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(_profileTab());
    await tester.pumpAndSettle();

    // Refined-only section cards are shown (top of the profile view).
    expect(find.text('MY STORY'), findsOneWidget);
    expect(find.text('INTERESTS'), findsOneWidget);
    // The retired placeholder copy must be gone.
    expect(find.text('Coming soon'), findsNothing);
  });

  testWidgets('Edit affordance opens a Module 6 edit sheet', (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(_profileTab());
    await tester.pumpAndSettle();

    // First Edit button belongs to the My Story section.
    await tester.tap(find.widgetWithText(TextButton, 'Edit').first);
    await tester.pumpAndSettle();

    expect(find.byType(MyStoryEditSheet), findsOneWidget);
  });
}
