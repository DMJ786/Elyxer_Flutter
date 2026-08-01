/// Platform-selected [ChatRepository] factory.
///
/// Exposes `makeChatRepository()` which returns the real Sendbird repository
/// on Android/iOS and the in-memory mock on web — chosen at compile time via
/// the conditional export below so the Sendbird SDK (which imports `dart:io`)
/// is never compiled into the web bundle.
library;

export 'chat_repository_factory_stub.dart'
    if (dart.library.io) 'chat_repository_factory_io.dart';
