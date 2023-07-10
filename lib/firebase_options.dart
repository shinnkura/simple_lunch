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
        return macos;
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
    apiKey: 'AIzaSyAlijVyeePDSJ5SCBr6U_KPQCb88acQupQ',
    appId: '1:850490052990:web:dca858b6cf6f2cd855232f',
    messagingSenderId: '850490052990',
    projectId: 'simple-lunch-dda25',
    authDomain: 'simple-lunch-dda25.firebaseapp.com',
    storageBucket: 'simple-lunch-dda25.appspot.com',
    measurementId: 'G-XZ43Q5G3KC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfapxQXAXapGWFGHp_-UpD_wbn2Mq3cBE',
    appId: '1:850490052990:android:8a0570e28e06132155232f',
    messagingSenderId: '850490052990',
    projectId: 'simple-lunch-dda25',
    storageBucket: 'simple-lunch-dda25.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDX8pcIZuhUoMpDnbwSbwyBEEtG99Vbhpc',
    appId: '1:850490052990:ios:170e1fdcc709b38f55232f',
    messagingSenderId: '850490052990',
    projectId: 'simple-lunch-dda25',
    storageBucket: 'simple-lunch-dda25.appspot.com',
    iosClientId: '850490052990-q9uuc3f8p72fv8m9ae516kh53qp39mdl.apps.googleusercontent.com',
    iosBundleId: 'com.example.simpleLunch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDX8pcIZuhUoMpDnbwSbwyBEEtG99Vbhpc',
    appId: '1:850490052990:ios:1f6bd682c7a02d2b55232f',
    messagingSenderId: '850490052990',
    projectId: 'simple-lunch-dda25',
    storageBucket: 'simple-lunch-dda25.appspot.com',
    iosClientId: '850490052990-6fsuk56kkb115epdfd7mm0007s9avkrs.apps.googleusercontent.com',
    iosBundleId: 'com.example.simpleLunch.RunnerTests',
  );
}
