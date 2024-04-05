
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timewise/pages/AdminPages/home.dart';
import 'package:timewise/pages/chatting/screens/profile_screen.dart';


import '../../../main.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';


class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {

  List<ChatUser> list = [];
  final List<ChatUser> searchlist = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(

        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
        
          //app bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: CupertinoColors.activeBlue,
            title: _isSearching
                ? TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Name, Email, ...'),
              autofocus: true,
              style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
              //when search text changes then updated search list
              onChanged: (val) {
                //search logic
                searchlist.clear();
        
                for (var i in list) {
                  if (i.firstName.toLowerCase().contains(val.toLowerCase()) ||
                      i.email.toLowerCase().contains(val.toLowerCase())) {
                    searchlist.add(i);
                    setState(() {
                      searchlist;
                    });
                  }
                }
              },
            )

                :  Row(
                  children: [
                    IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));}, icon: const Icon(Icons.arrow_back)),
                    const Text('Send Notification'),
                  ],
                ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.me)));
              }, icon: const Icon(Icons.more_vert))
            ],
          ),
        
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(onPressed:   () {
              _addChatUserDialog();
            }, child: const Icon(Icons.add_comment_rounded)),
          ),
        
          body: StreamBuilder(
              stream: APIs.firestore.collection('users').snapshots(),
              builder: (context, snapshot){

                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                    if (list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _isSearching ? searchlist.length : list.length,
                          padding: EdgeInsets.only(top: mq.height * .02),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            return ChatUserCard(user: _isSearching ? searchlist[index] : list[index],);
                            //return Text('Name: ${list[index]}');
                          });
                    }else {
                      return const Center(
                        child: Text('No Connections Found!',
                            style: TextStyle(fontSize: 20)),
                      );
                    }
                }
              }),
        
        ),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),

          //title
          title: Row(
            children: const [
              Icon(
                Icons.person_add,
                color: Colors.blue,
                size: 28,
              ),
              Text('  Add User')
            ],
          ),

          //content
          content: TextFormField(
            maxLines: null,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
                hintText: 'Email Id',
                prefixIcon: const Icon(Icons.email, color: Colors.blue),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),

          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.blue, fontSize: 16))),

            //add button
            MaterialButton(
                onPressed: () async {
                  //hide alert dialog
                  Navigator.pop(context);
                  if (email.isNotEmpty) {
                    await APIs.addChatUser(email).then((value) {
                      if (!value) {
                        Dialogs.showSnackbar(
                            context, 'User does not Exists!');
                      }
                    });
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ))
          ],
        ));
  }
}






