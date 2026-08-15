/// InterestsScreen — the "Interests" tab: vibes & invites other members sent
/// you, with a freemium paywall (free users see the list gated) and per-tab
/// empty states. Tapping a card opens the sender's profile to respond.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/interest_models.dart';
import '../../providers/interests_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';
import 'widgets/interest_widgets.dart';

class InterestsScreen extends ConsumerWidget {
  const InterestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<InterestsState> async = ref.watch(interestsProvider);
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: const AppBottomNav(active: AppTab.interests),
      body: SafeArea(
        bottom: false,
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object e, _) => Center(child: Text('$e')),
          data: (InterestsState state) => _Body(state: state),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.state});

  final InterestsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Interests notifier = ref.read(interestsProvider.notifier);
    final bool isVibes = state.tab == InterestsTab.vibes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.x5, AppSpacing.x4, AppSpacing.x5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Interests',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.interactive500,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'People who showed interest in you',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.interactive300,
                ),
              ),
              const SizedBox(height: AppSpacing.x5),
              InterestsTabToggle(
                tab: state.tab,
                onChanged: notifier.setTab,
              ),
              const SizedBox(height: AppSpacing.x5),
              InterestCountChip(
                label: isVibes ? 'Vibes' : 'Invites',
                count: isVibes ? state.vibeCount : state.inviteCount,
              ),
              const SizedBox(height: AppSpacing.x3),
            ],
          ),
        ),
        Expanded(
          child: isVibes ? _VibesList(state: state) : _InvitesList(state: state),
        ),
      ],
    );
  }
}

class _VibesList extends StatelessWidget {
  const _VibesList({required this.state});

  final InterestsState state;

  @override
  Widget build(BuildContext context) {
    if (state.vibes.isEmpty) {
      return InterestsEmptyState(
        tab: InterestsTab.vibes,
        onEditProfile: () => context.go('/profile-home'),
      );
    }
    return _GatedList(
      isPremium: state.isPremium,
      itemCount: state.vibes.length,
      builder: (int i) => ReceivedVibeCard(
        vibe: state.vibes[i],
        onTap: () => context.push('/interest-vibe', extra: state.vibes[i]),
      ),
    );
  }
}

class _InvitesList extends StatelessWidget {
  const _InvitesList({required this.state});

  final InterestsState state;

  @override
  Widget build(BuildContext context) {
    if (state.invites.isEmpty) {
      return InterestsEmptyState(
        tab: InterestsTab.invites,
        onEditProfile: () => context.go('/profile-home'),
      );
    }
    return _GatedList(
      isPremium: state.isPremium,
      itemCount: state.invites.length,
      builder: (int i) => ReceivedInviteCard(
        invite: state.invites[i],
        onTap: () => context.push('/interest-invite', extra: state.invites[i]),
      ),
    );
  }
}

/// Renders a card list, blurring everything past the first card for free users
/// and appending an unlock CTA.
class _GatedList extends StatelessWidget {
  const _GatedList({
    required this.isPremium,
    required this.itemCount,
    required this.builder,
  });

  final bool isPremium;
  final int itemCount;
  final Widget Function(int) builder;

  @override
  Widget build(BuildContext context) {
    final bool gated = !isPremium && itemCount > 1;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5, AppSpacing.x2, AppSpacing.x5, AppSpacing.x6),
      children: <Widget>[
        for (int i = 0; i < itemCount; i++) ...<Widget>[
          if (i != 0) const SizedBox(height: AppSpacing.x4),
          IgnorePointer(
            ignoring: gated && i > 0,
            child: PaywallBlur(blurred: gated && i > 0, child: builder(i)),
          ),
        ],
        if (gated) ...<Widget>[
          const SizedBox(height: AppSpacing.x5),
          UnlockBanner(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Premium — coming soon'),
                duration: Duration(seconds: 2),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
