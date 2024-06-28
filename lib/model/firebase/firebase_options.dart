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
    apiKey: 'AIzaSyB5JDbAW1_fBV9ogvEecI3eBOOtFhdM5RY',
    appId: '1:1077509487710:web:e179995c9fd2b9d8f248cf',
    messagingSenderId: '1077509487710',
    projectId: 'lasttestapp-5e768',
    authDomain: 'lasttestapp-5e768.firebaseapp.com',
    storageBucket: 'lasttestapp-5e768.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDfYZvB4aSm3c19u_50KdteInWlQ9N3Ps',
    appId: '1:1077509487710:android:1937c17091c4c47bf248cf',
    messagingSenderId: '1077509487710',
    projectId: 'lasttestapp-5e768',
    storageBucket: 'lasttestapp-5e768.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFxirWiAtz-Ryfk0bXz0FdWnb5MtTb2g0',
    appId: '1:1077509487710:ios:f3208027a418ceebf248cf',
    messagingSenderId: '1077509487710',
    projectId: 'lasttestapp-5e768',
    storageBucket: 'lasttestapp-5e768.appspot.com',
    iosBundleId: 'com.example.flutterCourseProject',
  );
}
