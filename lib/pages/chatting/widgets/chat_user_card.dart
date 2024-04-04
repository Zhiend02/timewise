import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timewise/pages/chatting/api/apis.dart';
import 'package:timewise/pages/chatting/helper/my_date_util.dart';
import '../../../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../screens/chat_page.dart';
import '../screens/home_page.dart';

class ChatUserCard extends StatefulWidget {

  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  Message? message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width *.01, vertical: 1),
      //color: Colors.blue.shade50,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatScreen(user: widget.user)));},
        child:StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context,snapshot){

            final data = snapshot.data?.docs;
            final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if(list.isNotEmpty) message = list[0];

            return ListTile(
                leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
                title: Text(widget.user.fullName),
                subtitle: Text(message != null ?
                message!.type == Type.image ?
                    'image'
                    :
                message!.msg
                    :  widget.user.role, maxLines: 1,),
                trailing: message== null
              ? null
                :
                message!.read.isEmpty &&
                    message!.fromId != APIs.user.uid ?
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(10)),)
                    :
                    Text(
                      MyDateUtil.getLastMessageTime(
                          context: context, time: message!.sent),style: TextStyle(color: Colors.black54),),
            );
          }
        )
      ),
    );
  }
}


