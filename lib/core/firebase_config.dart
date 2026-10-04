import 'package:firebase_core/firebase_core.dart';

/// Firebase client configuration is public. Never put service account keys here.
abstract final class FirebaseConfig {
  static const configured =
      String.fromEnvironment('FIREBASE_API_KEY') != '' &&
      String.fromEnvironment('FIREBASE_APP_ID') != '' &&
      String.fromEnvironment('FIREBASE_PROJECT_ID') != '' &&
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID') != '';

  static const options = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID'),
  );
}
