
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AttendanceCSVExporter {
  Future<String?> downloadCSV(
      String session,
      String lectureType,
      DateTime startDate,
      DateTime endDate,
      ) async {
    try {
      // Fetch student data from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('users').orderBy('lastName').get();

      List<Map<String, dynamic>> studentData = querySnapshot.docs
          .where((doc) => doc['role'] == 'Student')
          .map((student) => student.data() as Map<String, dynamic>)
          .toList();

      // Fetch data from the 'attendance_records' collection within the date range
      QuerySnapshot<Map<String, dynamic>> attendanceSnapshot = await FirebaseFirestore.instance
          .collection('attendance_records')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      List<Map<String, dynamic>> attendanceData = attendanceSnapshot.docs
          .where((doc) =>
      doc['session'] == session && doc['lectureType'] == lectureType)
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Determine subject list based on session and lecture type
      List<String> subjectsList = [];
      if (session == 'Odd' && lectureType == 'Regular') {
        subjectsList = ['Math III', 'DS', 'DSGT', 'CG', 'DLCOA', 'Maths Tutorial', 'DS Lab', 'CG Lab', 'DLCOA Lab'];
      } else if (session == 'Odd' && lectureType == 'Practical') {
        subjectsList = ['Math III', 'DS', 'DSGT', 'CG', 'DLCOA', 'Maths Tutorial', 'DS Lab', 'CG Lab', 'DLCOA Lab'];
      } else if (session == 'Even' && lectureType == 'Regular') {
        subjectsList = ['Math IV', 'AOA', 'DBMS', 'OS', 'MP', 'Maths Tutorial', 'AOA Lab', 'OS Lab', 'MP Lab', 'DBMS Lab'];
      } else if (session == 'Even' && lectureType == 'Practical') {
        subjectsList = ['Math IV', 'AOA', 'DBMS', 'OS', 'MP', 'Maths Tutorial', 'AOA Lab', 'OS Lab', 'MP Lab', 'DBMS Lab'];
      }

      // Create CSV format with subject columns
      List<List<dynamic>> csvData = [
        ['Student Name', ...subjectsList,'Total conducted','total present','attendance']
      ];

      studentData.forEach((student) {
        String fullName =
            '${student['firstName']} ${student['middleName']} ${student['lastName']}';
        List<dynamic> row = [fullName];
        subjectsList.forEach((subject) {
          var subjectPresent = attendanceData.any((attendance) =>
          attendance['subject'].contains(fullName) &&
              attendance['subject'].contains(subject));
          row.add(subjectPresent ? 'Present' : 'Absent');
        });
        csvData.add(row);
      });

      // Encode CSV data to bytes
      String csvString = const ListToCsvConverter().convert(csvData);
      List<int> csvBytes = utf8.encode(csvString);

      // Generate default filename format
      String currentDateTime = DateFormat('yyyyMMdd-HHmmss').format(DateTime.now());
      String defaultFileName = 'studentAttendance$currentDateTime.csv';

      // Save CSV file to system's default Downloads folder
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      String? csvPath;
      if (downloadsDirectory != null) {
        csvPath = '${downloadsDirectory.path}/$defaultFileName';
        final File file = File(csvPath);
        await file.writeAsBytes(csvBytes);
      }

      return csvPath;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}