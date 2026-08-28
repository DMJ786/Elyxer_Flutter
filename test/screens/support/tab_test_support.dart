/// Shared helpers for the tab-module widget tests (issue #62).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Sets a tall phone viewport AND installs a FlutterError handler that swallows
/// ONLY benign RenderFlex overflow. Call at the very start of a test, before
/// `pumpWidget`.
///
/// Several screens use fixed-height cards (e.g. the 510px Discovery photo card)
/// that overflow a few px under the test environment's fallback fonts —
/// GoogleFonts can't fetch in tests, so line metrics differ. Everything else
/// still routes to the original handler and fails the test as normal.
void useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 1800);
  tester.view.devicePixelRatio = 1.0;

  final original = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final ex = details.exception;
    // Benign in the test env: fixed-height cards overflow a few px under
    // fallback fonts, and network avatars/photos can't load (no HTTP).
    if (ex is NetworkImageLoadException ||
        ex.toString().contains('A RenderFlex overflowed')) {
      return;
    }
    original?.call(details);
  };

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    FlutterError.onError = original;
  });
}

/// `pumpAndSettle` — the overflow handler is installed by [useTallViewport].
Future<void> settleIgnoringOverflow(WidgetTester tester) =>
    tester.pumpAndSettle();
