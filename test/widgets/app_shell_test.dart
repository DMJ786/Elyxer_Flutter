/// Shell mechanics for the main tabbed app (issue #58): tab switching,
/// per-branch state preservation, and deep-link → correct branch.
///
/// Uses lightweight stub branch screens so the test exercises AppShell +
/// AppBottomNav wiring without booting the real tab providers/repositories.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:dating_app_verification/widgets/app_shell.dart';

void main() {
  // AppBottomNav renders AppTab.values in order: Profile, Moments, Discover,
  // Interests, Chat → branch indices 0..4. The stub branches below map to the
  // same order so tapping a tab label lands on the matching stub.
  GoRouter buildRouter() {
    StatefulShellBranch branch(String path, String label) => StatefulShellBranch(
          routes: [
            GoRoute(
              path: path,
              builder: (context, state) => _CounterScreen(label: label),
            ),
          ],
        );

    return GoRouter(
      initialLocation: '/profile-home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            branch('/profile-home', 'A'),
            branch('/moments', 'B'),
            branch('/discover', 'C'),
            branch('/interests', 'D'),
            branch('/chats', 'E'),
          ],
        ),
      ],
    );
  }

  testWidgets('tapping a tab switches to that branch', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
    await tester.pumpAndSettle();

    expect(find.text('screen A'), findsOneWidget); // starts on Profile branch

    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();

    expect(find.text('screen C'), findsOneWidget);
    expect(find.text('screen A'), findsNothing);
  });

  testWidgets('each branch keeps its own state across switches',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
    await tester.pumpAndSettle();

    // Bump the counter on the Profile branch to 2.
    await tester.tap(find.text('inc'));
    await tester.tap(find.text('inc'));
    await tester.pumpAndSettle();
    expect(find.text('count 2'), findsOneWidget);

    // Leave to Chat and come back to Profile.
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.text('screen E'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // State survived the round-trip (indexed stack keeps branches alive).
    expect(find.text('screen A'), findsOneWidget);
    expect(find.text('count 2'), findsOneWidget);
  });

  testWidgets('deep link activates the matching branch', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    router.go('/interests');
    await tester.pumpAndSettle();

    expect(find.text('screen D'), findsOneWidget);
  });
}

class _CounterScreen extends StatefulWidget {
  const _CounterScreen({required this.label});

  final String label;

  @override
  State<_CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<_CounterScreen> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('screen ${widget.label}'),
            Text('count $_count'),
            ElevatedButton(
              onPressed: () => setState(() => _count++),
              child: const Text('inc'),
            ),
          ],
        ),
      ),
    );
  }
}
