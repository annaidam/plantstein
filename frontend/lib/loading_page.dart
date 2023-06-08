//Based on:
//https://stackoverflow.com/questions/43879103/adding-a-splash-screen-to-flutter-apps

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plant_stein/main.dart';
import 'package:plant_stein/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2500), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? initScreen = prefs.getInt("initScreen");

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              initScreen == 0 || initScreen == null
                  ? const OnboardingPage()
                  : const RootPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double gifSize = screenSize.width * 0.6;
    final double loadingTextSize = screenSize.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/loading-gif.gif',
              width: gifSize * 1.2,
              height: gifSize * 1.2,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.twistingDots(
                  leftDotColor: const Color(0xFF5F725F),
                  rightDotColor: const Color(0xFFA0AFA1),
                  size: loadingTextSize * 3,
                ),
                SizedBox(width: 8),
                Text(
                  'loading',
                  textScaleFactor: loadingTextSize * 0.1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
