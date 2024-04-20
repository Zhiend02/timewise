import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timewise/pages/Student/calender.dart';
import 'package:timewise/pages/Teacher/TeacherHomePage.dart';
import 'package:timewise/pages/Teacher/TeacherProfile.dart';
import 'package:timewise/pages/chatting/screens/splash_page.dart';

import '../AdminPages/model.dart';
import '../calender/screens/home_page.dart';

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
    const ChatSplashPage1(),
    const CalenderHomePage(),
    const TeacherProfile(),
  ];

  final List<String> pageTitles = ['Home Page', 'Message', 'Calender', 'Profile'];
  String appBarTitle = 'Home Page';

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
      backgroundColor: CupertinoColors.systemGrey4,
      appBar: PreferredSize(
            preferredSize:const Size.fromHeight(kToolbarHeight + 15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:[
                        Color.fromRGBO(9, 198, 249, 1),
                        Color.fromRGBO(4, 93, 233, 1)
                      ]
                  )
              ),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                 title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0,left: 8.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          // Navigate to the home page or perform any action on arrow button press
                          _pageController.jumpToPage(0); // Go to the home page
                          setState(() {
                            appBarTitle = pageTitles[0]; // Update app bar title to Home Page
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0, right: 8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                            child: Text(appBarTitle,
                            textAlign:TextAlign.start ,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                                 ],
                      ),
                    ),
            ),
          ),


      body: PageView(
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
          bottomBarItems:  [

            BottomBarItem(
              inActiveItem: const Icon(
                Icons.home_filled,
                color: Colors.blueGrey,
              ),
              activeItem: const Icon(
                Icons.home_filled,
                color: Colors.blueAccent,
              ),
              itemLabel: pageTitles[0],
            ),


            BottomBarItem(
              inActiveItem: const Icon(
                Icons.send_and_archive,
                color: Colors.blueGrey,
              ),
              activeItem: const Icon(
                Icons.send_and_archive,
                color: Colors.blueAccent,
              ),
              itemLabel: pageTitles[1],
            ),

            ///svg example
            BottomBarItem(
              inActiveItem: const Icon(
                Icons.calendar_month,
                color: Colors.blueGrey,
              ),
              activeItem: const Icon(
                Icons.calendar_month,
                color: Colors.blueAccent,
              ),
              itemLabel: pageTitles[2],
            ),


            BottomBarItem(
              inActiveItem: const Icon(
                Icons.person,
                color: Colors.blueGrey,
              ),
              activeItem: const Icon(
                Icons.person,
                color: Colors.blueAccent,
              ),
              itemLabel: pageTitles[3],
            ),



          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
            setState(() {
              appBarTitle = pageTitles[index];
            });
          },
          kIconSize: 24.0,
        )
            : null,

            );
  }


}
















