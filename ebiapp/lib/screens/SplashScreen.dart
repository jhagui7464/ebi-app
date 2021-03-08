import 'package:flutter/material.dart';
import 'dart:async';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, navigatetoLoginScreen);
  }

  navigatetoLoginScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFE5251E), Color(0xFF262626)],
        ),
      ),

      child: Center(
        child: Image.asset(
          'assets/images/ebi_02.png',
          height: 140,
          width: 110,
        ),
      ),
    ));
  }
}
