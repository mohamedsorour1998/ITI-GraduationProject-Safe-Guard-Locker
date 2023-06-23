// Displays the splash screen for 5 seconds before navigating to the main page.
import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/locker.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}