import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timewise/pages/loginpage/splashscreen.dart';
import '../AdminPages/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              // images
              Container(
                height: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(duration: const Duration(seconds: 1), child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-1.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(duration: const Duration(milliseconds: 1200), child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-2.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(duration: const Duration(milliseconds: 1300), child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/clock.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      child: FadeInUp(duration: const Duration(milliseconds: 1600), child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        ),
                      )),
                    )
                  ],
                ),
              ),



              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formkey,

                  child: Column(
                    children:<Widget> [

                      // email field
                      FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),

                                      // email field
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            hintText: 'Email',
                                            enabled: true,
                                            contentPadding: const EdgeInsets.all(10),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.white),
                                              borderRadius: new BorderRadius.circular(10),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.white),
                                              borderRadius: new BorderRadius.circular(10),
                                            ),
                                          ),

                                          validator: (value) {
                                            if (value!.length == 0) {
                                              return "Email cannot be empty";
                                            }
                                            if (!RegExp(
                                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                                .hasMatch(value)) {
                                              return ("Please enter a valid email");
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (value) {emailController.text = value!;}, keyboardType: TextInputType.emailAddress,
                                        ),
                                  ),
                                ),

                                // passowrd field
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),

                                        child: TextFormField(
                                          controller: passwordController,
                                          obscureText: _isObscure3,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon: Icon(_isObscure3
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {setState(() {_isObscure3 = !_isObscure3;});}),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            hintText: 'Password',
                                            enabled: true,
                                            contentPadding: const EdgeInsets.all(10),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.white),
                                              borderRadius: new BorderRadius.circular(10),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.white),
                                              borderRadius: new BorderRadius.circular(10),
                                            ),
                                          ),


                                          validator: (value) {
                                            RegExp regex = new RegExp(r'^.{6,}$');
                                            if (value!.isEmpty) {
                                              return "Password cannot be empty";
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return ("please enter valid password min. 6 character");
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (value) {
                                            passwordController.text = value!;
                                          }, keyboardType: TextInputType.emailAddress,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),

                      const SizedBox(height: 10,),

                      // button
                      FadeInUp(
                          duration: const Duration(milliseconds: 1900),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent[400],
                                onSurface: Colors.blueAccent[100],
                                shadowColor: Colors.blueAccent[300],
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                signIn(emailController.text, passwordController.text);
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                                                                  ),
                          ),
                          ),


                      const SizedBox(height: 10,),


                      Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible,
                          child:
                          Container(child: CircularProgressIndicator(color: Colors.red,))),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void  signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        visible = true; // Show CircularProgressIndicator
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

          var sharedPref = await SharedPreferences.getInstance();
          sharedPref.setBool(SplashScreenState.KEY_LOGIN, true);

        // Get the user's document ID from Firestore
        String userId = userCredential.user!.uid; // Assuming Firestore uses UID as document ID
        // Fetch fname from Firestore using the userId
        String fname = await fetchFNameFromFirestore(userId);

        sharedPref.setString('user_id', userId); // Store the user's document ID with key 'user_id'
        sharedPref.setString('fname', fname); // Store the user's fname

        // Print the user's document ID
        print('User Document ID: $userId');
        print('User First Name: $fname');

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          visible = false; // Hide CircularProgressIndicator
        });

        // Showing error message as toast using Fluttertoast
        String errorMessage= 'An error occurred, please try again.';
        if (e.code == 'user-not-found') {
          errorMessage = 'Incorrect email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password.';
        }

        // Showing error message as toast using Fluttertoast
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

}

Future<String> fetchFNameFromFirestore(String userId) async {
  try {
    // Get the document snapshot from Firestore using the user ID (UID)
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();


    if (documentSnapshot.exists && documentSnapshot.data() != null) {

      String? fname = documentSnapshot.get('firstName');
      if (fname != null) {
        return fname;
      }
    }
    return '';
  } catch (e) {
    print('Error fetching fname: $e');
    return ''; // Return an empty string in case of errors
  }
}