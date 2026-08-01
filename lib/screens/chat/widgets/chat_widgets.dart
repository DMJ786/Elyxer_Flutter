/// Shared Chat-module widgets (Phase A).
///
/// Presentational only — they take plain [ChatMessage]/[ChatChannel]/[ChatUser]
/// and callbacks, no provider or repository access. Matches the Figma Chat
/// module (entry node 7143:9585).
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/chat_models.dart';
import '../../../theme/app_theme.dart';

/// Module gold used for section labels + accents (Figma `#c29240`, closest
/// on-token value is brandDark). Kept as one const so it's easy to retune.
const Color kChatGold = AppColors.brandDark;

/// Uppercase gold section header — "CONNECTIONS (3)" / "CONVERSATIONS".
class ChatSectionLabel extends StatelessWidget {
  const ChatSectionLabel({super.key, required this.text, this.count});

  final String text;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text.toUpperCase()),
          if (count != null)
            TextSpan(
              text: '  ($count)',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.interactive400,
              ),
            ),
        ],
      ),
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: kChatGold,
      ),
    );
  }
}

/// A circular avatar with a gold send badge + name — the Connections row.
class ConnectionAvatar extends StatelessWidget {
  const ConnectionAvatar({super.key, required this.user, this.onTap});

  final ChatUser user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _Avatar(user: user, size: 64),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              user.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.interactive500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One row in the Conversations list.
class ConversationRow extends StatelessWidget {
  const ConversationRow({super.key, required this.channel, this.onTap});

  final ChatChannel channel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final last = channel.lastMessage;
    final unread = channel.unreadCount > 0;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(user: channel.otherUser, size: 48),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          channel.otherUser.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.interactive500,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      const _VerifiedBadge(),
                    ],
                  ),
                  const SizedBox(height: 2),
                  _LastMessagePreview(message: last),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatChatTimestamp(channel.lastActivityAt),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: unread ? kChatGold : AppColors.interactive200,
                    fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                if (unread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: kChatGold,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LastMessagePreview extends StatelessWidget {
  const _LastMessagePreview({this.message});
  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return Text(
        'Say hello 👋',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: AppColors.interactive200,
        ),
      );
    }
    IconData? icon;
    String text;
    switch (message!.type) {
      case ChatMessageType.virtualDateInvite:
        icon = Icons.videocam_outlined;
        text = 'Virtual Date Invite';
      case ChatMessageType.system:
        icon = null;
        text = message!.text;
      case ChatMessageType.text:
        icon = null;
        text = message!.text;
    }
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 15, color: AppColors.interactive300),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.interactive300,
            ),
          ),
        ),
      ],
    );
  }
}

/// Message bubble — gold gradient when mine (right), white outlined when
/// theirs (left). Shows a status row (ticks / "Sent" / retry) for my
/// messages.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.onRetry,
  });

  final ChatMessage message;
  final bool isMine;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        gradient: isMine ? AppColors.brandGradient : null,
        color: isMine ? null : Colors.white,
        border: isMine ? null : Border.all(color: AppColors.interactive100),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.large),
          topRight: const Radius.circular(AppRadius.large),
          bottomLeft: Radius.circular(isMine ? AppRadius.large : AppRadius.small),
          bottomRight: Radius.circular(isMine ? AppRadius.small : AppRadius.large),
        ),
      ),
      child: Text(
        message.text,
        style: GoogleFonts.inter(
          fontSize: 15,
          height: 20 / 15,
          color: isMine ? Colors.white : AppColors.interactive400,
        ),
      ),
    );

    return Column(
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: bubble,
        ),
        if (isMine) MessageStatusRow(status: message.status, onRetry: onRetry),
      ],
    );
  }
}

/// Status affordance under a sent message (blocker C3): a subtle label +
/// icon that reflects sending / sent / delivered / read / failed.
class MessageStatusRow extends StatelessWidget {
  const MessageStatusRow({super.key, required this.status, this.onRetry});

  final ChatMessageStatus status;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (status == ChatMessageStatus.failed) {
      return GestureDetector(
        onTap: onRetry,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 13, color: AppColors.error),
            const SizedBox(width: 3),
            Text(
              'Failed · Tap to retry',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.error),
            ),
          ],
        ),
      );
    }

    final (String label, IconData icon, Color color) = switch (status) {
      ChatMessageStatus.sending => (
          'Sending',
          Icons.access_time,
          AppColors.interactive200
        ),
      ChatMessageStatus.sent => (
          'Sent',
          Icons.check,
          AppColors.interactive200
        ),
      ChatMessageStatus.delivered => (
          'Delivered',
          Icons.done_all,
          AppColors.interactive200
        ),
      ChatMessageStatus.read => ('Read', Icons.done_all, kChatGold),
      ChatMessageStatus.failed => ('', Icons.error, AppColors.error),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: color)),
        const SizedBox(width: 3),
        Icon(icon, size: 12, color: color),
      ],
    );
  }
}

/// Animated "•••" partner-typing bubble.
class TypingBubble extends StatefulWidget {
  const TypingBubble({super.key});

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4, vertical: AppSpacing.x3),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.interactive100),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.large),
          topRight: Radius.circular(AppRadius.large),
          bottomLeft: Radius.circular(AppRadius.small),
          bottomRight: Radius.circular(AppRadius.large),
        ),
      ),
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_c.value + i * 0.2) % 1.0;
            final opacity = 0.3 + 0.7 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.interactive300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Inline Virtual Date invite card (custom message type). Reads `state`
/// ('invited' / 'joined' / 'ended') + `invitee` from the payload.
class VirtualDateInviteCard extends StatelessWidget {
  const VirtualDateInviteCard({super.key, required this.data});

  final Map<String, Object?> data;

  @override
  Widget build(BuildContext context) {
    final invitee = (data['invitee'] as String?) ?? 'them';
    final state = (data['state'] as String?) ?? 'invited';

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.interactive50,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.interactive100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: const Icon(Icons.videocam,
                    size: 18, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Virtual Date Invite',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.interactive500,
                      ),
                    ),
                    Text(
                      'You invited $invitee to a virtual date',
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
          if (state == 'joined') ...[
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  '$invitee joined the date.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A centered system line ("Virtual date ended. Hope you had fun").
class SystemMessageChip extends StatelessWidget {
  const SystemMessageChip({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4, vertical: AppSpacing.x2),
        decoration: BoxDecoration(
          color: AppColors.interactive50,
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.interactive300,
          ),
        ),
      ),
    );
  }
}

/// The message composer bar.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    this.onChanged,
    this.enabled = true,
  });

  final ValueChanged<String> onSend;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.x4, AppSpacing.x2, AppSpacing.x4, AppSpacing.x2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.interactive100),
            borderRadius: BorderRadius.circular(AppRadius.round),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.enabled ? () {} : null,
                icon: const Icon(Icons.emoji_emotions_outlined),
                color: AppColors.interactive300,
              ),
              IconButton(
                onPressed: widget.enabled ? () {} : null,
                icon: const Icon(Icons.attach_file),
                color: AppColors.interactive300,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onChanged: (v) {
                    setState(() => _hasText = v.trim().isNotEmpty);
                    widget.onChanged?.call(v);
                  },
                  onSubmitted: (_) => _submit(),
                  style: GoogleFonts.inter(
                      fontSize: 15, color: AppColors.interactive400),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.inter(
                        fontSize: 15, color: AppColors.interactive200),
                  ),
                ),
              ),
              _SendButton(active: _hasText && widget.enabled, onTap: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.active, required this.onTap});
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: active ? AppColors.brandGradient : null,
          color: active ? null : AppColors.interactive100,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.send_rounded,
            size: 18,
            color: active ? Colors.white : AppColors.interactive200),
      ),
    );
  }
}

// --- small shared bits -------------------------------------------------------

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user, required this.size});
  final ChatUser user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
                color: AppColors.brandDark,
              ),
            )
          : null,
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.verified, size: 11, color: Colors.white),
    );
  }
}

/// Formats a conversation timestamp the way the Figma list shows it:
/// "Just now" / "10:23 pm" / "Yesterday" / "24/06/2026".
String formatChatTimestamp(DateTime? t) {
  if (t == null) return '';
  final now = DateTime.now();
  final diff = now.difference(t);
  if (diff.inMinutes < 1) return 'Just now';
  final isToday =
      t.year == now.year && t.month == now.month && t.day == now.day;
  if (isToday) {
    final h = t.hour == 0
        ? 12
        : (t.hour > 12 ? t.hour - 12 : t.hour);
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour < 12 ? 'am' : 'pm';
    return '$h:$m $ampm';
  }
  final yesterday = now.subtract(const Duration(days: 1));
  if (t.year == yesterday.year &&
      t.month == yesterday.month &&
      t.day == yesterday.day) {
    return 'Yesterday';
  }
  final d = t.day.toString().padLeft(2, '0');
  final mo = t.month.toString().padLeft(2, '0');
  return '$d/$mo/${t.year}';
}
