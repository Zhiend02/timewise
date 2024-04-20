import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'individualprint.dart';

class IndividualReport extends StatefulWidget {
  final String docId;

  const IndividualReport({Key? key, required this.docId}) : super(key: key);

  @override
  _IndividualReportState createState() => _IndividualReportState();
}

class _IndividualReportState extends State<IndividualReport> {
  String selectedSession = 'Odd';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? selectedSubject;
  List<String> oddSubjects = [
    'Math III',
    'DS',
    'DSGT',
    'CG',
    'DLCOA',
    'Maths Tutorial',
    'DS Lab',
    'CG Lab',
    'DLCOA Lab'
  ];
  List<String> evenSubjects = [
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

  Future<void> _IndividualPrint(BuildContext context) async {
    if (selectedSubject != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndividualPrint(
            session: selectedSession,
            startDate: startDate,
            endDate: endDate,
            docId: widget.docId,
            selectedSubject: selectedSubject!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a subject.'),
        ),
      );
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
            title: const Text('Select Data'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder( // Border for focused state
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                value: selectedSession,
                onChanged: (value) {
                  setState(() {
                    selectedSession = value!;
                    selectedSubject = null; // Reset selected subject
                  });
                },
                items: ['Odd', 'Even'].map((session) {
                  return DropdownMenuItem<String>(
                    value: session,
                    child: Text(session),
                  );
                }).toList(),
              ),
              if (selectedSession != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedSubject,
                    onChanged: (value) {
                      setState(() {
                        selectedSubject = value!;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder( // Border for focused state
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),

                    ),
                    items: selectedSession == 'Odd'
                        ? oddSubjects.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList()
                        : evenSubjects.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 20),
              Text('Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: AnimatedButton(
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
                  gradient:const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(9, 198, 249, 1),
                      Color.fromRGBO(4, 93, 233, 1),
                    ],
                  ),
                  text: 'Select Start Date',


                ),
              ),
              const SizedBox(height: 30),
              Text('End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: AnimatedButton(
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
                  gradient:const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(9, 198, 249, 1),
                      Color.fromRGBO(4, 93, 233, 1),
                    ],
                  ),
                   text: 'Select End Date',
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: AnimatedButton(
                  onPressed: () {
                    _IndividualPrint(context);
                  },
                  gradient:const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(100, 226, 98, 1.0),
                      Color.fromRGBO(	4, 172, 42, 1.0),
                    ],
                  ),
                  text: 'Print Data',
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
          style: const TextStyle(color: Colors.white,fontSize: 18),
        ),
      ),
    );
  }
}