
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timewise/pages/AdminPages/StudentListPage.dart';
import 'package:timewise/pages/loginpage/register.dart';
import '../loginpage/logoutpage.dart';
import 'model.dart';

class Admin extends StatefulWidget {
  String id;
  Admin({required this.id});
  @override
  _AdminState createState() => _AdminState(id: id);
}

class _AdminState extends State<Admin> {
  String id;
  var role;
  var emaill;
  UserModel loggedInUser = UserModel();

  _AdminState({required this.id});
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
      const CircularProgressIndicator();
      setState(() {
        emaill = loggedInUser.email.toString();
        role = loggedInUser.role.toString();
        id = loggedInUser.uid.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin",
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      
      body: Container(
        color: Colors.blue,
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentListPage(),));},

                child: const Text("student list")),

            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Register(),));},

                child: const Text("Add Students/teacher")),

          ],
        ),



      ),
    );
  }


}
