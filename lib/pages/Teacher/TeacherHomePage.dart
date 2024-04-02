import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timewise/pages/Teacher/student_export.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final StudentExporter studentExporter = StudentExporter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              String? csvPath = await studentExporter.downloadCSV();
              if (csvPath != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('CSV file saved at $csvPath')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error downloading CSV file')),
                );
              }
            },
            child: const Text('Download CSV'),
          ),

          ElevatedButton(
            onPressed: () async {
              String? csvPath = await studentExporter.downloadCSV();
              if (csvPath != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('CSV file saved at $csvPath')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error downloading CSV file')),
                );
              }
            },
            child: const Text('Download att'),
          ),
        ],
      ),
    );
  }
}
