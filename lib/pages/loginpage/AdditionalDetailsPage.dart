import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timewise/pages/loginpage/register.dart';

class AdditionalDetailsPage extends StatefulWidget {
  final String userId;

  AdditionalDetailsPage(this.userId);

  @override
  _AdditionalDetailsPageState createState() => _AdditionalDetailsPageState();
}

class _AdditionalDetailsPageState extends State<AdditionalDetailsPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Details'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(9, 198, 249, 1),
                Color.fromRGBO(4, 93, 233, 1),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: CupertinoColors.systemGrey5,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: rollNoController,
              decoration: InputDecoration(labelText: 'Roll No'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: middleNameController,
              decoration: InputDecoration(labelText: 'Middle Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateDetails();
              },
              child: Text('Save Details'),
            ),
          ],
        ),
      ),
    );
  }

  void updateDetails() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // Get user ID
    String userId = widget.userId;

    // Convert to lowercase
    String rollNo = rollNoController.text.toLowerCase();
    String firstName = firstNameController.text.toLowerCase();
    String middleName = middleNameController.text.toLowerCase();
    String lastName = lastNameController.text.toLowerCase();

    // Update user details in Firestore
    await firebaseFirestore.collection('users').doc(userId).update({
      'rollNo': rollNo,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
    });

    // Navigate back to the register page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()),);
  }
}
