import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/Views/Splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDO7iJrS2zH3h2UV5nf_vhq5KwOUKsGo3Y",
          appId: "1:40596104616:android:9d20ad9442aa51602ba99d",
          messagingSenderId: "40596104616",
          projectId: "application-27598",
          storageBucket: "application-27598.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
