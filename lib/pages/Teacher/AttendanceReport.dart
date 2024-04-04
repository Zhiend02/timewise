import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timewise/pages/attendance/AttendanceCSVExporter.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  _AttendanceReportState createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  String selectedSession = 'Odd';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<void> _downloadCSV(BuildContext context) async {
    final exporter = AttendanceCSVExporter();
    final csvPath = await exporter.downloadCSV(selectedSession, 'Regular', startDate, endDate);

    if (csvPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV file downloaded successfully: $csvPath'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading CSV file.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download CSV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
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
            ElevatedButton(
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
              child: Text('Select Start Date'),
            ),
            SizedBox(height: 20),
            Text('End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
            ElevatedButton(
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
              child: Text('Select End Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _downloadCSV(context);
              },
              child: Text('Download CSV'),
            ),
          ],
        ),
      ),
    );
  }
}
