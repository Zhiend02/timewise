import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timewise/pages/AdminPages/studentdetailpage.dart';

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
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
      body: Container(
        color: CupertinoColors.systemGrey,
        child: StreamBuilder<QuerySnapshot>(
          stream: _studentStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              var studentDocs = snapshot.data!.docs.where((doc) => doc['role'] == 'Student').toList();

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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 65,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CupertinoColors.white
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(fullName,
                                  style: const TextStyle(
                                    fontSize: 20
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No students found.'));
              }
            }

            return const Center(child: Text('No data available.'));
          },
        ),
      ),
    );
  }
}
