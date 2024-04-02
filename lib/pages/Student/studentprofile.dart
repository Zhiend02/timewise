import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timewise/pages/loginpage/logoutpage.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late User? _user;
  late String _firstName = '';
  late String _middleName = '';
  late String _lastName = '';
  late String _email = '';

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    if (_user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      if (userSnapshot.exists) {
        setState(() {
          _firstName = _capitalize(userSnapshot.get('firstName') ?? '');
          _middleName = _capitalize(userSnapshot.get('middleName') ?? '');
          _lastName = _capitalize(userSnapshot.get('lastName') ?? '');
          _email = userSnapshot.get('email') ?? '';
        });
      }
    }
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0,left: 20.0,bottom: 10.0,top: 30),
            child: Container(
                child: const Text("PROFILE",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
          ),
          CustomMultiChildLayout(
            delegate: ProfileLayoutDelegate(),
            children: [
              LayoutId(
                id: 'redContainer',
                child: Container(
                  width: 370,
                  height: 550,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40), // Spacer
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text("Personal Information",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      _buildIconContainer(Icons.account_circle, 'First Name : ',_firstName),
                      _buildIconContainer(Icons.account_circle, 'Middle Name : ',_middleName),
                      _buildIconContainer(Icons.account_circle, 'Last Name : ',_lastName),
                      _buildIconContainer(Icons.email, 'Email : ',_email),
                      const SizedBox(height:30),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: ElevatedButton(onPressed: (){logout(context);},
                              style:ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))

                              ) ,
                              child: const Text("log out",style: TextStyle(fontSize: 20),)),
                        ),
                      ),
                    ],

                  ),

                ),
              ),
              LayoutId(
                id: 'circle',
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData iconData, String label,String value) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 8),
          Text(label,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
          Text(value,style: const TextStyle(fontSize: 17),)
        ],
      ),
    );
  }
}

class ProfileLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    // Layout the red container at the top center
    layoutChild('redContainer', BoxConstraints.loose(size));
    positionChild('redContainer', Offset((size.width - 370) / 2, 200));

    // Layout the circle at the middle of the red container
    layoutChild('circle', BoxConstraints.loose(size));
    positionChild('circle', Offset((size.width - 200) / 2, 100 + (550 - 200) / 2 - 200)); // Center vertically in the red container
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
