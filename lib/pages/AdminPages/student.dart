import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loginpage/login.dart';
import 'model.dart';

class Student extends StatefulWidget {
  String id;
  Student({required this.id});
  @override
  _StudentState createState() => _StudentState(id: id);
}

class _StudentState extends State<Student> {
  String id;
  var role;
  var emaill;
  UserModel loggedInUser = UserModel();

  _StudentState({required this.id});
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users") //.where('uid', isEqualTo: user!.uid)
        .doc(id)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    }).whenComplete(() {
      CircularProgressIndicator();
      setState(() {
        emaill = loggedInUser.email.toString();
        role = loggedInUser.role.toString();
        id = loggedInUser.uid.toString();
      });
    });
  }

  @override
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('posts').snapshots();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student",
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

    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('isLoggedIn');
    await prefs.setBool('isLoggedIn', false);
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
