import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginpage/login.dart';
import '../loginpage/splashscreen.dart';



Future<void> logout(BuildContext context) async {

  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  await sharedPref.setBool(SplashScreenState.KEY_LOGIN, false);

  await FirebaseAuth.instance.signOut();

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
}

