// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The active repository impl. Mock today; Sendbird next.
///
/// keepAlive because the connection + channel handlers must outlive any
/// single screen. Disposed explicitly when the user leaves the chat feature.

@ProviderFor(chatRepository)
const chatRepositoryProvider = ChatRepositoryProvider._();

/// The active repository impl. Mock today; Sendbird next.
///
/// keepAlive because the connection + channel handlers must outlive any
/// single screen. Disposed explicitly when the user leaves the chat feature.

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  /// The active repository impl. Mock today; Sendbird next.
  ///
  /// keepAlive because the connection + channel handlers must outlive any
  /// single screen. Disposed explicitly when the user leaves the chat feature.
  const ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'91dcdd977054dc57a77993f1eaca54743710f51f';

/// Drives the deferred connect/disconnect that controls Sendbird MAU + PCC
/// billing. Call `enterChat(userId)` when the user opens the chat feature
/// (and only if matched), `leaveChat()` when they leave / background.
///
/// **Do not call this at app launch or login** — connecting bills a MAU.

@ProviderFor(ChatSession)
const chatSessionProvider = ChatSessionProvider._();

/// Drives the deferred connect/disconnect that controls Sendbird MAU + PCC
/// billing. Call `enterChat(userId)` when the user opens the chat feature
/// (and only if matched), `leaveChat()` when they leave / background.
///
/// **Do not call this at app launch or login** — connecting bills a MAU.
final class ChatSessionProvider
    extends $NotifierProvider<ChatSession, ChatConnectionState> {
  /// Drives the deferred connect/disconnect that controls Sendbird MAU + PCC
  /// billing. Call `enterChat(userId)` when the user opens the chat feature
  /// (and only if matched), `leaveChat()` when they leave / background.
  ///
  /// **Do not call this at app launch or login** — connecting bills a MAU.
  const ChatSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionHash();

  @$internal
  @override
  ChatSession create() => ChatSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatConnectionState>(value),
    );
  }
}

String _$chatSessionHash() => r'aa1a3628f6667011c5936478b30d31e983115323';

/// Drives the deferred connect/disconnect that controls Sendbird MAU + PCC
/// billing. Call `enterChat(userId)` when the user opens the chat feature
/// (and only if matched), `leaveChat()` when they leave / background.
///
/// **Do not call this at app launch or login** — connecting bills a MAU.

abstract class _$ChatSession extends $Notifier<ChatConnectionState> {
  ChatConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatConnectionState, ChatConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatConnectionState, ChatConnectionState>,
              ChatConnectionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Live conversation list for the ChatsScreen.

@ProviderFor(chatChannels)
const chatChannelsProvider = ChatChannelsProvider._();

/// Live conversation list for the ChatsScreen.

final class ChatChannelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatChannel>>,
          List<ChatChannel>,
          Stream<List<ChatChannel>>
        >
    with
        $FutureModifier<List<ChatChannel>>,
        $StreamProvider<List<ChatChannel>> {
  /// Live conversation list for the ChatsScreen.
  const ChatChannelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatChannelsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatChannelsHash();

  @$internal
  @override
  $StreamProviderElement<List<ChatChannel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatChannel>> create(Ref ref) {
    return chatChannels(ref);
  }
}

String _$chatChannelsHash() => r'2f171747e1b332a4f29c27a1b867f33d78150db1';

/// Live message history for one conversation.

@ProviderFor(channelMessages)
const channelMessagesProvider = ChannelMessagesFamily._();

/// Live message history for one conversation.

final class ChannelMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          Stream<List<ChatMessage>>
        >
    with
        $FutureModifier<List<ChatMessage>>,
        $StreamProvider<List<ChatMessage>> {
  /// Live message history for one conversation.
  const ChannelMessagesProvider._({
    required ChannelMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'channelMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$channelMessagesHash();

  @override
  String toString() {
    return r'channelMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatMessage>> create(Ref ref) {
    final argument = this.argument as String;
    return channelMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$channelMessagesHash() => r'fe4a66296274d3c2953c53b700fd3f6307e62407';

/// Live message history for one conversation.

final class ChannelMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChatMessage>>, String> {
  const ChannelMessagesFamily._()
    : super(
        retry: null,
        name: r'channelMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live message history for one conversation.

  ChannelMessagesProvider call(String channelUrl) =>
      ChannelMessagesProvider._(argument: channelUrl, from: this);

  @override
  String toString() => r'channelMessagesProvider';
}

/// Whether the partner is typing in a conversation (drives the `•••` bubble).

@ProviderFor(partnerTyping)
const partnerTypingProvider = PartnerTypingFamily._();

/// Whether the partner is typing in a conversation (drives the `•••` bubble).

final class PartnerTypingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Whether the partner is typing in a conversation (drives the `•••` bubble).
  const PartnerTypingProvider._({
    required PartnerTypingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'partnerTypingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$partnerTypingHash();

  @override
  String toString() {
    return r'partnerTypingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as String;
    return partnerTyping(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PartnerTypingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$partnerTypingHash() => r'5994d4436245dc8c5b85a01c501cb2ab93189079';

/// Whether the partner is typing in a conversation (drives the `•••` bubble).

final class PartnerTypingFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, String> {
  const PartnerTypingFamily._()
    : super(
        retry: null,
        name: r'partnerTypingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether the partner is typing in a conversation (drives the `•••` bubble).

  PartnerTypingProvider call(String channelUrl) =>
      PartnerTypingProvider._(argument: channelUrl, from: this);

  @override
  String toString() => r'partnerTypingProvider';
}
