/// Tests for LanguageInputScreen — search filter, chip rendering, max-6 enforcement.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dating_app_verification/providers/photos_verification_provider.dart';
import 'package:dating_app_verification/screens/photos_verification/language_input_screen.dart';

void main() {
  Future<ProviderContainer> pumpScreen(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: LanguageInputScreen()),
        ),
      ),
    );
    return container;
  }

  testWidgets('renders heading and search field', (tester) async {
    await pumpScreen(tester);
    expect(find.text('Your Languages'), findsOneWidget);
    expect(find.text('Search and add languages'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('typing filters the suggestion list', (tester) async {
    await pumpScreen(tester);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Hindi'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Eng');
    await tester.pump();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Hindi'), findsNothing);
  });

  testWidgets('tapping a suggestion adds a chip and removes it from list',
      (tester) async {
    final container = await pumpScreen(tester);

    await tester.tap(find.text('English'));
    await tester.pump();

    final selected = container
        .read(photosVerificationDataProvider.select((d) => d.languages));
    expect(selected, ['English']);
    // After selection, 'English' moves out of suggestions and into chip.
    // The chip uses ShaderMask but the underlying Text is still 'English'.
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('helper text shows 0 / 6 selected initially', (tester) async {
    await pumpScreen(tester);
    expect(find.text('0 / 6 selected'), findsOneWidget);
  });

  testWidgets('helper text increments as languages are added',
      (tester) async {
    final container = await pumpScreen(tester);
    container
        .read(photosVerificationDataProvider.notifier)
        .addLanguage('Tamil');
    await tester.pump();
    expect(find.text('1 / 6 selected'), findsOneWidget);
  });

  testWidgets('search disables and shows limit message when at max',
      (tester) async {
    final container = await pumpScreen(tester);
    final notifier =
        container.read(photosVerificationDataProvider.notifier);
    for (final l in ['English', 'Hindi', 'Spanish', 'French', 'German', 'Tamil']) {
      notifier.addLanguage(l);
    }
    await tester.pump();

    expect(find.text('You can add up to 6 languages.'), findsOneWidget);
    final tf = tester.widget<TextField>(find.byType(TextField));
    expect(tf.enabled, isFalse);
  });
}
