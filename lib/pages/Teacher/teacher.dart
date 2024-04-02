import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timewise/pages/Teacher/SendMessage.dart';
import 'package:timewise/pages/Teacher/TeacherHomePage.dart';
import 'package:timewise/pages/Teacher/TeacherProfile.dart';
import 'package:timewise/pages/attendance/attendance.dart';
import 'package:timewise/pages/attendance/login.dart';
import '../attendance/client_screen.dart';
import '../loginpage/logoutpage.dart';
import '../AdminPages/model.dart';

class Teacher extends StatefulWidget {
  String id;
  Teacher({required this.id});
  @override
  _TeacherState createState() => _TeacherState(id: id);
}

class _TeacherState extends State<Teacher> {
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);
  int maxCount = 4;


  /// widget list
  final List<Widget> bottomBarPages = [
    const TeacherHomePage(),
    const SendMessage(),
    const TeacherHomePage(),
    const TeacherProfile(),
  ];

  String id;
  var role;
  var emaill;
  UserModel loggedInUser = UserModel();
  _TeacherState({required this.id});

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void loadUserData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get();
    if (docSnapshot.exists) {
      setState(() {
        loggedInUser = UserModel.fromMap(docSnapshot.data()!);
        emaill = loggedInUser.email;
        role = loggedInUser.role;
        id = loggedInUser.uid!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      // Center(
      //   child: Column(
      //     children: [
      //       ElevatedButton(
      //         onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Attendance()),);},
      //           child: const Text("Take Attendance"),),
      //
      //       ElevatedButton(
      //         onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) =>   const Login()),);},
      //         child: const Text("Take Attendance"),),
      //
      //
      //     ],
      //   ),
      //       )


        PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount) ? AnimatedNotchBottomBar(
          notchBottomBarController: _controller,
          color: Colors.white,
          showLabel: false,
          shadowElevation: 5,
          kBottomRadius: 12.0,
          notchColor: Colors.black87,

          removeMargins: true,
          bottomBarWidth: 500,
          durationInMilliSeconds: 200,
          bottomBarItems: const [

            BottomBarItem(
              inActiveItem: Icon(
                Icons.home_filled,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.home_filled,
                color: Colors.blueAccent,
              ),
              itemLabel: 'Home Page',
            ),


            BottomBarItem(
              inActiveItem: Icon(
                Icons.star,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.star,
                color: Colors.blueAccent,
              ),
              itemLabel: 'Page 2',
            ),

            ///svg example
            BottomBarItem(
              inActiveItem: Icon(
                Icons.star,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.star,
                color: Colors.blueAccent,
              ),
              itemLabel: 'Page 3',
            ),


            BottomBarItem(
              inActiveItem: Icon(
                Icons.settings,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.settings,
                color: Colors.pink,
              ),
              itemLabel: 'Page 4',
            ),


          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          kIconSize: 24.0,
        )
            : null,

            );
  }


}
















