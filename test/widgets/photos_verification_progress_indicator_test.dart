/// Tests for PhotosVerificationProgressIndicator
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating_app_verification/models/photos_verification_models.dart';
import 'package:dating_app_verification/widgets/photos_verification_progress_indicator.dart';

void main() {
  Future<void> pumpAt(
    WidgetTester tester,
    PhotosVerificationStep step,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhotosVerificationProgressIndicator(currentStep: step),
        ),
      ),
    );
  }

  testWidgets('renders 3 SVG icons + 1 check icon', (tester) async {
    await pumpAt(tester, PhotosVerificationStep.height);
    expect(find.byType(SvgPicture), findsNWidgets(3));
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('height step: HeightIcon active, others incomplete', (tester) async {
    await pumpAt(tester, PhotosVerificationStep.height);
    final svgs = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    expect((svgs[0].key as ValueKey<String>).value,
        contains('HeightIcon/inprogress'));
    expect((svgs[1].key as ValueKey<String>).value,
        contains('LanguageIcon/incomplete'));
    expect((svgs[2].key as ValueKey<String>).value,
        contains('PhotoIcon/incomplete'));
  });

  testWidgets('language step: Height done, Language active, Photo waiting',
      (tester) async {
    await pumpAt(tester, PhotosVerificationStep.language);
    final svgs = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    expect((svgs[0].key as ValueKey<String>).value,
        contains('HeightIcon/completed'));
    expect((svgs[1].key as ValueKey<String>).value,
        contains('LanguageIcon/inprogress'));
    expect((svgs[2].key as ValueKey<String>).value,
        contains('PhotoIcon/incomplete'));
  });

  testWidgets('photos step: only Photo active', (tester) async {
    await pumpAt(tester, PhotosVerificationStep.photos);
    final svgs = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    expect((svgs[0].key as ValueKey<String>).value,
        contains('HeightIcon/completed'));
    expect((svgs[1].key as ValueKey<String>).value,
        contains('LanguageIcon/completed'));
    expect((svgs[2].key as ValueKey<String>).value,
        contains('PhotoIcon/inprogress'));
  });

  testWidgets('complete step: all SVGs completed', (tester) async {
    await pumpAt(tester, PhotosVerificationStep.complete);
    final svgs = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    for (final svg in svgs) {
      expect((svg.key as ValueKey<String>).value, contains('completed'));
    }
  });
}
