/// Accessibility remediation (issue #63): icon-only buttons across the tab
/// modules expose screen-reader labels (Semantics / tooltips).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dating_app_verification/providers/discovery_provider.dart';
import 'package:dating_app_verification/providers/moments_provider.dart';
import 'package:dating_app_verification/screens/discovery/discover_screen.dart';
import 'package:dating_app_verification/screens/moments/moments_screen.dart';
import 'package:dating_app_verification/services/discovery_repository.dart';
import 'package:dating_app_verification/services/moments_repository.dart';

/// Tall viewport + swallow benign RenderFlex overflow / NetworkImage errors
/// that fixed-height cards + network avatars produce in the test font/no-HTTP
/// env. (Kept local so this file doesn't depend on the #62 test helper.)
void useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 1800);
  tester.view.devicePixelRatio = 1.0;
  final original = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final ex = details.exception;
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

Future<void> settleIgnoringOverflow(WidgetTester tester) =>
    tester.pumpAndSettle();

void main() {
  testWidgets('Discovery icon-only buttons expose semantic labels',
      (tester) async {
    final handle = tester.ensureSemantics();
    useTallViewport(tester);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoveryRepositoryProvider
              .overrideWithValue(MockDiscoveryRepository()),
        ],
        child: const MaterialApp(home: DiscoverScreen()),
      ),
    );
    await settleIgnoringOverflow(tester);

    // Header icons carry tooltips (which provide the a11y label);
    // custom InkWell/Material buttons carry an explicit Semantics label.
    expect(find.byTooltip('Filters'), findsOneWidget);
    expect(find.byTooltip('Undo'), findsOneWidget);
    expect(find.bySemanticsLabel('Send a vibe'), findsWidgets);
    expect(find.bySemanticsLabel('Pass'), findsOneWidget);
    expect(find.bySemanticsLabel('Send invite'), findsOneWidget);

    handle.dispose();
  });

  testWidgets('Moments post menu exposes a semantic label', (tester) async {
    final handle = tester.ensureSemantics();
    useTallViewport(tester);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          momentsRepositoryProvider.overrideWithValue(MockMomentsRepository()),
        ],
        child: const MaterialApp(home: MomentsScreen()),
      ),
    );
    await settleIgnoringOverflow(tester);

    expect(find.byTooltip('Post options'), findsWidgets);

    handle.dispose();
  });
}
