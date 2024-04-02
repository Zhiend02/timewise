import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class StudentExporter {
  Future<String?> downloadCSV() async {
    try {
      // Fetch student data from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastName')
          .orderBy('firstName')
          .orderBy('middleName')
          .get();

      List<Map<String, dynamic>> studentData = querySnapshot.docs
          .where((doc) => doc['role'] == 'Student')
          .map((student) => {
        'firstName': student['firstName'],
        'middleName': student['middleName'],
        'lastName': student['lastName'],
        'email': student['email'],
        'role': student['role'],
      })
          .toList();

      // Fetch data from the 'attendance_records' collection
      QuerySnapshot<Map<String, dynamic>> querySnapshot2 =
      await FirebaseFirestore.instance.collection('attendance_records').get();

// Map each document to a Map<String, dynamic>
      List<Map<String, dynamic>> attendanceData = querySnapshot2.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Create CSV format from student data
      List<List<dynamic>> csvData = [
        ['First Name', 'Middle Name', 'Last Name', 'Email', 'Role']
      ];
      List<List<dynamic>> attData = [
        ['absentStudents','presentStudents','date','duration','lectureType','subject','time','session']
      ];
      studentData.forEach((student) {
        csvData.add([
          student['firstName'],
          student['middleName'],
          student['lastName'],
          student['email'],
          student['role']
        ]);
      });

      attendanceData.forEach((element) {
        attData.add([
          element['absentStudents'],
          element['presentStudents'],
          element['date'],
          element['duration'],
          element['lectureType'],
          element['subject'],
          element['time'],
          element['session'],
        ]);
      });

      // Encode CSV data to bytes
      String csvString = const ListToCsvConverter().convert(csvData);
      String attString = const ListToCsvConverter().convert(attData);
      Uint8List csvBytes = Uint8List.fromList(utf8.encode(csvString));
      Uint8List attBytes = Uint8List.fromList(utf8.encode(attString));

      // Save CSV file to system's default Downloads folder
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download'); // Android default Downloads folder path
      } else if (Platform.isIOS) {
        downloadsDirectory = Directory('/private/var/mobile/Containers/Data/Application'); // iOS default Downloads folder path
      }

      String? csvPath;
      if (downloadsDirectory != null) {
        csvPath = '${downloadsDirectory.path}/student_list.csv';
        final File file = File(csvPath);
        await file.writeAsBytes(csvBytes);
        await file.writeAsBytes(attBytes);
      }

      return csvPath;
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}


