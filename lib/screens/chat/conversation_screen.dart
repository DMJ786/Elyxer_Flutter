/// ConversationScreen — the 1:1 message thread (Figma 8985:18421).
///
/// Header (back · avatar · name+badge · Virtual Date Room · menu) over a
/// scrolling message list (text bubbles, Virtual Date invite cards, system
/// lines, partner typing bubble) and the composer. Reads live streams from
/// [ChatRepository]; sending goes back through it. Marks the channel read on
/// open and pings typing as the user composes.
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

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({
    super.key,
    required this.channel,
    this.meId = Env.chatUserId,
  });

  final ChatChannel channel;
  final String meId;

  @override
  ConsumerState<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _scroll = ScrollController();

  String get _url => widget.channel.url;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(chatRepositoryProvider).markRead(_url),
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _send(String text) {
    ref.read(chatRepositoryProvider).sendText(_url, text);
    _scrollToBottomSoon();
  }

  void _scrollToBottomSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(channelMessagesProvider(_url));
    final typing = ref.watch(partnerTypingProvider(_url)).value ?? false;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _ConversationHeader(user: widget.channel.otherUser),
            const Divider(height: 1, color: AppColors.interactive100),
            Expanded(
              child: messagesAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (messages) {
                  _scrollToBottomSoon();
                  return _MessageList(
                    scroll: _scroll,
                    messages: messages,
                    meId: widget.meId,
                    typing: typing,
                  );
                },
              ),
            ),
            ChatInputBar(
              onSend: _send,
              onChanged: (v) {
                final repo = ref.read(chatRepositoryProvider);
                if (v.trim().isEmpty) {
                  repo.stopTyping(_url);
                } else {
                  repo.startTyping(_url);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.scroll,
    required this.messages,
    required this.meId,
    required this.typing,
  });

  final ScrollController scroll;
  final List<ChatMessage> messages;
  final String meId;
  final bool typing;

  @override
  Widget build(BuildContext context) {
    // itemCount = optional "Today" divider + messages + optional typing row.
    final children = <Widget>[
      const _DateDivider(label: 'Today'),
      for (final m in messages) _messageWidget(m),
      if (typing)
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: TypingBubble(),
          ),
        ),
    ];

    return ListView(
      controller: scroll,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4, vertical: AppSpacing.x3),
      children: children,
    );
  }

  Widget _messageWidget(ChatMessage m) {
    switch (m.type) {
      case ChatMessageType.system:
        return SystemMessageChip(text: m.text);
      case ChatMessageType.virtualDateInvite:
        return Align(
          alignment: m.isMine(meId)
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
            child: VirtualDateInviteCard(data: m.data ?? const {}),
          ),
        );
      case ChatMessageType.text:
        return Align(
          alignment: m.isMine(meId)
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: MessageBubble(message: m, isMine: m.isMine(meId)),
        );
    }
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.interactive100),
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.interactive300,
          ),
        ),
      ),
    );
  }
}

class _ConversationHeader extends StatelessWidget {
  const _ConversationHeader({required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3, vertical: AppSpacing.x2),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            color: AppColors.interactive500,
          ),
          _HeaderAvatar(user: user),
          const SizedBox(width: AppSpacing.x2),
          Row(
            children: [
              Text(
                user.name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.interactive500,
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified, size: 11, color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
          _VirtualDateRoomButton(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
            color: AppColors.interactive500,
          ),
        ],
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.brandLight, width: 1.5),
        color: AppColors.interactive50,
        image: user.avatarUrl != null
            ? DecorationImage(
                image: NetworkImage(user.avatarUrl!), fit: BoxFit.cover)
            : null,
      ),
      alignment: Alignment.center,
      child: user.avatarUrl == null
          ? Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.brandDark,
              ),
            )
          : null,
    );
  }
}

class _VirtualDateRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: const Icon(Icons.videocam, size: 20, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          'Virtual Date Room',
          style: GoogleFonts.inter(
            fontSize: 9,
            color: AppColors.brandDark,
          ),
        ),
      ],
    );
  }
}
