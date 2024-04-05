import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:timewise/pages/AdminPages/home.dart';



class MyCalender extends StatelessWidget {

  final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 365)),
    onRangeSelected: (firstDate, secondDate) {},
    onDayTapped: (date) {},
    // readOnly: true,
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.monday,
    // initialFocusDate: DateTime(2023, 5),
    // initialDateSelected: DateTime(2022, 3, 15),
    // endDateSelected: DateTime(2022, 3, 20),

  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' Clean Calendar',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF3F51B5),
          primaryContainer: Color(0xFF002984),
          secondary: Color(0xFFD32F2F),
          secondaryContainer: Color(0xFF9A0007),
          surface: Color(0xFFDEE2E6),
          background: Color(0xFFF8F9FA),
          error: Color(0xFF96031A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:const Size.fromHeight(kToolbarHeight + 10.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CupertinoColors.activeBlue,
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title:  Row(
                  children: [
                    IconButton( onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));}, icon: const Icon(Icons.arrow_back)),
                    const Text('Calendar'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: ScrollableCleanCalendar(
          calendarController: calendarController,
          layout: Layout.BEAUTY,
          calendarCrossAxisSpacing: 0,
        ),
      ),
    );
  }
}