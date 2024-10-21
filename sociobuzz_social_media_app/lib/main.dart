import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sociobuzz_social_media_app/my_app.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  /// firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ///main function
  runApp(MyApp());
}


// Authentication
// Repository
// AuthenticationRepository

/*
Platform  Firebase App Id
web       1:1072425043077:web:410d1d7bb78b8a0c4115ec
android   1:1072425043077:android:249c125e5e6929054115ec
ios       1:1072425043077:ios:0946cbe80517933f4115ec
 */
