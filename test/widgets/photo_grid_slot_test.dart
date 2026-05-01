/// Widget tests for PhotoGridSlot — empty-state rendering + tap dispatch.
/// Filled-state tests skipped: Image.file would need a real file at the
/// test path, and the visual rendering is exercised in manual QA.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_verification/widgets/photo_grid_slot.dart';

void main() {
  Widget host({
    String? imagePath,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: PhotoGridSlot(
            imagePath: imagePath,
            onTap: onTap,
            onRemove: onRemove,
          ),
        ),
      ),
    );
  }

  testWidgets('empty slot renders a 160x160 cell with a plus icon',
      (tester) async {
    await tester.pumpWidget(host(onTap: () {}, onRemove: () {}));

    expect(find.byIcon(Icons.add), findsOneWidget);

    final slotSize = tester.getSize(find.byType(PhotoGridSlot));
    expect(slotSize.width, 160);
    expect(slotSize.height, 160);
  });

  testWidgets('tapping an empty slot dispatches onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(
      onTap: () => taps++,
      onRemove: () {},
    ));
    await tester.tap(find.byType(PhotoGridSlot));
    expect(taps, 1);
  });
}
