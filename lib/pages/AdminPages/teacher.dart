import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginpage/login.dart';
import '../loginpage/splashscreen.dart';
import 'model.dart';

class Teacher extends StatefulWidget {
  String id;
  Teacher({required this.id});
  @override
  _TeacherState createState() => _TeacherState(id: id);
}

class _TeacherState extends State<Teacher> {
  String id;
  var role;
  var emaill;
  UserModel loggedInUser = UserModel();
  bool nearbyShareActive = false; // Track if Nearby Share is active

  _TeacherState({required this.id});

  @override
  void initState() {
    super.initState();
    loadUserData();
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
      appBar: AppBar(
        title: Text(
          "Teacher",
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: loggedInUser.email != null
            ? Text("Hello ${loggedInUser.email}")
            : CircularProgressIndicator(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (!nearbyShareActive) {
                startNearbyShare(); // Start Nearby Share session
              } else {
                disposeNearbyShare(); // Dispose Nearby Share session
              }
            },
            child: Icon(nearbyShareActive ? Icons.cancel : Icons.near_me),
            // Change icon based on Nearby Share session status
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void startNearbyShare() {
    // Mock implementation to simulate starting a Nearby Share session
    // Replace this with actual Nearby Share logic
    setState(() {
      nearbyShareActive = true;
    });
    print('Nearby Share session started');
  }

  void disposeNearbyShare() {
    // Mock implementation to simulate disposing of Nearby Share session
    // Replace this with actual Nearby Share logic
    setState(() {
      nearbyShareActive = false;
    });
    print('Nearby Share session disposed');
  }

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
}
