import 'package:flutter/material.dart';
import 'package:timewise/pages/loginpage/logoutpage.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(onPressed: (){logout(context);}, child: Text("log out")),
    );
  }
}
