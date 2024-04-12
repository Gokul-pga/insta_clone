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
    apiKey: 'AIzaSyDK8pGj_kmtu8D5UAvu4xa9pijKaKuUgWE',
    appId: '1:1048279876632:web:a0d54fc76df19e5adfef6d',
    messagingSenderId: '1048279876632',
    projectId: 'insta-clone-flutter-3a416',
    authDomain: 'insta-clone-flutter-3a416.firebaseapp.com',
    databaseURL: 'https://insta-clone-flutter-3a416-default-rtdb.firebaseio.com',
    storageBucket: 'insta-clone-flutter-3a416.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAplmjzWrwqlKN4v_Gg9JXsUufsd-cvf64',
    appId: '1:1048279876632:android:ab30613f904f3ca6dfef6d',
    messagingSenderId: '1048279876632',
    projectId: 'insta-clone-flutter-3a416',
    databaseURL: 'https://insta-clone-flutter-3a416-default-rtdb.firebaseio.com',
    storageBucket: 'insta-clone-flutter-3a416.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAssLzW8gXpgGun9ODC_AVqq_Nci-MPINI',
    appId: '1:1048279876632:ios:af3eb9c8362afc87dfef6d',
    messagingSenderId: '1048279876632',
    projectId: 'insta-clone-flutter-3a416',
    databaseURL: 'https://insta-clone-flutter-3a416-default-rtdb.firebaseio.com',
    storageBucket: 'insta-clone-flutter-3a416.appspot.com',
    iosBundleId: 'com.example.instaClone',
  );
}