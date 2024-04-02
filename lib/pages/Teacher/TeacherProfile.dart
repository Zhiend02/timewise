import 'package:flutter/material.dart';
import 'package:timewise/pages/loginpage/logoutpage.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({Key? key}) : super(key: key);

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
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
                      const SizedBox(height: 30), // Spacer
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text("Personal Information",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      _buildIconContainer(Icons.account_circle, 'First Name'),
                      _buildIconContainer(Icons.account_circle, 'Middle Name'),
                      _buildIconContainer(Icons.account_circle, 'Last Name'),
                      _buildIconContainer(Icons.email, 'Email'),
                      const SizedBox(height:30),
                      ElevatedButton(onPressed: (){logout(context);},
                          style:ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))

                          ) ,
                          child: const Text("log out")),

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

  Widget _buildIconContainer(IconData iconData, String label) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 8),
          Text(label),
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
