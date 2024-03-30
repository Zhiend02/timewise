import 'package:flutter/material.dart';

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
    'or': ['Math', 'Science', 'History'],
    'op': ['Physics Lab', 'Chemistry Lab', 'Biology Lab'],
    'er': ['Math', 'Science', 'History', 'Geography', 'English'],
    'ep': ['Physics Lab', 'Chemistry Lab', 'Biology Lab', 'Computer Lab', 'Robotics Lab'],
  };

  bool isLectureTypeEnabled() {
    return session != null;
  }

  bool isSubjectEnabled() {
    return lectureType != null && session != null;
  }



  void takeAttendance() {
    if (session != null && lectureType != null && subject != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceListPage(
            date: selectedDate.toString().substring(0, 10), // Pass  date
            time: selectedTime.format(context), // Pass  time
            duration: selectedDuration, // Pass  duration
            session: session!, // Pass session
            lectureType: lectureType!, // Pass lecture type
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all the fields.'), duration: Duration(seconds: 2),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: session,
              hint: const Text('Select Session'), onChanged: (value) {setState(() {
                  session = value;
                  lectureType = null; // Reset lecture type when session changes
                  subject = null; // Reset subject when session changes
                });
              },
              items: sessions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButtonFormField<String>(
              value: lectureType,
              hint: const Text('Select Lecture Type'),
              onChanged: isLectureTypeEnabled() ? (value) {
                setState(() {
                  lectureType = value;
                  subject = null; // Reset subject when lecture type changes
                });
              } : null,
              items: lectureTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButtonFormField<String>(
              value: subject,
              hint: const Text('Select Subject'),
              onChanged: isSubjectEnabled() ? (value) {
                setState(() {
                  subject = value;
                });
              } : null,
              items: getSubjectList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date: ${selectedDate.toString().substring(0, 10)}'),
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
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Time: ${selectedTime.format(context)}'),
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
                  child: const Text('Select Time'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: $selectedDuration hrs'),
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

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (buttonColor == Colors.grey) ? null : takeAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
              ),
              child: const Text('Take Attendance'),
            ),
          ],
        ),
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

