import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class PrintData extends StatefulWidget {
  final String session;
  final DateTime startDate;
  final DateTime endDate;

  const PrintData({
    Key? key,
    required this.session,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<PrintData> createState() => _PrintDataState();
}

class _PrintDataState extends State<PrintData> {
  void initState() {
    super.initState();
    _printAttendanceData();
  }

  Future<void> _printAttendanceData() async {
    try {
      CollectionReference<Map<String, dynamic>> collectionRef =
      FirebaseFirestore.instance.collection(
          widget.session == 'Odd' ? 'record_odd' : 'record_even');

      print('Fetching documents from ${collectionRef.id}...');
      print('Start Date: ${widget.startDate}');
      print('End Date: ${widget.endDate}');

      String startDateTime =
      DateFormat('yyyy-MM-dd').format(widget.startDate);
      String endDateTime =
      DateFormat('yyyy-MM-dd').format(widget.endDate);

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await collectionRef
          .where('date', isGreaterThanOrEqualTo: startDateTime,
          isLessThanOrEqualTo: endDateTime)
          .get();

      int numDocuments = querySnapshot.size; // Number of documents found in the date range

      // print('Number of Documents: $numDocuments');

      if (numDocuments == 0) {
        print('No documents found within the specified date range.');
        return;
      }

      Map<String, int> subjectCount = {}; // Map to store subject counts

      List<String> subjectsList = widget.session == 'Odd'
          ? [
        'Math III',
        'DS',
        'DSGT',
        'CG',
        'DLCOA',
        'Maths Tutorial',
        'DS Lab',
        'CG Lab',
        'DLCOA Lab'
      ]
          : [
        'Math IV',
        'AOA',
        'DBMS',
        'OS',
        'MP',
        'Maths Tutorial',
        'AOA Lab',
        'OS Lab',
        'MP Lab',
        'DBMS Lab'
      ];

      // Initialize subject counts to 0
      subjectsList.forEach((subject) {
        subjectCount[subject] = 0;
      });

      // Generate CSV data
      List<List<dynamic>> csvData = [];
      await _generateCSVData(
          csvData, querySnapshot, subjectsList, numDocuments); // Call _generateCSVData

      // Save CSV file to system's download folder
      final csvFile = const ListToCsvConverter().convert(csvData);
      final String dir = (await getExternalStorageDirectory())!.path;
      // Highlighting the changes:
      final String formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
      final String formattedTime = DateFormat('HHmmss').format(DateTime.now());
      final String fileName = 'AttendanceReport_$formattedDate$formattedTime.csv';

      final String path = '$dir/$fileName';
      final File file = File(path);
      await file.writeAsString(csvFile);
      print('CSV file saved to: $path');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _generateCSVData(
      List<List<dynamic>> csvData,
      QuerySnapshot<Map<String, dynamic>> querySnapshot,
      List<String> subjectsList,
      int numDocuments) async {
    try {
      Map<String, List<dynamic>> studentDataMap = {}; // Map to store student data

      // Iterate through each document in the querySnapshot to get student names and attendance data
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
      in querySnapshot.docs) {
        final presentStudents =
        List<String>.from(doc['presentStudents'] ?? []);

        for (String studentId in presentStudents) {
          QuerySnapshot<Map<String, dynamic>> studentQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'Student')
              .where(FieldPath.documentId, isEqualTo: studentId)
              .get();

          if (studentQuery.size > 0) {
            final firstName = studentQuery.docs[0].get('firstName') ?? '';
            final lastName = studentQuery.docs[0].get('lastName') ?? '';
            final middleName =
                studentQuery.docs[0].get('middleName') ?? ''; // Assuming middleName field exists
            final fullName = '$lastName, $firstName $middleName'; // Format the name

            // Check if the student is already added to the map
            if (!studentDataMap.containsKey(fullName)) {
              List<dynamic> studentData =
              List.filled(subjectsList.length, 0);
              studentDataMap[fullName] = studentData;
            }

            // Increment attendance count for the subject
            for (int i = 0; i < subjectsList.length; i++) {
              if (doc['subject'] == subjectsList[i]) {
                studentDataMap[fullName]![i]++;
                break;
              }
            }
          }
        }
      }

      // Sort student names in the order of last name, first name, and then middle name
      List<String> sortedNames = studentDataMap.keys.toList();
      sortedNames.sort((a, b) {
        List<String> aSplit = a.split(', ');
        List<String> bSplit = b.split(', ');
        int lastNameComparison = aSplit[0].compareTo(bSplit[0]);
        if (lastNameComparison != 0) return lastNameComparison;
        int firstNameComparison = aSplit[1].compareTo(bSplit[1]);
        if (firstNameComparison != 0) return firstNameComparison;
        return aSplit[2].compareTo(bSplit[2]);
      });

      // Generate CSV rows using sorted data from studentDataMap
      csvData.add([
        'Student','Name',
        ...subjectsList,
        'Total Conducted',
        'Total Present',
        '%Attendance'
      ]); // Add column names
      sortedNames.forEach((fullName) {
        List<dynamic> attendanceValues = studentDataMap[fullName]!;
        int totalPresent =
        attendanceValues.reduce((sum, value) => sum + value); // Calculate total present days
        double attendancePercentage = (totalPresent / numDocuments) * 100; // Calculate attendance percentage
        List<dynamic> row = [
          fullName,
          ...attendanceValues,
          numDocuments,
          totalPresent,
          attendancePercentage.toStringAsFixed(2)
        ]; // Add numDocuments, totalPresent, and attendancePercentage to respective columns
        csvData.add(row);
      });
    } catch (e) {
      print('Error generating CSV data: $e');
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
            title: const Text('Download Defaulter'),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Session: ${widget.session}',style: TextStyle(fontSize: 18),),
            Text(
                'Start Date: ${DateFormat('yyyy-MM-dd').format(widget.startDate)}',style: TextStyle(fontSize: 18)),
            Text(
                'End Date: ${DateFormat('yyyy-MM-dd').format(widget.endDate)}',style: TextStyle(fontSize: 18)),
           const  SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     _printAttendanceData();
            //   },
            //   child: const Text('Print Attendance Data'),
            // ),
            AnimatedButton(
              onPressed: _downloadCSV,
              gradient:const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(100, 226, 98, 1.0),
                  Color.fromRGBO(	4, 172, 42, 1.0),
                ],
              ),
              text:('Download CSV'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadCSV() async {
    // Trigger the attendance data printing
    await _printAttendanceData();

    // Show a snackbar indicating the CSV file download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
        Text('CSV file downloaded to system\'s downloads folder.'),
      ),
    );
  }
}
class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final LinearGradient gradient;

  const AnimatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      width: 350,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}