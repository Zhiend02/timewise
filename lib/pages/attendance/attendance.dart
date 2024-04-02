import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'attendancelistpage.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String? session;
  String? lectureType;
  String? subject;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int selectedDuration = 1;

  List<String> sessions = ['Odd', 'Even'];
  List<String> lectureTypes = ['Regular', 'Practical'];
  Map<String, List<String>> subjects = {
    'or': ['Math III', 'DS', 'DSGT', 'CG', 'DLCOA'],
    'op': ['Maths Tutorial', 'DS Lab', 'CG Lab', 'DLCOA Lab'],
    'er': ['Math IV', 'AOA', 'DBMS', 'OS', 'MP'],
    'ep': ['Maths Tutorial', 'AOA Lab', 'OS Lab', 'MP Lab', 'DBMS Lab'],
  };

  bool isLectureTypeEnabled() {
    return session != null;
  }

  bool isSubjectEnabled() {
    return lectureType != null && session != null;
  }

  void takeAttendance() {
    if (session != null && lectureType != null && subject != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceListPage(
            date: selectedDate.toString().substring(0, 10), // Pass date
            time: selectedTime.format(context), // Pass time
            duration: selectedDuration, // Pass duration
            session: session!, // Pass session
            lectureType: lectureType!, // Pass lecture type
            subject:subject!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select all the fields.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = (session != null && lectureType != null && subject != null)
        ? Colors.green
        : Colors.grey; // Set button color based on field selection

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.blueAccent,
      ),



      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
                color: Colors.grey
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),

              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Lecture Type',
                  border: InputBorder.none,
                ),
                value: session,
                hint: const Text('Select Session'),
                onChanged: (value) {
                  setState(() {
                    session = value;
                    lectureType = null; // Reset lecture type when session changes
                    subject = null; // Reset subject when session changes
                  });
                },
                items: sessions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
                  color: Colors.grey
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Lecture Type',
                  border: InputBorder.none,
                ),
                value: lectureType,
                hint: const Text('Select Lecture Type'),
                onChanged: isLectureTypeEnabled()
                    ? (value) {
                  setState(() {
                    lectureType = value;
                    subject = null; // Reset subject when lecture type changes
                  });
                }
                    : null,
                items: lectureTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
                  color: Colors.grey
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Lecture Type',
                  border: InputBorder.none,
                ),
                value: subject,
                hint: const Text('Select Subject'),
                onChanged: isSubjectEnabled()
                    ? (value) {
                  setState(() {
                    subject = value;
                  });
                }
                    : null,
                items: getSubjectList(),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    'Date: ${selectedDate.toString().substring(0, 10)}',
                    style:const  TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(

                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Select Date',style: TextStyle(color: Colors.black,),),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time: ${selectedTime.format(context)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (pickedTime != null && pickedTime != selectedTime) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Select Time',style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duration: $selectedDuration hrs',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: selectedDuration.toDouble(),
                    min: 1,
                    max: 12,
                    divisions: 11,
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),


            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: (buttonColor == Colors.grey) ? null : takeAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Take Attendance',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropDown(String hintText, List<String> items, Function(String?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        value: items.contains(session) ? session : null,
        onChanged: onChanged,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  List<DropdownMenuItem<String>> getSubjectList() {
    List<DropdownMenuItem<String>> items = [];
    if (session == 'Even' && lectureType == 'Regular') {
      for (String subject in subjects['er']!) {
        items.add(DropdownMenuItem<String>(
          value: subject,
          child: Text(subject),
        ));
      }
    } else if (session == 'Even' && lectureType == 'Practical') {
      for (String subject in subjects['ep']!) {
        items.add(DropdownMenuItem<String>(
          value: subject,
          child: Text(subject),
        ));
      }
    } else if (session == 'Odd' && lectureType == 'Regular') {
      for (String subject in subjects['or']!) {
        items.add(DropdownMenuItem<String>(
          value: subject,
          child: Text(subject),
        ));
      }
    } else if (session == 'Odd' && lectureType == 'Practical') {
      for (String subject in subjects['op']!) {
        items.add(DropdownMenuItem<String>(
          value: subject,
          child: Text(subject),
        ));
      }
    }
    return items;
  }
}
