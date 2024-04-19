import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timewise/pages/attendance/voiceattendance.dart';
import 'package:timewise/pages//global.dart' as globals;

class AttendanceListPage extends StatefulWidget {
  final String date;
  final String time;
  final int duration;
  final String session;
  final String lectureType;
  final String subject;



  AttendanceListPage({
    required this.date,
    required this.time,
    required this.duration,
    required this.session,
    required this.lectureType,
    required this.subject,

  });






  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> _studentStream;
  List<String> rollNumbers = [];
  Map<String, String> attendanceStatusMap = {}; // Map to store attendance status ('P' for present, 'A' for absent)
  bool hideText = false;

  String? _selectedBulkUpdate;

  @override
  void initState() {
    super.initState();
    _studentStream = FirebaseFirestore.instance
        .collection('users')
        .orderBy('rollNo')
        .snapshots();
    fetchRollNumbers();
    print(globals.UniqueNumbersList);

  }
  void fetchRollNumbers() async {
    QuerySnapshot rollNumbersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('rollNo')
        .get();

    if (rollNumbersSnapshot.docs.isNotEmpty) {
      rollNumbers = rollNumbersSnapshot.docs.map((doc) => doc['rollNo'].toString()).toList();
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


  bool _isNumberInUniqueList(String rollNo) {
    if (globals.UniqueNumbersList.contains(rollNo)) {
      // If the number is in the uniqueNumbersList, change attendance status to 'A' (absent)
      attendanceStatusMap[rollNo] = 'A';
      return true;
    } else {
      return false;
    }
  }

  Future<void> storeAttendanceData(List<String> presentStudents, List<String> absentStudents) async {
    try {
      String collectionName = widget.session == 'Odd' ? 'record_odd' : 'record_even';
      await FirebaseFirestore.instance.collection(collectionName).add({
        'date': widget.date,
        'time': widget.time,
        'duration': widget.duration,
        'session': widget.session,
        'lectureType': widget.lectureType,
        'subject': widget.subject,
        'presentStudents': presentStudents,
        'absentStudents': absentStudents,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance data submitted successfully!')),
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } catch (e) {
      print('Error storing attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 15.0),
          child: Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
              Color.fromRGBO(9, 198, 249, 1),
              Color.fromRGBO(4, 93, 233, 1),
                  ],
                  ),
                  ),

            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('Student List'),

        ),
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child:Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          hideText = true; // Hide the text when tapped
                        });
                      },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                           color: CupertinoColors.white,
                          ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: hideText
                              ? const SizedBox() // Placeholder when text is hidden
                              : TextField(
                                controller: searchController,
                                  onChanged: (value) {
                                   setState(() {}); // Trigger rebuild on search input change
                            },
                                keyboardType: const TextInputType.numberWithOptions(decimal: false), // for numbers only
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Search by Roll No',
                                  labelStyle: const TextStyle(color: Colors.black),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search, color: Colors.black),
                                    onPressed: () {}, // No need to handle this separately
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  )],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: Row(
                children: [
                  ElevatedButton(

                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceInputScreen(),));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all( 12.0),
                     backgroundColor: CupertinoColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Border radius
                      ), // Increase height
                    ),
                   child:const Text("Voice Search",
                     style: TextStyle(
                       color: Colors.black, // Text color
                       fontSize: 16, // Text size
                     ),),
                  ),
                  const SizedBox(width: 70),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CupertinoColors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.blueAccent,
                        underline: Container(), // Remove the underline
                        value: _selectedBulkUpdate,
                        hint: const Text('Bulk Update', style: TextStyle(color: Colors.black)),
                        onChanged: (value) {
                          if (value == 'All Present') {
                            bulkUpdate(true);
                            _selectedBulkUpdate = 'All Present';
                          } else if (value == 'All Absent') {
                            bulkUpdate(false);
                            _selectedBulkUpdate = 'All Absent';
                          } else {
                            _selectedBulkUpdate = null;
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 'All Present', child: Text('All Present', style: TextStyle(color: Colors.black))),
                          DropdownMenuItem(value: 'All Absent', child: Text('All Absent', style: TextStyle(color: Colors.black))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Added space for separation
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _studentStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  var filteredDocs = snapshot.data!.docs.where((doc)  {
                    var searchValue = searchController.text.toLowerCase();
                    var rollNo = doc['rollNo'].toString().toLowerCase();
                    var firstName = doc['firstName'].toString().toLowerCase();
                    return rollNo.startsWith(searchValue) || firstName.contains(searchValue) && doc['role'] == 'Student'; // Filter by role 'Student' name and rollNO
                  }).toList();

                  if (filteredDocs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        var student = filteredDocs[index];
                        var firstName = student['firstName'].toString();
                        var middleName = student['middleName'].toString();
                        var lastName = student['lastName'].toString();
                        var capitalizedFirstName = firstName.isNotEmpty ? firstName[0].toUpperCase() + firstName.substring(1) : '';
                        var capitalizedMiddleName = middleName.isNotEmpty ? middleName[0].toUpperCase() + middleName.substring(1) : '';
                        var capitalizedLastName = lastName.isNotEmpty ? lastName[0].toUpperCase() + lastName.substring(1) : '';

                        var fullName = '$capitalizedFirstName $capitalizedMiddleName $capitalizedLastName';

                        var studentId = student.id;
                        var rollNo = index < rollNumbers.length ? rollNumbers[index] : '';


                        // Default attendance status to 'P' (present)
                        attendanceStatusMap.putIfAbsent(studentId, () => 'P');

                        return GestureDetector(
                          onTap: () {
                            toggleAttendance(studentId);
                          },
                          child: Container(
                            key: Key(rollNo),
                            height: 60,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: attendanceStatusMap[rollNo] == 'A' || _isNumberInUniqueList(rollNo) ? Colors.red : attendanceStatusMap[studentId] == 'P' ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '$rollNo. $fullName',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  attendanceStatusMap[studentId] == 'P' ? 'Present' : 'Absent',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No students found.'));
                  }
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
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );

  }

}
//before before

