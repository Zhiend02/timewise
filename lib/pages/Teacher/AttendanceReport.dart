import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../attendance/print.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  _AttendanceReportState createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  String selectedSession = 'Odd';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<void> _printData(BuildContext context) async {
    // Pass session, start date, and end date to the next file
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrintData(
          session: selectedSession,
          startDate: startDate,
          endDate: endDate,
        ),
      ),
    );
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
            title: const Text('Print Data'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                value: selectedSession,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedSession = value;
                    });
                  }
                },
                items: ['Odd', 'Even'].map((session) {
                  return DropdownMenuItem<String>(
                    value: session,
                    child: Text(session),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text('Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: startDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        startDate = pickedDate;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(51, 172, 73, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: Size(double.infinity, 60),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Select Start Date',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text('End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: endDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        endDate = pickedDate;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(51, 172, 73, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: const Size(double.infinity, 60),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Select End Date',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    _printData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(51, 172, 73, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: Size(double.infinity, 60),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Print Data',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
