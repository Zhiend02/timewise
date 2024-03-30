import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin.dart';
import 'model.dart';
import '../Student/student.dart';
import '../Teacher/teacher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Contro();
  }
}

class Contro extends StatefulWidget {
  @override
  _ControState createState() => _ControState();
}

class _ControState extends State<Contro> {
  UserModel loggedInUser = UserModel();
  var role;
  var emaill;
  var id;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            loggedInUser = UserModel.fromMap(value.data()!);
            emaill = loggedInUser.email;
            role = loggedInUser.role;
            id = loggedInUser.uid;

          });
        }
      });
    }
  }

  Widget routing() {
    if (role == 'Student') {
      return Student(id: id);
    } else if (role == 'Admin') {
      return Admin(id: id);
    } else {
      return Teacher(id: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: role == null
            ? CircularProgressIndicator()
            : routing(),
      ),
    );
  }
}
