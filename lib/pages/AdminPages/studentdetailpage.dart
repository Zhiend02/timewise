import 'package:flutter/material.dart';
class StudentDetailsPage extends StatelessWidget {
  final String docId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String role;

  const StudentDetailsPage({
    required this.docId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Document ID: $docId'),
            SizedBox(height: 10),
            Text('First Name: $firstName'),
            SizedBox(height: 10),
            Text('Middle Name: $middleName'),
            SizedBox(height: 10),
            Text('Last Name: $lastName'),
            SizedBox(height: 10),
            Text('Email: $email'),
            SizedBox(height: 10),
            Text('Role: $role'),
          ],
        ),
      ),
    );
  }
}
