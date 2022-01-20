// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBrIjaD-_N2ur5cXJHmel3LCXPkgBP_3kQ',
    appId: '1:105049773821:web:60ad4c4675702af4939094',
    messagingSenderId: '105049773821',
    projectId: 'fluttershopapp-35ac4',
    authDomain: 'fluttershopapp-35ac4.firebaseapp.com',
    databaseURL: 'https://fluttershopapp-35ac4-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fluttershopapp-35ac4.appspot.com',
    measurementId: 'G-S2BFM3F4N3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnQKAoDN1Cw9bRBz8xOH1nVKpNmkyP3oo',
    appId: '1:105049773821:android:6b0b1f1e99e25b5d939094',
    messagingSenderId: '105049773821',
    projectId: 'fluttershopapp-35ac4',
    databaseURL: 'https://fluttershopapp-35ac4-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fluttershopapp-35ac4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLxIFI6Mis9Y2tNSsRz0ksU00ws2HeXD4',
    appId: '1:105049773821:ios:fb7fef95b600400b939094',
    messagingSenderId: '105049773821',
    projectId: 'fluttershopapp-35ac4',
    databaseURL: 'https://fluttershopapp-35ac4-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fluttershopapp-35ac4.appspot.com',
    iosClientId: '105049773821-j7jsnf6o86g8q5hn8c72k0e278hhdp79.apps.googleusercontent.com',
    iosBundleId: 'Y',
  );
}
