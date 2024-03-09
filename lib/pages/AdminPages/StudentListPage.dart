import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        .orderBy('lastName')
        .orderBy('firstName')
        .orderBy('middleName')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _studentStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  var fullName =
                      '${student['firstName']} ${student['middleName']} ${student['lastName']}';
                  return ListTile(
                    title: Text(fullName),
                    subtitle: Text(student['email']),
                    trailing: Text(student['role']),
                  );
                },
              );
            } else {
              return Center(child: Text('No students found.'));
            }
          }

          return Center(child: Text('No data available.'));
        },
      ),
    );
  }
}
