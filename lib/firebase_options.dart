// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB9l_CH7Uc2eFQZ0yF7zdGZMc5FkF0H0nk',
    appId: '1:1019454139276:web:ffbe893267e72e094ec4a9',
    messagingSenderId: '1019454139276',
    projectId: 'noristinder',
    authDomain: 'noristinder.firebaseapp.com',
    databaseURL:
        'https://noristinder-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'noristinder.appspot.com',
    measurementId: 'G-B8J5RFX49V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEnLGON6RV1Jq9FUD0x4c4DgjZMH484Dg',
    appId: '1:1019454139276:android:4864898f8d7c2aeb4ec4a9',
    messagingSenderId: '1019454139276',
    projectId: 'noristinder',
    databaseURL:
        'https://noristinder-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'noristinder.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAv9T2hN65khr_ExVT_YKHV7FVzW_21w8U',
    appId: '1:1019454139276:ios:ad2805cc49b8ab344ec4a9',
    messagingSenderId: '1019454139276',
    projectId: 'noristinder',
    databaseURL:
        'https://noristinder-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'noristinder.appspot.com',
    iosClientId:
        '1019454139276-c0i1gu2k7ut7njncvdcb1fh4jdacqbvq.apps.googleusercontent.com',
    iosBundleId: 'com.example.tinderWithChuck',
  );
}
