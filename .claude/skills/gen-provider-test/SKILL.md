---
name: gen-provider-test
description: Generate Riverpod provider and notifier tests. Use when a provider lacks test coverage.
allowed-tools: Read, Write, Grep, Glob
argument-hint: [provider-file-path]
---

# Provider Test Generator

Generate tests for Riverpod providers in `$ARGUMENTS`.

## Steps

1. Read the target provider file
2. Read its associated model file (if any)
3. Read `test/providers/onboarding_provider_test.dart` as the reference pattern
4. Determine test path: `lib/providers/foo.dart` → `test/providers/foo_test.dart`
5. Write the test file

## Test Structure

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// Import provider and models

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('NotifierName', () {
    group('initial state', () {
      test('has correct default values', () {
        final state = container.read(providerName);
        expect(state.field, expectedDefault);
      });
    });

    group('method: methodName', () {
      test('happy path - updates state correctly', () {
        container.read(providerName.notifier).methodName(validInput);
        final state = container.read(providerName);
        expect(state.field, expectedValue);
      });

      test('edge case - handles invalid input', () {
        container.read(providerName.notifier).methodName(invalidInput);
        // assert behavior
      });
    });

    group('validation', () {
      test('canProceed is false when required fields empty', () { ... });
      test('canProceed is true when all required fields set', () { ... });
    });
  });
}
```

## Rules
- Use `ProviderContainer` (not widget-based testing) for pure provider tests
- Always `dispose()` the container in `tearDown`
- Test each notifier method: happy path + at least 1 edge case
- Test computed/derived providers separately
- Test validation providers (`canProceed*`) with all combinations
- For async providers, use `container.read(provider.future)` and `await`
- For timer providers, test start/stop/reset/resend logic
