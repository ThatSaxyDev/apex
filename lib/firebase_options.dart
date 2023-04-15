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
    apiKey: 'AIzaSyBWbB_dxXdbO77x3NjD4bYrlyZaIMTYcdA',
    appId: '1:951556008439:web:0f962ce817b41791caa6f2',
    messagingSenderId: '951556008439',
    projectId: 'apex-42f28',
    authDomain: 'apex-42f28.firebaseapp.com',
    storageBucket: 'apex-42f28.appspot.com',
    measurementId: 'G-8JQY7F5GP6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3Gkp5zOTtK-iJTx4LSqyH_Px5v5vUqkk',
    appId: '1:951556008439:android:7adf7c7a5ecd18a1caa6f2',
    messagingSenderId: '951556008439',
    projectId: 'apex-42f28',
    storageBucket: 'apex-42f28.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqYJlSe4uVqzcLfXS-ML8OTRnbEFrs_PI',
    appId: '1:951556008439:ios:bdf4c37fc50f6bf9caa6f2',
    messagingSenderId: '951556008439',
    projectId: 'apex-42f28',
    storageBucket: 'apex-42f28.appspot.com',
    iosClientId: '951556008439-f3411mro43dl3onkqci1610ftjnfvrha.apps.googleusercontent.com',
    iosBundleId: 'dev.kiishidart.apex',
  );
}
