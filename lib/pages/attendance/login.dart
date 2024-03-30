import 'package:timewise/pages/attendance/host_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  onClick() async {
    print(name.text);
    print(email.text);
    if (name.text == '' || email.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all the values')));
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name.text);
    prefs.setString('email', email.text);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => const MyHomePagehost()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                  controller: email,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.mail),
                      hintText: 'Your E-Mail',
                      label: Text('E Mail')),
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
                    const Icon(Icons.login),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    const Text('Login')
                  ]),
                ),
              ),
              // MaterialButton(
              //   onPressed: show,
              //   child: Text('abcd'),
              // )
            ],
          ),
        ),
      ),
    ));
  }
}
