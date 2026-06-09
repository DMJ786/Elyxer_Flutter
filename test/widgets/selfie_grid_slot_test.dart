/// Widget tests for SelfieGridSlot — empty-state rendering + tap dispatch.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/widgets/selfie_grid_slot.dart';

void main() {
  Widget host({String? selfiePath, required VoidCallback onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SelfieGridSlot(selfiePath: selfiePath, onTap: onTap),
        ),
      ),
    );
  }

  testWidgets('empty slot shows the Figma copy and camera icon',
      (tester) async {
    await tester.pumpWidget(host(onTap: () {}));
    expect(find.text('Add a selfie'), findsOneWidget);
    expect(find.text('Unlock your badge'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
  });

  testWidgets('empty slot is 160x160', (tester) async {
    await tester.pumpWidget(host(onTap: () {}));
    final size = tester.getSize(find.byType(SelfieGridSlot));
    expect(size.width, 160);
    expect(size.height, 160);
  });

  testWidgets('tapping the empty slot dispatches onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(onTap: () => taps++));
    await tester.tap(find.byType(SelfieGridSlot));
    expect(taps, 1);
  });
}
