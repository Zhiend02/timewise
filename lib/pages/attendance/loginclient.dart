
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'client_screen.dart';

class Loginc extends StatefulWidget {
  const Loginc({Key? key}) : super(key: key);

  @override
  State<Loginc> createState() => _Loginc();
}

class _Loginc extends State<Loginc> {
  TextEditingController name = TextEditingController();
  TextEditingController erno = TextEditingController();
  TextEditingController course = TextEditingController();
  TextEditingController year = TextEditingController();
  onClick() async {
    if (name.text == '' ||
        erno.text == '' ||
        course.text == '' ||
        year.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all the values')));
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name.text);
    prefs.setString('erno', erno.text);
    prefs.setString('course', course.text);
    prefs.setString('year', year.text);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => const MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Login',
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              SizedBox(
                width: size.width * 0.92,
                child: TextFormField(
                  controller: name,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Your Name',
                      label: Text('Name')),
                ),
              ),
              SizedBox(
                width: size.width * 0.92,
                child: TextFormField(
                  autocorrect: false,
                  controller: erno,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.numbers),
                      hintText: 'Your Enrollment Number',
                      label: Text('Enrollment')),
                ),
              ),
              SizedBox(
                width: size.width * 0.92,
                child: TextFormField(
                  autocorrect: false,
                  controller: course,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.book),
                      hintText: 'Your current course',
                      label: Text('Course')),
                ),
              ),
              SizedBox(
                width: size.width * 0.92,
                child: TextFormField(
                  controller: year,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.date_range),
                      hintText: 'Your current year',
                      label: Text('Year')),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.height * 0.04),
                child: MaterialButton(
                  onPressed: onClick,
                  child: Row(children: [
                    SizedBox(
                      width: size.width * 0.25,
                    ),
                    Icon(Icons.login),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Text('Login')
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
