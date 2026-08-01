/// Web / no-`dart:io` fallback: the Sendbird Flutter SDK is Android/iOS-native
/// and pulls in `dart:io`, so on web we use the in-memory mock (keeps the
/// design-review web flow working). Selected by the conditional export in
/// `chat_repository_factory.dart` when `dart.library.io` is unavailable.
library;

import 'chat_repository.dart';

ChatRepository makeChatRepository() => MockChatRepository();
