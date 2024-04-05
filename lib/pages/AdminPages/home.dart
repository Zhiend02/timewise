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
  List<String> studentNames = [];
  UserModel loggedInUser = UserModel();
  var role;
  var emaill;
  var id;
  int rollNo = 1;

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
    fetchAndPrintStudentNames();
  }
  Future<void> fetchAndPrintStudentNames() async {
    QuerySnapshot studentsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastName')
        .orderBy('firstName')
        .orderBy('middleName')
        .get();

    if (studentsSnapshot.docs.isNotEmpty) {
      List<String> students = [];
      List<String> studentListWithRollNo = [];

      for (var user in studentsSnapshot.docs) {
        var role = user['role'];
        if (role == 'Student') {
          var userId = user.id;
          var userData = user.data() as Map<String, dynamic>;
          if (userData.containsKey('rollNo')) {
            // If 'rollNo' field exists, update it
            print('Updating rollNo for user: $userId');
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'rollNo': rollNo})
                .then((_) => print('RollNo updated for user: $userId'))
                .catchError((error) => print('Error updating rollNo: $error'));
          }
          var lastName = user['lastName'];
          var firstName = user['firstName'];
          var middleName = user['middleName'];
          var fullName = '$lastName $firstName $middleName';
          students.add(fullName);
          studentListWithRollNo.add('$rollNo. $fullName');
          rollNo++;
        }
      }

      setState(() {
        studentNames = students;
      });

      // Print the sorted list of student names
      studentNames.forEach((name) => print(name));
      // Print the sorted list of student names with roll numbers
      studentListWithRollNo.forEach((name) => print(name));

      // Trigger a rebuild to update the UI with the student list
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

// anme printing perfect