/// Tests for PhotoVerificationProgressIndicator
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating_app_verification/models/photo_verification_models.dart';
import 'package:dating_app_verification/widgets/photo_verification_progress_indicator.dart';

void main() {
  Future<void> pumpAt(
    WidgetTester tester,
    PhotoVerificationStep step,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhotoVerificationProgressIndicator(currentStep: step),
        ),
      ),
    );
  }

  testWidgets('renders 3 SVG icons + 1 check icon', (tester) async {
    await pumpAt(tester, PhotoVerificationStep.height);
    expect(find.byType(SvgPicture), findsNWidgets(3));
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('height step: HeightIcon active, others incomplete', (tester) async {
    await pumpAt(tester, PhotoVerificationStep.height);
    final svgs = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    expect((svgs[0].key as ValueKey<String>).value,
        contains('HeightIcons/state=Inprogress'));
    expect((svgs[1].key as ValueKey<String>).value,
        contains('LanguageIcons/state=Incomplete'));
    expect((svgs[2].key as ValueKey<String>).value,
        contains('PhotoUploadIcons/state=Incomplete'));
  });

  testWidgets('language step: Height done, Language active, Photo waiting',
      (tester) async {
    await pumpAt(tester, PhotoVerificationStep.language);
    final svgs = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    expect((svgs[0].key as ValueKey<String>).value,
        contains('HeightIcons/state=Completed'));
    expect((svgs[1].key as ValueKey<String>).value,
        contains('LanguageIcons/state=Inprogress'));
    expect((svgs[2].key as ValueKey<String>).value,
        contains('PhotoUploadIcons/state=Incomplete'));
  });

  testWidgets('photos step: only Photo active', (tester) async {
    await pumpAt(tester, PhotoVerificationStep.photos);
    final svgs = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    expect((svgs[0].key as ValueKey<String>).value,
        contains('HeightIcons/state=Completed'));
    expect((svgs[1].key as ValueKey<String>).value,
        contains('LanguageIcons/state=Completed'));
    expect((svgs[2].key as ValueKey<String>).value,
        contains('PhotoUploadIcons/state=Inprogress'));
  });

  testWidgets('complete step: all SVGs completed', (tester) async {
    await pumpAt(tester, PhotoVerificationStep.complete);
    final svgs = tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    for (final svg in svgs) {
      expect((svg.key as ValueKey<String>).value, contains('state=Completed'));
    }
  });
}
