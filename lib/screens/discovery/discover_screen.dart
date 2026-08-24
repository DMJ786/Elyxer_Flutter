/// DiscoverScreen — the "Discover" tab (Figma "Discovery Page module").
///
/// A vertically-scrolling read of one member's profile: lead photo + name card,
/// then interleaved photos and info sections (My Story, About tabs, Interests,
/// Narratives, Join Me For), a Report/Block row, and the floating Pass / Invite
/// action buttons above the bottom nav. Each section carries a Vibe button that
/// opens the context-specific Send-a-Vibe popup.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/discovery_models.dart';
import '../../providers/discovery_provider.dart';
import '../../theme/app_theme.dart';
import 'popups/discovery_popups.dart';
import 'widgets/discovery_widgets.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DiscoveryDeckState> deckAsync =
        ref.watch(discoveryDeckProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: deckAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object e, _) => Center(child: Text('$e')),
          data: (DiscoveryDeckState state) => _DeckView(state: state),
        ),
      ),
    );
  }
}

class _DeckView extends ConsumerWidget {
  const _DeckView({required this.state});

  final DiscoveryDeckState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DiscoveryProfile? profile = state.current;

    return Column(
      children: <Widget>[
        DiscoveryHeader(
          canUndo: state.canUndo,
          onFilter: () => _comingSoon(context, 'Filters'),
          onMagicSearch: () => _comingSoon(context, 'Magic Search'),
          onUndo: () => ref.read(discoveryDeckProvider.notifier).undo(),
        ),
        Expanded(
          child: profile == null
              ? const _CaughtUpState()
              : Stack(
                  children: <Widget>[
                    _ProfileScroll(profile: profile),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: AppSpacing.x4,
                      child: ProfileActionButtons(
                        onPass: () =>
                            ref.read(discoveryDeckProvider.notifier).pass(),
                        onInvite: () => _handleInvite(context, ref),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _ProfileScroll extends ConsumerWidget {
  const _ProfileScroll({required this.profile});

  final DiscoveryProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> photos = profile.photos;

    // Info sections in design order, each paired with its Vibe context.
    final List<Widget> sections = <Widget>[
      MyStorySection(
        story: profile.myStory,
        onVibe: () => _handleVibe(context, ref, VibeContext.myStory),
      ),
      AboutTabsCard(profile: profile),
      if (profile.interests.isNotEmpty)
        InterestsSection(
          interests: profile.interests,
          onVibe: () => _handleVibe(context, ref, VibeContext.interests),
        ),
      if (profile.narratives.isNotEmpty)
        NarrativesSection(
          narratives: profile.narratives,
          onVibe: () => _handleVibe(context, ref, VibeContext.narrative),
        ),
      if (profile.joinMeFor.isNotEmpty)
        JoinMeForSection(
          options: profile.joinMeFor,
          onVibe: () => _handleVibe(
            context,
            ref,
            VibeContext.joinMeFor,
            joinMeForOptions: profile.joinMeFor,
          ),
        ),
    ];

    // Interleave: lead photo (with name card) → section → photo → section …
    final List<Widget> children = <Widget>[];
    int photoIdx = 0;
    if (photos.isNotEmpty) {
      children.add(
        ProfilePhotoCard(
          imageUrl: photos[0],
          profile: profile,
          onVibe: () => _handleVibe(context, ref, VibeContext.picture),
        ),
      );
      photoIdx = 1;
    }
    for (final Widget section in sections) {
      children.add(section);
      if (photoIdx < photos.length) {
        children.add(
          ProfilePhotoCard(
            imageUrl: photos[photoIdx],
            onVibe: () => _handleVibe(context, ref, VibeContext.picture),
          ),
        );
        photoIdx++;
      }
    }
    children.add(
      ReportBlockRow(
        onReport: () => _handleReport(context, ref),
        onBlock: () => _handleBlock(context, ref),
      ),
    );

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5, AppSpacing.x2, AppSpacing.x5, 96),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x4),
      itemBuilder: (_, int i) => children[i],
    );
  }
}

class _CaughtUpState extends StatelessWidget {
  const _CaughtUpState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.all_inclusive,
              size: 56, color: AppColors.interactive200),
          const SizedBox(height: AppSpacing.x4),
          Text(
            "You're all caught up",
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.interactive500,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Check back soon for new people to discover',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.interactive300,
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Action handlers ------------------------------------------------------

void _comingSoon(BuildContext context, String label) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('$label — coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
}

Future<void> _handleVibe(
  BuildContext context,
  WidgetRef ref,
  VibeContext vibeContext, {
  List<String> joinMeForOptions = const <String>[],
}) async {
  final DiscoveryDeck deck = ref.read(discoveryDeckProvider.notifier);
  final VibeSheetResult? res = await showSendVibeSheet(
    context,
    vibeContext: vibeContext,
    joinMeForOptions: joinMeForOptions,
  );
  if (res == null || !context.mounted) return;
  if (res.outcome == VibeSheetOutcome.switchToInvite) {
    await _handleInvite(context, ref);
    return;
  }
  await deck.vibe(vibeContext, joinMeForOption: res.joinMeForOption);
  if (context.mounted) showVibeSentToast(context);
}

Future<void> _handleInvite(BuildContext context, WidgetRef ref) async {
  final DiscoveryDeck deck = ref.read(discoveryDeckProvider.notifier);
  final InviteSheetResult? res = await showSendInviteSheet(context);
  if (res == null) return;
  await deck.invite(res.type, note: res.note);
  if (context.mounted) showInviteSentToast(context);
}

Future<void> _handleBlock(BuildContext context, WidgetRef ref) async {
  final DiscoveryDeck deck = ref.read(discoveryDeckProvider.notifier);
  final ReasonSheetResult? res = await showBlockSheet(context);
  if (res == null) return;
  await deck.block(BlockReason.values[res.index], details: res.details);
  if (context.mounted) await showBlockedDialog(context);
}

Future<void> _handleReport(BuildContext context, WidgetRef ref) async {
  final DiscoveryDeck deck = ref.read(discoveryDeckProvider.notifier);
  final ReasonSheetResult? res = await showReportSheet(context);
  if (res == null) return;
  await deck.report(ReportReason.values[res.index], details: res.details);
  if (context.mounted) await showReportSubmittedDialog(context);
}
