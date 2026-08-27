/// Moment author preview (issue #60): tapping another member's author opens
/// their profile preview; own moments are not tappable.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dating_app_verification/models/moment_models.dart';
import 'package:dating_app_verification/screens/moments/moment_author_preview_screen.dart';
import 'package:dating_app_verification/screens/moments/widgets/moment_widgets.dart';
import 'package:dating_app_verification/services/discovery_repository.dart';

void main() {
  testWidgets('author preview renders the profile + a Send Invite action',
      (tester) async {
    final profile = MockDiscoveryRepository.seedProfiles.first; // Maya

    await tester.pumpWidget(
      MaterialApp(home: MomentAuthorPreviewScreen(profile: profile)),
    );
    await tester.pumpAndSettle();

    expect(find.text("Maya's Profile"), findsOneWidget);
    expect(find.text('Send Invite'), findsOneWidget);
  });

  testWidgets("only others' moments make the author tappable", (tester) async {
    final author =
        MockDiscoveryRepository.seedProfiles.first.copyWith(photos: const []);
    var taps = 0;

    Widget card({required bool isMine}) => MaterialApp(
          home: Scaffold(
            body: MomentCard(
              moment: Moment(
                id: 'm1',
                author: author,
                timeLabel: '2h ago',
                text: 'hi',
                isMine: isMine,
              ),
              onAction: (MomentMenuAction _) {},
              onTapAuthor: () => taps++,
            ),
          ),
        );

    // Another member's moment → author is tappable.
    await tester.pumpWidget(card(isMine: false));
    await tester.tap(find.text('Maya'));
    await tester.pump();
    expect(taps, 1);

    // Own moment → author is not tappable (shows "You").
    await tester.pumpWidget(card(isMine: true));
    await tester.tap(find.text('You'));
    await tester.pump();
    expect(taps, 1, reason: 'own moments must not open a preview');
  });
}
