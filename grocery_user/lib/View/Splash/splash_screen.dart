import 'dart:async';
import 'package:flutter/material.dart';

import '../OnBoarding/on_boardin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement i nitState

    Timer(
      Duration(milliseconds: 3000),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnBoardingScreen(),
            ));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.green.shade800,
        child: Center(
          child: Image(image: AssetImage("assets/images/splash.png")),
        ),
      ),
    );
  }
}
