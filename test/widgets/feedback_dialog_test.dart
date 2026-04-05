/// Feedback Dialog Tests
/// Tests for the FeedbackDialog and ThankYouDialog widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/widgets/feedback_dialog.dart';

void main() {
  /// Helper that renders a scaffold with a button to trigger the dialog.
  Widget buildApp({required VoidCallback onPressed}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // FeedbackDialog
  // -----------------------------------------------------------------------
  group('FeedbackDialog', () {
    testWidgets('displays title and hint text', (tester) async {
      await tester.pumpWidget(buildApp(
        onPressed: () {},
      ));

      // Show dialog manually via the static helper
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => FeedbackDialog.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Share your feedback'), findsOneWidget);
      expect(find.text('Add your Thoughts...'), findsOneWidget);
    });

    testWidgets('displays Cancel and Submit buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => FeedbackDialog.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('Cancel button dismisses dialog', (tester) async {
      String? result = 'not-set';
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await FeedbackDialog.show(context);
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

      // Dialog should be dismissed
      expect(find.text('Share your feedback'), findsNothing);
      expect(result, isNull);
    });

    testWidgets('Submit with empty text does not dismiss', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => FeedbackDialog.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap submit without entering text
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Dialog should still be open
      expect(find.text('Share your feedback'), findsOneWidget);
    });

    testWidgets('Submit with text returns the feedback', (tester) async {
      String? feedback;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  feedback = await FeedbackDialog.show(context);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Type feedback text
      await tester.enterText(find.byType(TextField), 'Great app!');
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(feedback, 'Great app!');
      expect(find.text('Share your feedback'), findsNothing);
    });

    testWidgets('Submit trims whitespace from feedback', (tester) async {
      String? feedback;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  feedback = await FeedbackDialog.show(context);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '  some text  ');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(feedback, 'some text');
    });

    testWidgets('barrier tap dismisses dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => FeedbackDialog.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap outside the dialog (barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Share your feedback'), findsNothing);
    });
  });

  // -----------------------------------------------------------------------
  // ThankYouDialog
  // -----------------------------------------------------------------------
  group('ThankYouDialog', () {
    testWidgets('displays checkmark, heading and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => ThankYouDialog.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Thank you'), findsOneWidget);
      expect(
        find.text('Your feedback helps us improve Elyxer.'),
        findsOneWidget,
      );

      // Drain the auto-dismiss timer so the test framework is happy
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('auto-dismisses after 2 seconds', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => ThankYouDialog.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Thank you'), findsOneWidget);

      // Advance timer by 2 seconds
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Thank you'), findsNothing);
    });

    testWidgets('can be dismissed by tapping barrier', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => ThankYouDialog.show(context),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap outside
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Thank you'), findsNothing);

      // Drain the auto-dismiss timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });
  });

  // -----------------------------------------------------------------------
  // Integration: Feedback → Thank You flow
  // -----------------------------------------------------------------------
  group('Feedback → ThankYou flow', () {
    testWidgets('submitting feedback opens thank-you dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  final feedback = await FeedbackDialog.show(context);
                  if (feedback != null && context.mounted) {
                    await ThankYouDialog.show(context);
                  }
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open feedback dialog
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Share your feedback'), findsOneWidget);

      // Enter text & submit
      await tester.enterText(find.byType(TextField), 'Love it!');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Thank-you dialog should appear
      expect(find.text('Thank you'), findsOneWidget);
      expect(
        find.text('Your feedback helps us improve Elyxer.'),
        findsOneWidget,
      );

      // Auto-dismiss
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('Thank you'), findsNothing);
    });

    testWidgets('cancelling feedback does NOT open thank-you dialog',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  final feedback = await FeedbackDialog.show(context);
                  if (feedback != null && context.mounted) {
                    await ThankYouDialog.show(context);
                  }
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

      // Thank-you should NOT appear
      expect(find.text('Thank you'), findsNothing);
    });
  });
}
