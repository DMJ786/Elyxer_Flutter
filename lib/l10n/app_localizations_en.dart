// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Elyxer';

  @override
  String get verificationCompleteTitle => 'Verification Complete!';

  @override
  String get verificationCompleteBody =>
      'Your account has been successfully verified. You can now enjoy all features of the app.';

  @override
  String get momentsTitle => 'Moments';

  @override
  String get momentsSubtitle => 'Let people connect with your moments';

  @override
  String get interestsTitle => 'Interests';

  @override
  String get interestsSubtitle => 'People who showed interest in you';

  @override
  String get chatsTitle => 'Chats';

  @override
  String get chatsSubtitle => 'Click on a connection to start chatting';

  @override
  String get discoverMagicSearch => 'Magic Search';
}
