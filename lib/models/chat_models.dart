/// Chat Models (Chat Module — Phase A)
///
/// Vendor-agnostic domain models for the chat feature. These deliberately
/// do NOT reference any Sendbird type — the UI and providers only ever see
/// these. `SendbirdChatRepository` maps Sendbird SDK objects into these;
/// `MockChatRepository` fabricates them. Swapping the backend never touches
/// the UI.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';

/// Delivery lifecycle of an outgoing/incoming message.
///
/// Maps to the Figma message-status states (blocker C3 in the design
/// review): a sent message goes sending → sent → delivered → read, or
/// sending → failed if the send throws.
enum ChatMessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed;

  bool get isPending => this == ChatMessageStatus.sending;
  bool get isFailed => this == ChatMessageStatus.failed;
}

/// What kind of payload a message carries. Text is the common case;
/// the others are Sendbird "custom message types" the UI renders as
/// inline cards / system lines instead of a plain bubble.
enum ChatMessageType {
  /// Plain user text bubble.
  text,

  /// Virtual Date invite card (customType: 'virtual_date_invite').
  virtualDateInvite,

  /// System line ("You and Asha are Connected", "Virtual date ended").
  system;

  /// The Sendbird `customType` tag on the wire. Empty for plain text.
  String get wireCustomType {
    switch (this) {
      case ChatMessageType.text:
        return '';
      case ChatMessageType.virtualDateInvite:
        return 'virtual_date_invite';
      case ChatMessageType.system:
        return 'system';
    }
  }

  static ChatMessageType fromWire(String? customType) {
    switch (customType) {
      case 'virtual_date_invite':
        return ChatMessageType.virtualDateInvite;
      case 'system':
        return ChatMessageType.system;
      default:
        return ChatMessageType.text;
    }
  }
}

/// A minimal chat participant. Name/avatar are denormalised onto the
/// channel + message so the UI never needs a second lookup.
@freezed
abstract class ChatUser with _$ChatUser {
  const factory ChatUser({
    required String id,
    required String name,
    String? avatarUrl,
    @Default(false) bool isOnline,
  }) = _ChatUser;
}

/// A single message in a conversation.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String channelUrl,
    required String senderId,
    required String text,
    required DateTime sentAt,
    @Default(ChatMessageType.text) ChatMessageType type,
    @Default(ChatMessageStatus.sent) ChatMessageStatus status,

    /// Decoded custom payload for non-text types (e.g. the Virtual Date
    /// invite's state + invitee name). Null for plain text.
    Map<String, Object?>? data,
  }) = _ChatMessage;

  const ChatMessage._();

  /// True when this message was sent by [meId] (right-aligned gold bubble).
  bool isMine(String meId) => senderId == meId;
}

/// A 1:1 conversation, as shown in the ChatsScreen list and opened in
/// the ConversationScreen.
@freezed
abstract class ChatChannel with _$ChatChannel {
  const factory ChatChannel({
    /// Sendbird channel URL — the stable id for the conversation.
    required String url,
    required ChatUser otherUser,
    ChatMessage? lastMessage,
    @Default(0) int unreadCount,
    DateTime? lastActivityAt,
  }) = _ChatChannel;
}

/// Connection lifecycle of the chat backend. The UI shows a subtle banner
/// on [connecting]/[reconnecting] and gates sending on [connected].
enum ChatConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting;

  bool get canSend => this == ChatConnectionState.connected;
}
