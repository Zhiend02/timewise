import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timewise/pages/AdminPages/home.dart';
import 'package:timewise/pages/loginpage/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEY_LOGIN = "login";

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Check login status during splash screen
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(KEY_LOGIN) ?? false;

    // Simulating data loading process
    await Future.delayed(const Duration(seconds: 5));

    if (isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
              image: DecorationImage(
              image: AssetImage('assets/images/Triple intersection.gif'),
              fit: BoxFit.fill
    ),
              ),
    ),
        ),
      ),
    );
  }
}
