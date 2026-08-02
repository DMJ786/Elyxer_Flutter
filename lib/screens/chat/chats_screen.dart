/// ChatsScreen — the chat home (Figma 8644:19789).
///
/// Two stacked sections (design resolved the tabs-vs-stacked question in
/// favour of stacked): a horizontal **Connections** row and a vertical
/// **Conversations** list, each with its own empty state. Opening this screen
/// is where we lazily `connect()` to the chat backend — the deferred-connect
/// cost rule (Sendbird bills an MAU on connect).
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/config/env.dart';
import '../../models/chat_models.dart';
import '../../providers/chat_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/chat_widgets.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key, this.meId = 'me'});

  /// Current user id — Firebase UID in production. Defaults to the mock id.
  final String meId;

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  @override
  void initState() {
    super.initState();
    // Deferred connect — this is the MAU-billing moment, done only on
    // entering the chat feature, never at app launch.
    Future.microtask(
      () => ref.read(chatSessionProvider.notifier).enterChat(Env.chatUserId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(chatChannelsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x5, AppSpacing.x4, AppSpacing.x5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chats',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.interactive500,
                    ),
                  ),
                  Text(
                    'Click on a connection to start chatting',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.interactive300,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: channelsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (channels) => _ChatsBody(
                  channels: channels,
                  onOpen: (c) => context.push('/conversation', extra: c),
                ),
              ),
            ),
            const _ChatBottomNav(),
          ],
        ),
      ),
    );
  }

}

class _ChatsBody extends StatelessWidget {
  const _ChatsBody({required this.channels, required this.onOpen});

  final List<ChatChannel> channels;
  final void Function(ChatChannel) onOpen;

  @override
  Widget build(BuildContext context) {
    // Connections = everyone matched; Conversations = channels with history.
    final connections = channels.map((c) => c.otherUser).toList();
    final conversations =
        channels.where((c) => c.lastMessage != null).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x5, vertical: AppSpacing.x4),
      children: [
        ChatSectionLabel(text: 'Connections', count: connections.length),
        const SizedBox(height: AppSpacing.x3),
        if (connections.isEmpty)
          const _NoConnectionsCard()
        else
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: connections.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x3),
              itemBuilder: (_, i) => ConnectionAvatar(
                user: connections[i],
                onTap: () {
                  final ch = channels.firstWhere(
                      (c) => c.otherUser.id == connections[i].id);
                  onOpen(ch);
                },
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.x6),
        Row(
          children: [
            const ChatSectionLabel(text: 'Conversations'),
            const Spacer(),
            _FilterButton(),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        if (conversations.isEmpty)
          const _NoChatsEmptyState()
        else
          ...conversations.map(
            (c) => ConversationRow(channel: c, onTap: () => onOpen(c)),
          ),
      ],
    );
  }
}

class _NoConnectionsCard extends StatelessWidget {
  const _NoConnectionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.interactive100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.interactive50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded,
                size: 18, color: AppColors.brandDark),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No connections yet',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.interactive500,
                  ),
                ),
                Text(
                  'Vibe or invite someone from Discover',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.interactive300,
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

class _NoChatsEmptyState extends StatelessWidget {
  const _NoChatsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        children: [
          const Icon(Icons.chat_bubble_outline,
              size: 56, color: AppColors.interactive300),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'No chats yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.interactive500,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Send a Vibe or Invite to connect',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.interactive300),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            width: 180,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Discover',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

class _FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.interactive100),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: const Icon(Icons.filter_list,
          size: 18, color: AppColors.interactive400),
    );
  }
}

/// Presentational bottom nav with Chat active. Other tabs are stubs for
/// Phase A (their modules route separately).
class _ChatBottomNav extends StatelessWidget {
  const _ChatBottomNav();

  static const _items = [
    (Icons.people_outline, 'Profile'),
    (Icons.auto_awesome_outlined, 'Moments'),
    (Icons.all_inclusive, 'Discover'),
    (Icons.favorite_outline, 'Interests'),
    (Icons.chat_bubble_outline, 'Chat'),
  ];

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
        children: [
          for (final (icon, label) in _items)
            _NavItem(icon: icon, label: label, active: label == 'Chat'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.icon, required this.label, required this.active});
  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.brandDark : AppColors.interactive400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: color)),
      ],
    );
  }
}
