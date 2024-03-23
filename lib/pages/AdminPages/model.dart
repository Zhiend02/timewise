import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  String? role;
  String? uid;
  String? firstName;
  String? middleName;
  String? lastName;


// receiving data
  UserModel({this.uid, this.email, this.role ,this.firstName, this.middleName, this.lastName,});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],


    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
    };
  }
}



class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeAttendanceData({
    required String date,
    required String time,
    required int duration,
    required String session,
    required String lectureType,
    required String subject,
    required List<String> presentStudents,
    required List<String> absentStudents,
  }) async {
    try {
      // Add a new document to the 'attendance_records' collection
      await _firestore.collection('attendance_records').add({
        'date': date,
        'time': time,
        'duration': duration,
        'session': session,
        'lectureType': lectureType,
        'subject': subject,
        'presentStudents': presentStudents,
        'absentStudents': absentStudents,
      });
    } catch (e) {
      // Handle errors here
      print('Error storing attendance data: $e');
    }
  }
}
