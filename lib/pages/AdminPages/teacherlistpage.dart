import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timewise/pages/AdminPages/studentdetailpage.dart';

class TeacherListPage extends StatefulWidget {
  @override
  _TeacherListPageState createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  late Stream<QuerySnapshot> _studentStream;

  @override
  void initState() {
    super.initState();
    _studentStream = FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastName') // Ensure ascending order by last name
        .orderBy('firstName') // Then by first name
        .orderBy('middleName') // Then by middle name
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        backgroundColor: CupertinoColors.activeBlue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _studentStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var studentDocs = snapshot.data!.docs.where((doc) => doc['role'] == 'Teacher').toList();

            if (studentDocs.isNotEmpty) {
              return ListView.builder(
                itemCount: studentDocs.length,
                itemBuilder: (context, index) {
                  var student = studentDocs[index];
                  var firstName = student['firstName'].toString();
                  var middleName = student['middleName'].toString();
                  var lastName = student['lastName'].toString();
                  var email = student['email'].toString();
                  var role = student['role'].toString();
                  var docId = student.id;

                  var capitalizedFirstName = firstName.isNotEmpty ? firstName[0].toUpperCase() + firstName.substring(1) : '';
                  var capitalizedMiddleName = middleName.isNotEmpty ? middleName[0].toUpperCase() + middleName.substring(1) : '';
                  var capitalizedLastName = lastName.isNotEmpty ? lastName[0].toUpperCase() + lastName.substring(1) : '';

                  var fullName = '$capitalizedFirstName $capitalizedMiddleName $capitalizedLastName';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDetailsPage(
                            docId: docId,
                            firstName: firstName,
                            middleName: middleName,
                            lastName: lastName,
                            email: email,
                            role: role,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(fullName),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No Teachers found.'));
            }
          }

          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }
}
