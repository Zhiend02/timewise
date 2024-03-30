import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage.student({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Student Home Page"),
      ),
    );
  }
}
