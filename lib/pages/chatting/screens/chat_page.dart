
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timewise/pages/chatting/screens/view_profile_screen.dart';
import 'package:timewise/pages/chatting/widgets/message_card.dart';

import '../../../main.dart';
import '../api/apis.dart';
import '../models/chat_user.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Message> list = [];

  final textController = TextEditingController();

  bool _showEmoji = false, isUploading = false;

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),

          backgroundColor: const Color.fromARGB(255, 234, 248, 255),

          body: Column(
            children: [

              Expanded(
                child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot){

                      switch (snapshot.connectionState){
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                      //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;


                          list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];


                          if (list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                                itemCount:list.length,
                                padding: EdgeInsets.only(top: mq.height * .02),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index){
                                  return MessageCard(message: list[index]);
                                });
                          }else {
                            return const Center(
                              child: Text('Say Hii!👋',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    }, ),
              ),

              if (isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(strokeWidth: 2))),

              _chatInput()],
          ),

        ),
      ),
    );
  }
      Widget _appBar(){
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewProfileScreen(user: widget.user)));
          },
          child: Row(
            children: [
                 IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back,color: Colors.black54,)),


              const Column(
                  children: [
                  CircleAvatar(child: Icon(CupertinoIcons.person),),
              ],
              ),
          //for adding some space
          const SizedBox(width: 10),

          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
          //user name
              Text(widget.user.fullName,
               style: const TextStyle(
                   fontSize: 16,
                   color: Colors.black,
                   fontWeight: FontWeight.w600)),

              const SizedBox(height: 2),

              Text(widget.user.role),
          ],
          ),

            ],
          ),
        );
  }

  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(onPressed: (){},
                    icon: Icon(Icons.emoji_emotions,color: Colors.blueAccent,size: 28,)),

                  Expanded(
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                        hintText: 'Type Something',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                  )),

                  IconButton(onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Picking multiple images
                    final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);

                    // uploading & sending image one by one
                    for (var i in images) {
                      //log('Image Path: ${i.path}');
                      setState(() => isUploading = true);
                      await APIs.sendChatImage(widget.user, File(i.path));
                      setState(() => isUploading = false);
                    }

                  },
                      icon: Icon(Icons.image,color: Colors.blueAccent,size: 28,)),

                  IconButton(onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    // Pick an image
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 70);
                    if (image != null) {
                      //log('Image Path: ${image.path}' as num);
                      await APIs.sendChatImage(widget.user, File(image.path));
                    }
                  },
                      icon: Icon(Icons.camera_alt_rounded,color: Colors.blueAccent,size: 28,)),
                ],

              ),
            ),
          ),

          MaterialButton(
            onPressed: (){
               if (textController.text.isNotEmpty) {
                 APIs.sendMessage(widget.user, textController.text,Type.text);
                 textController.text='';
               }
            },
            minWidth: 0,
            padding: const EdgeInsets.only(top: 10,bottom: 10, right: 5, left: 10,),
            shape: const CircleBorder(),
            color: Colors.greenAccent,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 35,),),

          SizedBox(width: mq.width * .02),
        ],
      ),
    );
  }



}
