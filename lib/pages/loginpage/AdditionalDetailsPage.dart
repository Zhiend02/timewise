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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: middleNameController,
              decoration: InputDecoration(labelText: 'Middle Name'),
            ),
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
    String firstName = firstNameController.text.toLowerCase();
    String middleName = middleNameController.text.toLowerCase();
    String lastName = lastNameController.text.toLowerCase();

    // Update user details in Firestore
    await firebaseFirestore.collection('users').doc(userId).update({
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
    });

    // Navigate back to the register page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()),);
  }
}
