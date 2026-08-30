/// ProfilePreviewScreen — view a sender's profile and respond to their vibe or
/// invite. Reuses the Discovery section widgets for the profile body, with a
/// header naming what they reacted to and a bottom Pass/Vibe-back (vibe) or
/// Decline/Accept (invite) bar.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/config/env.dart';
import '../../models/chat_models.dart';
import '../../models/discovery_models.dart';
import '../../models/interest_models.dart';
import '../../providers/chat_provider.dart';
import '../../providers/interests_provider.dart';
import '../../theme/app_theme.dart';
import '../discovery/widgets/discovery_widgets.dart';
import 'interests_popups.dart';

class ProfilePreviewScreen extends ConsumerWidget {
  const ProfilePreviewScreen.vibe(ReceivedVibe this.vibe, {super.key})
      : invite = null;
  const ProfilePreviewScreen.invite(ReceivedInvite this.invite, {super.key})
      : vibe = null;

  final ReceivedVibe? vibe;
  final ReceivedInvite? invite;

  bool get _isVibe => vibe != null;
  DiscoveryProfile get _profile => vibe?.from ?? invite!.from;

  String get _subtitle => _isVibe
      ? 'Vibed on your ${vibe!.context.label}'
      : 'Invited you for ${invite!.type.label}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DiscoveryProfile p = _profile;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            _Header(name: p.name, subtitle: _subtitle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x5, AppSpacing.x2, AppSpacing.x5, AppSpacing.x4),
                children: <Widget>[
                  ProfilePhotoCard(
                    imageUrl: p.photos.isNotEmpty ? p.photos.first : '',
                    profile: p,
                    onVibe: () => _primary(context, ref),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  MyStorySection(
                    story: p.myStory,
                    onVibe: () => _primary(context, ref),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  AboutTabsCard(profile: p),
                  if (p.interests.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.x4),
                    InterestsSection(
                      interests: p.interests,
                      onVibe: () => _primary(context, ref),
                    ),
                  ],
                  if (p.joinMeFor.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.x4),
                    JoinMeForSection(
                      options: p.joinMeFor,
                      onVibe: () => _primary(context, ref),
                    ),
                  ],
                ],
              ),
            ),
            _ResponseBar(
              isVibe: _isVibe,
              onSecondary: () => _secondary(context, ref),
              onPrimary: () => _primary(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _primary(BuildContext context, WidgetRef ref) async {
    final Interests notifier = ref.read(interestsProvider.notifier);
    final DiscoveryProfile profile = _profile;
    bool? chatNow;
    if (_isVibe) {
      await notifier.vibeBack(vibe!.id);
      if (!context.mounted) return;
      chatNow = await showMutualVibeDialog(context, profile.name);
    } else {
      await notifier.acceptInvite(invite!.id);
      if (!context.mounted) return;
      chatNow = await showInviteAcceptedDialog(context, profile.name);
    }
    if (!context.mounted) return;
    if (chatNow == true) {
      await _openConversation(context, ref, profile);
    } else {
      context.pop();
    }
  }

  /// Accepting a vibe/invite is where a match becomes a conversation. This is
  /// the deferred-connect MAU-billing moment — the user is entering the chat
  /// feature now — so connect here, open (or reuse) the 1:1 channel with the
  /// other member, and replace this preview with the thread.
  Future<void> _openConversation(
    BuildContext context,
    WidgetRef ref,
    DiscoveryProfile profile,
  ) async {
    await ref.read(chatSessionProvider.notifier).enterChat(Env.chatUserId);
    final ChatChannel channel = await ref
        .read(chatRepositoryProvider)
        .openOrCreateDirectChannel(profile.id);
    if (!context.mounted) return;
    context.go('/conversation', extra: channel);
  }

  Future<void> _secondary(BuildContext context, WidgetRef ref) async {
    final Interests notifier = ref.read(interestsProvider.notifier);
    final String name = _profile.name;
    if (_isVibe) {
      await notifier.passVibe(vibe!.id);
      if (context.mounted) showPassedToast(context, name);
    } else {
      await notifier.declineInvite(invite!.id);
      if (context.mounted) showDeclinedToast(context, name);
    }
    if (context.mounted) context.pop();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

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
            tooltip: 'Back',
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$name's Profile",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.interactive500,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponseBar extends StatelessWidget {
  const _ResponseBar({
    required this.isVibe,
    required this.onSecondary,
    required this.onPrimary,
  });

  final bool isVibe;
  final VoidCallback onSecondary;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.x5, AppSpacing.x3, AppSpacing.x5,
          AppSpacing.x3 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(top: BorderSide(color: AppColors.interactive100)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: onSecondary,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                side: const BorderSide(color: AppColors.interactive300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
              ),
              child: Text(
                isVibe ? 'Pass' : 'Decline',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.interactive300,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: SizedBox(
              height: 48,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onPrimary,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(isVibe ? Icons.favorite : Icons.check,
                            size: 16, color: Colors.white),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          isVibe ? 'Vibe back' : 'Accept',
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
          ),
        ],
      ),
    );
  }
}
