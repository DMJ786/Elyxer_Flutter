/// MomentsScreen — the "Moments" tab: a social feed of candid posts. Users
/// share their own moments and react to others' with a vibe / invite / report.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/discovery_models.dart';
import '../../models/moment_models.dart';
import '../../providers/moments_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';
import '../discovery/popups/discovery_popups.dart';
import 'moment_popups.dart';
import 'widgets/moment_widgets.dart';

class MomentsScreen extends ConsumerWidget {
  const MomentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Moment>> feed = ref.watch(momentsFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: const AppBottomNav(active: AppTab.moments),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x5, AppSpacing.x4, AppSpacing.x5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Moments',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.interactive500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Let people connect with your moments',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.interactive300,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  ShareMomentBar(
                    onTap: () => context.push('/share-moment'),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                ],
              ),
            ),
            Expanded(
              child: feed.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (Object e, _) => Center(child: Text('$e')),
                data: (List<Moment> moments) => moments.isEmpty
                    ? const MomentsEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.x5, 0, AppSpacing.x5, AppSpacing.x6),
                        itemCount: moments.length,
                        itemBuilder: (_, int i) => MomentCard(
                          moment: moments[i],
                          onAction: (MomentMenuAction a) =>
                              _handleAction(context, ref, moments[i], a),
                          onTapAuthor: () => context.push(
                            '/moment-author',
                            extra: moments[i].author,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    Moment moment,
    MomentMenuAction action,
  ) async {
    final MomentsFeed feed = ref.read(momentsFeedProvider.notifier);
    switch (action) {
      case MomentMenuAction.edit:
        context.push('/share-moment', extra: moment);
      case MomentMenuAction.delete:
        final bool? ok = await showDeleteMomentDialog(context);
        if (ok == true) await feed.delete(moment.id);
      case MomentMenuAction.vibe:
        final VibeSheetResult? r = await showSendVibeSheet(
          context,
          vibeContext: VibeContext.picture,
          labelOverride: 'Moments',
        );
        if (r == null || !context.mounted) return;
        if (r.outcome == VibeSheetOutcome.switchToInvite) {
          await _sendInvite(context);
        } else {
          showVibeSentToast(context);
        }
      case MomentMenuAction.invite:
        await _sendInvite(context);
      case MomentMenuAction.report:
        final ReasonSheetResult? r = await showReportSheet(context);
        if (r != null && context.mounted) await showReportSubmittedDialog(context);
    }
  }

  Future<void> _sendInvite(BuildContext context) async {
    final InviteSheetResult? r = await showSendInviteSheet(context);
    if (r != null && context.mounted) showInviteSentToast(context);
  }
}
