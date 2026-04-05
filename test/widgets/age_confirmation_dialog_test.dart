/// Age Confirmation Dialog Tests
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/widgets/age_confirmation_dialog.dart';

void main() {
  // -----------------------------------------------------------------------
  // calculateAge
  // -----------------------------------------------------------------------
  group('calculateAge', () {
    test('returns correct age when birthday has already passed this year', () {
      final birthdate = DateTime(2000, 1, 15);
      final now = DateTime(2026, 4, 5);
      expect(calculateAge(birthdate, now: now), 26);
    });

    test('returns correct age when birthday has NOT passed yet this year', () {
      final birthdate = DateTime(2000, 12, 25);
      final now = DateTime(2026, 4, 5);
      expect(calculateAge(birthdate, now: now), 25);
    });

    test('returns correct age on exact birthday', () {
      final birthdate = DateTime(2000, 4, 5);
      final now = DateTime(2026, 4, 5);
      expect(calculateAge(birthdate, now: now), 26);
    });

    test('returns 0 for infant born same year', () {
      final birthdate = DateTime(2026, 1, 1);
      final now = DateTime(2026, 4, 5);
      expect(calculateAge(birthdate, now: now), 0);
    });
  });

  // -----------------------------------------------------------------------
  // showAgeConfirmationDialog
  // -----------------------------------------------------------------------
  group('AgeConfirmationDialog', () {
    Widget buildApp({required int age}) {
      return MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => showAgeConfirmationDialog(context, age: age),
              child: const Text('Open'),
            ),
          ),
        ),
      );
    }

    testWidgets('displays title, age text, and buttons', (tester) async {
      await tester.pumpWidget(buildApp(age: 25));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm your age'), findsOneWidget);
      // The age is in a RichText widget
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('25'),
        ),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('displays correct age for different values', (tester) async {
      await tester.pumpWidget(buildApp(age: 42));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('42'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Cancel returns false', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await showAgeConfirmationDialog(context, age: 25);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, false);
      expect(find.text('Confirm your age'), findsNothing);
    });

    testWidgets('Confirm returns true', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await showAgeConfirmationDialog(context, age: 30);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(result, true);
      expect(find.text('Confirm your age'), findsNothing);
    });

    testWidgets('barrier tap returns null', (tester) async {
      bool? result = false; // sentinel
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await showAgeConfirmationDialog(context, age: 20);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap outside the dialog
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Confirm your age'), findsNothing);
      expect(result, isNull);
    });
  });
}
