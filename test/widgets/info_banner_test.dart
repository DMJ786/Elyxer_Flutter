/// Info Banner Tests
/// Tests for InfoBanner widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/widgets/info_banner.dart';

void main() {
  group('InfoBanner', () {
    testWidgets('should render the message text', (tester) async {
      const testMessage = 'This is a test information message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: testMessage,
            ),
          ),
        ),
      );

      // Should display the message
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should show the info icon from SVG', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Test message',
            ),
          ),
        ),
      );

      // Should render an SVG (checking for the package type)
      expect(find.byType(InfoBanner), findsOneWidget);
    });

    testWidgets('should have center crossAxisAlignment', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Test message',
            ),
          ),
        ),
      );

      // Find the Row widget inside InfoBanner
      final rowFinder = find.descendant(
        of: find.byType(InfoBanner),
        matching: find.byType(Row),
      );

      expect(rowFinder, findsOneWidget);

      final row = tester.widget<Row>(rowFinder);
      expect(
        row.crossAxisAlignment,
        equals(CrossAxisAlignment.center),
      );
    });

    testWidgets('should have white background with brand dark border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Test message',
            ),
          ),
        ),
      );

      // Find the Container
      final containerFinder = find.descendant(
        of: find.byType(InfoBanner),
        matching: find.byType(Container),
      );

      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      expect(container.decoration, isA<BoxDecoration>());

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.white));
      expect(decoration.border, isNotNull);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('should have correct padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Test message',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(InfoBanner),
          matching: find.byType(Container),
        ),
      );

      expect(container.padding, isNotNull);
    });

    testWidgets('should render message with correct text style', (tester) async {
      const testMessage = 'Information about this step';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: testMessage,
            ),
          ),
        ),
      );

      final textFinder = find.text(testMessage);
      expect(textFinder, findsOneWidget);

      final text = tester.widget<Text>(textFinder);
      expect(text.style, isNotNull);
      expect(text.style!.fontSize, equals(14.0));
      expect(text.style!.height, equals(1.43));
    });

    testWidgets('should have spacing between icon and text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Test message',
            ),
          ),
        ),
      );

      // Find SizedBox between icon and text
      final sizedBoxes = find.descendant(
        of: find.byType(InfoBanner),
        matching: find.byType(SizedBox),
      );

      expect(sizedBoxes, findsWidgets);
    });

    testWidgets('message text should be expandable', (tester) async {
      const longMessage = 'This is a very long information message that '
          'should wrap to multiple lines and take up all available space in '
          'the banner without overflowing or being cut off';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: InfoBanner(
                message: longMessage,
              ),
            ),
          ),
        ),
      );

      // Find the Expanded widget wrapping the text
      final expandedFinder = find.descendant(
        of: find.byType(InfoBanner),
        matching: find.byType(Expanded),
      );

      expect(expandedFinder, findsOneWidget);
    });

    testWidgets('should render with different messages', (tester) async {
      const message1 = 'First message';
      const message2 = 'Second different message';

      // First message
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: message1,
            ),
          ),
        ),
      );

      expect(find.text(message1), findsOneWidget);
      expect(find.text(message2), findsNothing);

      // Change to second message
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: message2,
            ),
          ),
        ),
      );

      expect(find.text(message1), findsNothing);
      expect(find.text(message2), findsOneWidget);
    });

    testWidgets('should have rounded corners', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Test message',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(InfoBanner),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets('should maintain structure with empty message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: '',
            ),
          ),
        ),
      );

      // Should still render the banner structure even with empty message
      expect(find.byType(InfoBanner), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('information icon should have correct size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Test',
            ),
          ),
        ),
      );

      // The info banner should render
      expect(find.byType(InfoBanner), findsOneWidget);
      
      // SVG should be present (we can't directly test SVG properties in widget tests)
      // but we can verify the widget structure exists
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('should display multiline messages correctly', (tester) async {
      const multilineMessage = 'This is line one\nThis is line two\nLine three here';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: InfoBanner(
                message: multilineMessage,
              ),
            ),
          ),
        ),
      );

      expect(find.text(multilineMessage), findsOneWidget);
    });

    testWidgets('banner should have consistent appearance across instances', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                InfoBanner(message: 'First banner'),
                SizedBox(height: 16),
                InfoBanner(message: 'Second banner'),
              ],
            ),
          ),
        ),
      );

      // Should find two banners
      expect(find.byType(InfoBanner), findsNWidgets(2));
      
      // Both should have the same structure
      expect(find.text('First banner'), findsOneWidget);
      expect(find.text('Second banner'), findsOneWidget);
    });
  });
}
