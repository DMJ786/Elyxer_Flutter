/// Firebase Options
///
/// ⚠️  THIS FILE CONTAINS PLACEHOLDER VALUES.
///
/// To generate real values:
///   1. Install FlutterFire CLI:
///        dart pub global activate flutterfire_cli
///   2. Create / open your Firebase project at https://console.firebase.google.com
///   3. From the project root run:
///        flutterfire configure
///   4. Select your Firebase project and the target platforms (Android, iOS, Web).
///   5. FlutterFire will overwrite this file with your real configuration.
///
/// Until then the app will throw a [FirebaseException] on startup when using
/// these placeholder values — replace them before running in production.
library;

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // -------------------------------------------------------------------------
  // Web — replace with values from Firebase console › Project settings › Web
  // -------------------------------------------------------------------------
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'TODO_WEB_API_KEY',
    appId: 'TODO_WEB_APP_ID',
    messagingSenderId: 'TODO_SENDER_ID',
    projectId: 'TODO_PROJECT_ID',
    authDomain: 'TODO_PROJECT_ID.firebaseapp.com',
    storageBucket: 'TODO_PROJECT_ID.appspot.com',
  );

  // -------------------------------------------------------------------------
  // Android — replace with values from google-services.json
  // -------------------------------------------------------------------------
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TODO_ANDROID_API_KEY',
    appId: 'TODO_ANDROID_APP_ID',
    messagingSenderId: 'TODO_SENDER_ID',
    projectId: 'TODO_PROJECT_ID',
    storageBucket: 'TODO_PROJECT_ID.appspot.com',
  );

  // -------------------------------------------------------------------------
  // iOS — replace with values from GoogleService-Info.plist
  // -------------------------------------------------------------------------
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TODO_IOS_API_KEY',
    appId: 'TODO_IOS_APP_ID',
    messagingSenderId: 'TODO_SENDER_ID',
    projectId: 'TODO_PROJECT_ID',
    storageBucket: 'TODO_PROJECT_ID.appspot.com',
    iosBundleId: 'TODO_IOS_BUNDLE_ID',
  );

  // -------------------------------------------------------------------------
  // macOS — same values as iOS typically
  // -------------------------------------------------------------------------
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'TODO_IOS_API_KEY',
    appId: 'TODO_IOS_APP_ID',
    messagingSenderId: 'TODO_SENDER_ID',
    projectId: 'TODO_PROJECT_ID',
    storageBucket: 'TODO_PROJECT_ID.appspot.com',
    iosBundleId: 'TODO_IOS_BUNDLE_ID',
  );
}
