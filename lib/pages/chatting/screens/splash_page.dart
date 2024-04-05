


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timewise/pages/chatting/screens/home_page.dart';
import '../../../main.dart';


class ChatSplashPage1 extends StatefulWidget {
  const ChatSplashPage1({super.key});

  @override
  State<ChatSplashPage1> createState() => _ChatSplashPageState1();
}

class _ChatSplashPageState1 extends State<ChatSplashPage1> {
  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(seconds: 5), () {

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatHomePage()));

    });
  }
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(

      //app bar
      appBar: AppBar(
      automaticallyImplyLeading: false,
      ),

      body: Stack(
        children: [
          Positioned(
              top: mq.height * .25,
              right: mq.width * .25 ,
              width: mq.width * .5,
              child: Image.network('https://cdn.dribbble.com/users/1129235/screenshots/2628920/chat__2_.gif',)),

          Positioned(
              bottom: mq.height * .15,
              width: mq.width * .9,
              child:
              const Text("   WELCOME",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40,color: Colors.blueAccent),),
          ),


        ],
      ),


    );
  }
}

