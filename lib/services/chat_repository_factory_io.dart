/// Native (`dart:io` available — Android / iOS) factory: the real Sendbird
/// repository. Selected by the conditional export in
/// `chat_repository_factory.dart` when `dart.library.io` is present, so the
/// Sendbird SDK (and its `dart:io` imports) never reach the web bundle.
library;

import 'chat_repository.dart';
import 'sendbird_chat_repository.dart';

ChatRepository makeChatRepository() => SendbirdChatRepository();
