import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceListPage extends StatefulWidget {
  final String date;
  final String time;
  final int duration;
  final String session;
  final String lectureType;

  AttendanceListPage({
    required this.date,
    required this.time,
    required this.duration,
    required this.session,
    required this.lectureType,
  });

  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  late Stream<QuerySnapshot> _studentStream;
  List<String> rollNumbers = [];
  Map<String, String> attendanceStatusMap = {}; // Map to store attendance status ('P' for present, 'A' for absent)
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> filteredStudents = [];

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

  void searchStudents(String searchQuery) {
    filteredStudents.clear();
    if (searchQuery.isNotEmpty) {
      _studentStream.listen((snapshot) {
        var studentDocs = snapshot.docs.where((doc) => doc['role'] == 'Student').toList();
        for (var student in studentDocs) {
          String fullName = '${student['firstName']} ${student['middleName']} ${student['lastName']}';
          if (fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              student['rollNo'].toString().contains(searchQuery)) {
            filteredStudents.add(student);
          }
        }
        setState(() {});
      });
    }
  }

  void toggleAttendance(String studentId) {
    setState(() {
      if (attendanceStatusMap[studentId] == 'P') {
        attendanceStatusMap[studentId] = 'A'; // Toggle to absent
      } else {
        attendanceStatusMap[studentId] = 'P'; // Toggle to present
      }
    });
  }

  void bulkUpdate(bool present) {
    setState(() {
      attendanceStatusMap.forEach((studentId, _) {
        attendanceStatusMap[studentId] = present ? 'P' : 'A';
      });
    });
  }

  Future<void> storeAttendanceData(List<String> presentStudents, List<String> absentStudents) async {
    try {
      await FirebaseFirestore.instance.collection('attendance_records').add({
        'date': widget.date,
        'time': widget.time,
        'duration': widget.duration,
        'session': widget.session,
        'lectureType': widget.lectureType,
        'presentStudents': presentStudents,
        'absentStudents': absentStudents,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance data submitted successfully!')),
      );

      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } catch (e) {
      print('Error storing attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by First Name or Roll No',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => searchStudents(searchController.text),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: null,
                  hint: Text('Bulk Update'),
                  onChanged: (value) {
                    if (value == 'All Present') {
                      bulkUpdate(true);
                    } else if (value == 'All Absent') {
                      bulkUpdate(false);
                    }
                  },
                  items: [
                    DropdownMenuItem(child: Text('All Present'), value: 'All Present'),
                    DropdownMenuItem(child: Text('All Absent'), value: 'All Absent'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _studentStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  var studentDocs = filteredStudents.isNotEmpty ? filteredStudents : snapshot.data!.docs.where((doc) => doc['role'] == 'Student').toList();

                  if (studentDocs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: studentDocs.length,
                      itemBuilder: (context, index) {
                        var student = studentDocs[index];
                        var fullName = '${student['firstName']} ${student['middleName']} ${student['lastName']}';
                        var studentId = student.id;

                        // Calculate and add roll number to the list
                        var rollNo = index + 1;
                        rollNumbers.add(rollNo.toString());

                        // Default attendance status to 'P' (present)
                        attendanceStatusMap.putIfAbsent(studentId, () => 'P');

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: attendanceStatusMap[studentId] == 'P' ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '$rollNo. $fullName',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  toggleAttendance(studentId);
                                },
                                child: Text(
                                  attendanceStatusMap[studentId] == 'P' ? 'P' : 'A',
                                ),
                              ),
                            ],
                          ),
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
          ),
          ElevatedButton(
            onPressed: () {
              List<String> presentStudents = [];
              List<String> absentStudents = [];
              attendanceStatusMap.forEach((studentId, status) {
                if (status == 'P') {
                  presentStudents.add(studentId);
                } else {
                  absentStudents.add(studentId);
                }
              });

              storeAttendanceData(presentStudents, absentStudents);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
