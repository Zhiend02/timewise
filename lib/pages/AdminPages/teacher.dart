import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timewise/pages/attendance/attendance.dart';
import '../loginpage/logoutpage.dart';
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
        title: Text("Teacher",),
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
        child: ElevatedButton(
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Attendance()),);},
            child: const Text("Take Attendance"),),
            ),
            );
  }


}