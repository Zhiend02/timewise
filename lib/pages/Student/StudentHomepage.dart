import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timewise/pages/report/AttendanceReport.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:timewise/pages/attendance/attendance.dart';
import 'package:timewise/pages/attendance/loginclient.dart';

import '../chatting/screens/splash_page.dart';
import 'calender.dart';
class StudentHomePage extends StatefulWidget {
  const StudentHomePage.student({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: CupertinoColors.systemGrey4,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 9,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 32.0,
                    ),
                    _landscapeViewExample(), // Retain only landscape view
                    const SizedBox(
                      height: 32.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Details',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _yellowContainer(
                          'assets/images/attendance.png',
                          'Attendance Report'
                      ),
                      _yellowContainer(
                          'assets/images/calendar.png',
                          'Calender'
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _yellowContainer(
                          'assets/images/notifications.png',
                          'Send Notification'
                      ),
                      _yellowContainer(
                          'assets/images/dashboard.png',
                          'Attendance Dashboard'

                      ),
                    ],
                  ),
                  const SizedBox(height: 100,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _yellowContainer(String imageUrl, String title) {
    double containerWidth = MediaQuery.of(context).size.width * 0.42;
    return GestureDetector(
      onTap: () {
        // Navigate to the specific page based on the title
        if (title == 'Attendance Report') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AttendanceReport()),
          );
        }
        else if (title == 'Calender') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MyCalender()),
          );
        }
        else if (title == 'Send Notification') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatSplashPage1()),
          );
        }
        else if (title == 'Attendance Dashboard') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const IndividualReport1()),
          );
        }
        // Add more conditions for other titles and pages as needed
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:[
                  Color.fromRGBO(9, 198, 249, 1),
                  Color.fromRGBO(4, 93, 233, 1)
                ]
            )
        ),
        width: containerWidth,
        height: 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height:70, // Increased height for the main image
                width: 70,
                child: Image.asset(
                  imageUrl,
                ),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20,fontWeight:FontWeight.w600 ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _landscapeViewExample() {
    return FutureBuilder<String>(
      future: _fetchFNameFromSharedPref(), // Fetch fname from SharedPreferences
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String fname = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Hello $fname',
                  // Display fname retrieved from SharedPreferences
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "Ready for today's classes!",
                  style: TextStyle(fontSize: 19),
                ),
              ),
              const SizedBox(height: 16),
              EasyDateTimeLine(
                initialDate: DateTime.now(),
                onDateChange: (selectedDate) {
                  // Handle date change
                },
                activeColor: const Color(0xff116A7B),
                dayProps: const EasyDayProps(
                  landScapeMode: true,
                  activeDayStyle: DayStyle(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(48.0)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors:[
                                Color.fromRGBO(9, 198, 249, 1),
                                Color.fromRGBO(4, 93, 233, 1)
                              ]
                          )
                      )
                  ),
                  dayStructure: DayStructure.dayStrDayNum,
                ),
                headerProps: const EasyHeaderProps(
                  dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
                ),
              ),
            ],
          );
        } else {
          // Placeholder widget while data is loading
          return Container(
            width: double.infinity,
            height: 200,
            alignment: Alignment.center,
            child: CircularProgressIndicator(), // Loading indicator
          );
        }
      },
    );
  }
}
Future<String> _fetchFNameFromSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String fname = prefs.getString('fname') ?? ''; // Get fname from SharedPreferences
  if (fname.isNotEmpty) {
    fname = fname[0].toUpperCase() + fname.substring(1);
  }
  return fname;
}
