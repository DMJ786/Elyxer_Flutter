/// Moment author preview (issue #60).
///
/// Opened by tapping the author (avatar/name) on someone else's moment. Renders
/// the author's [DiscoveryProfile] with the Discovery section widgets, and the
/// same Send-a-Vibe (per section) / Invite / Report / Block actions the
/// Discovery and Moments surfaces use.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/discovery_models.dart';
import '../../theme/app_theme.dart';
import '../discovery/popups/discovery_popups.dart';
import '../discovery/widgets/discovery_widgets.dart';

class MomentAuthorPreviewScreen extends StatelessWidget {
  const MomentAuthorPreviewScreen({super.key, required this.profile});

  final DiscoveryProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            _Header(name: profile.name),
            Expanded(child: _ProfileBody(profile: profile)),
            _InviteBar(onInvite: () => _invite(context)),
          ],
        ),
      ),
    );
  }
}

/// The scrollable profile — reuses the Discovery section widgets, interleaving
/// photos between the info sections exactly as the Discover deck does.
class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.profile});

  final DiscoveryProfile profile;

  @override
  Widget build(BuildContext context) {
    final List<String> photos = profile.photos;
    final List<Widget> sections = <Widget>[
      MyStorySection(
        story: profile.myStory,
        onVibe: () => _vibe(context, VibeContext.myStory),
      ),
      AboutTabsCard(profile: profile),
      if (profile.interests.isNotEmpty)
        InterestsSection(
          interests: profile.interests,
          onVibe: () => _vibe(context, VibeContext.interests),
        ),
      if (profile.narratives.isNotEmpty)
        NarrativesSection(
          narratives: profile.narratives,
          onVibe: () => _vibe(context, VibeContext.narrative),
        ),
      if (profile.joinMeFor.isNotEmpty)
        JoinMeForSection(
          options: profile.joinMeFor,
          onVibe: () => _vibe(
            context,
            VibeContext.joinMeFor,
            joinMeForOptions: profile.joinMeFor,
          ),
        ),
    ];

    final List<Widget> children = <Widget>[];
    int photoIdx = 0;
    if (photos.isNotEmpty) {
      children.add(
        ProfilePhotoCard(
          imageUrl: photos[0],
          profile: profile,
          onVibe: () => _vibe(context, VibeContext.picture),
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
            onVibe: () => _vibe(context, VibeContext.picture),
          ),
        );
        photoIdx++;
      }
    }
    children.add(
      ReportBlockRow(
        onReport: () => _report(context),
        onBlock: () => _block(context),
      ),
    );

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5, AppSpacing.x2, AppSpacing.x5, AppSpacing.x4),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x4),
      itemBuilder: (_, int i) => children[i],
    );
  }
}

// --- Actions (mirror the Moments card + Discovery handlers) ----------------

Future<void> _vibe(
  BuildContext context,
  VibeContext vibeContext, {
  List<String> joinMeForOptions = const <String>[],
}) async {
  final VibeSheetResult? r = await showSendVibeSheet(
    context,
    vibeContext: vibeContext,
    joinMeForOptions: joinMeForOptions,
  );
  if (r == null || !context.mounted) return;
  if (r.outcome == VibeSheetOutcome.switchToInvite) {
    await _invite(context);
    return;
  }
  showVibeSentToast(context);
}

Future<void> _invite(BuildContext context) async {
  final InviteSheetResult? r = await showSendInviteSheet(context);
  if (r != null && context.mounted) showInviteSentToast(context);
}

Future<void> _report(BuildContext context) async {
  final ReasonSheetResult? r = await showReportSheet(context);
  if (r != null && context.mounted) await showReportSubmittedDialog(context);
}

Future<void> _block(BuildContext context) async {
  final ReasonSheetResult? r = await showBlockSheet(context);
  if (r == null || !context.mounted) return;
  await showBlockedDialog(context);
  if (context.mounted) context.pop(); // leave the preview after blocking
}

class _Header extends StatelessWidget {
  const _Header({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.x3, AppSpacing.x2, AppSpacing.x5, AppSpacing.x2),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.interactive400),
          ),
          Expanded(
            child: Text(
              "$name's Profile",
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.interactive500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteBar extends StatelessWidget {
  const _InviteBar({required this.onInvite});

  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x5,
        AppSpacing.x3,
        AppSpacing.x5,
        AppSpacing.x3 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(top: BorderSide(color: AppColors.interactive100)),
      ),
      child: SizedBox(
        height: 48,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onInvite,
            child: Ink(
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.mail_outline, size: 18, color: Colors.white),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Send Invite',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
