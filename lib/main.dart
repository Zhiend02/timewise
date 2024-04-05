
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timewise/pages/loginpage/splashscreen.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:  const FirebaseOptions(
        apiKey: "AIzaSyDMPIfBIUdBkVOLR9OLtFKl7mFwrs1skX8",
        appId: "1:100865748529:android:897d63ecba31d591312f10",
        messagingSenderId: "100865748529",
        projectId: "timewise-2058e",
        storageBucket: "timewise-2058e.appspot.com"
      )
  );

  runApp( const MyApp(),);
}
late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: const SplashScreen(),
    );
  }
}

