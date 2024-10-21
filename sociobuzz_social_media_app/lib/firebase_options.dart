// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCZrMFU2tQeZ3ZakOUgiE134d2CovtXwrw',
    appId: '1:1072425043077:web:410d1d7bb78b8a0c4115ec',
    messagingSenderId: '1072425043077',
    projectId: 'sociobuzz-social-media-app',
    authDomain: 'sociobuzz-social-media-app.firebaseapp.com',
    storageBucket: 'sociobuzz-social-media-app.appspot.com',
    measurementId: 'G-GYMVW5GQX5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg3fXvIbIfZIavU2-XD-NkfXI2TeUhkWw',
    appId: '1:1072425043077:android:249c125e5e6929054115ec',
    messagingSenderId: '1072425043077',
    projectId: 'sociobuzz-social-media-app',
    storageBucket: 'sociobuzz-social-media-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXSrxJj9Di3oXgzKNB1IR7QWVkgj_MC1Q',
    appId: '1:1072425043077:ios:0946cbe80517933f4115ec',
    messagingSenderId: '1072425043077',
    projectId: 'sociobuzz-social-media-app',
    storageBucket: 'sociobuzz-social-media-app.appspot.com',
    iosBundleId: 'com.example.sociobuzzSocialMediaApp',
  );
}

/*

Platform  Firebase App Id
web       1:1072425043077:web:410d1d7bb78b8a0c4115ec
android   1:1072425043077:android:249c125e5e6929054115ec
ios       1:1072425043077:ios:0946cbe80517933f4115ec

*/