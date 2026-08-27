/// Main tabbed app shell.
///
/// Hosts the five primary destinations (Profile · Moments · Discover ·
/// Interests · Chat) inside a [StatefulShellRoute.indexedStack] so each tab
/// keeps its own navigation stack, scroll position, and in-progress state
/// across switches. Renders the shared [AppBottomNav], driving its selection
/// from the active branch index.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import 'app_bottom_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  /// The stateful shell for the current set of tab branches, supplied by
  /// [StatefulShellRoute.indexedStack]'s builder.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onSelect: _goBranch,
      ),
    );
  }

  void _goBranch(int index) {
    // Tapping the already-active tab resets it to its root — the standard
    // go_router indexed-stack idiom.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
