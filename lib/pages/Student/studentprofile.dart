import 'package:flutter/material.dart';
import 'package:timewise/pages/attendance/loginclient.dart';
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
      body: Column(
        children: [
          ElevatedButton(onPressed: (){logout(context);}, child: Text("log out")),
          ElevatedButton(
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) =>   const Loginc()),);},
            child: const Text("mark Attendance"),),
        ],
      ),
      
    );
  }
}
