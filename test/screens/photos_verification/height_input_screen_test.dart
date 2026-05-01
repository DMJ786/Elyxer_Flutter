/// Tests for HeightInputScreen — header, unit toggle, picker mode switch.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/models/photos_verification_models.dart';
import 'package:dating_app_verification/providers/photos_verification_provider.dart';
import 'package:dating_app_verification/screens/photos_verification/height_input_screen.dart';

void main() {
  Future<ProviderContainer> pumpScreen(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: HeightInputScreen()),
        ),
      ),
    );
    return container;
  }

  testWidgets('renders heading + subtitle + FT/CM toggle', (tester) async {
    await pumpScreen(tester);
    expect(find.text('Your Height'), findsOneWidget);
    expect(find.text('Scroll to select your height'), findsOneWidget);
    expect(find.text('FT'), findsOneWidget);
    expect(find.text('CM'), findsOneWidget);
  });

  testWidgets('starts in FT mode by default', (tester) async {
    final container = await pumpScreen(tester);
    final unit = container
        .read(photosVerificationDataProvider.select((d) => d.heightUnit));
    expect(unit, HeightUnit.feet);
  });

  testWidgets('tapping CM switches the unit in the data provider',
      (tester) async {
    final container = await pumpScreen(tester);

    await tester.tap(find.text('CM'));
    await tester.pump();

    final unit = container
        .read(photosVerificationDataProvider.select((d) => d.heightUnit));
    expect(unit, HeightUnit.cm);
  });

  testWidgets('initial picker seeds default 5\'7" in FT mode',
      (tester) async {
    await pumpScreen(tester);
    // Single wheel renders combined label per Figma.
    expect(find.text("5'7\""), findsOneWidget);
  });
}
