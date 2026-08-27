/// Shared bottom navigation for the main app shell (Profile · Moments ·
/// Discover · Interests · Chat).
///
/// Purely presentational: the [AppShell] drives it from the
/// `StatefulShellRoute` branch index and switches branches on tap. The tab
/// order here is the single source of truth for the shell's branch order —
/// keep them in sync.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// The five primary destinations. Order matches the shell's branch order.
enum AppTab {
  profile(Icons.people_outline, 'Profile', '/profile-home'),
  moments(Icons.auto_awesome_outlined, 'Moments', '/moments'),
  discover(Icons.all_inclusive, 'Discover', '/discover'),
  interests(Icons.favorite_outline, 'Interests', '/interests'),
  chat(Icons.chat_bubble_outline, 'Chat', '/chats');

  const AppTab(this.icon, this.label, this.route);

  final IconData icon;
  final String label;

  /// Canonical root route for this tab's branch (used for deep links).
  final String route;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  /// Index of the active tab, in [AppTab.values] order — the shell's current
  /// branch index.
  final int currentIndex;

  /// Called with the tapped tab's index so the shell can switch branch.
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(top: BorderSide(color: AppColors.interactive100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (int i = 0; i < AppTab.values.length; i++)
            _NavItem(
              tab: AppTab.values[i],
              active: i == currentIndex,
              onTap: () => onSelect(i),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final AppTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color =
        active ? AppColors.brandDark : AppColors.interactive400;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(tab.icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            // Active-tab dot indicator (design shows it under the live tab).
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: active ? AppColors.brandDark : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
