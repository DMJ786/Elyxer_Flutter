---
name: gen-widget-test
description: Generate widget tests for a Flutter screen or reusable widget. Use when a widget lacks test coverage.
allowed-tools: Read, Write, Grep, Glob
argument-hint: [widget-file-path]
---

# Widget Test Generator

Generate comprehensive widget tests for `$ARGUMENTS`.

## Steps

1. Read the target widget file
2. Read existing test patterns from `test/widgets/info_banner_test.dart` (reference)
3. Determine the test file path: mirror `lib/` structure under `test/`
   - Example: `lib/widgets/foo.dart` → `test/widgets/foo_test.dart`
   - Example: `lib/screens/onboarding/age_input_screen.dart` → `test/screens/onboarding/age_input_screen_test.dart`
4. Write the test file

## Test Structure

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import the widget under test

void main() {
  // Helper to build widget with required wrappers
  Widget buildTestWidget({/* optional overrides */}) {
    return ProviderScope(
      overrides: [/* provider overrides if needed */],
      child: MaterialApp(
        home: Scaffold(
          body: WidgetUnderTest(),
        ),
      ),
    );
  }

  group('WidgetName', () {
    group('rendering', () {
      testWidgets('renders correctly with default props', (tester) async { ... });
      testWidgets('displays expected text content', (tester) async { ... });
    });

    group('interaction', () {
      testWidgets('responds to tap events', (tester) async { ... });
      testWidgets('validates input correctly', (tester) async { ... });
    });

    group('state', () {
      testWidgets('updates state on user action', (tester) async { ... });
    });

    group('edge cases', () {
      testWidgets('handles empty/null data gracefully', (tester) async { ... });
    });
  });
}
```

## Rules
- Every public widget must have at least: 1 render test, 1 interaction test, 1 edge case
- Use `ProviderScope` wrapper for any widget that reads Riverpod providers
- Use `MaterialApp` wrapper for widgets using `Theme.of(context)` or navigation
- Use `find.text()`, `find.byType()`, `find.byKey()` for element lookups
- Use `tester.tap()`, `tester.enterText()`, `tester.pump()` for interactions
- Mock services/providers using `ProviderScope(overrides: [...])`
