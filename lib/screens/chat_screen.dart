import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textboxController = TextEditingController();
  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 240, 250),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Color.fromARGB(255, 179, 212, 233)),
          flexibleSpace: SafeArea(child: _appBar()),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading spinner while waiting for data
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    // Handle errors gracefully
                    return const Center(child: Text("Something went wrong"));
                  }

                  // Check if data is available and not empty
                  final data = snapshot.data?.docs;
                  if (data == null || data.isEmpty) {
                    // If there are no messages, show a "Say Hi!" message
                    return const Center(
                      child: Text(
                        "Say Hi!! 👋",
                        style: TextStyle(fontSize: 25),
                      ),
                    );
                  }

                  // Map Firestore documents to a list of messages
                  _list = data.map((e) => Message.fromJson(e.data())).toList();

                  // Display the list of messages
                  return ListView.builder(
                    padding: EdgeInsets.only(top: mq.height * 0.01),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _list.length,
                    itemBuilder: (context, index) {
                      return MessageCard(
                        message: _list[index],
                      );
                    },
                  );
                },
              ),
            ),
            _textBox(),
          ],
        ),
      ),
    );
  }

  Widget _textBox() {
    return Padding(
      padding: EdgeInsets.only(bottom: mq.height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Card(
              margin: EdgeInsets.only(
                left: mq.width * 0.05,
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions_rounded,
                        color: Colors.blueAccent,
                      )),
                  SizedBox(width: mq.width * 0.02), // Add some space
                  Expanded(
                    child: TextField(
                      controller: textboxController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                      minLines: 1,
                      decoration: const InputDecoration(
                          hintText: "Type Something...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.blueAccent)),
                      autofocus: true,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.photo, color: Colors.blueAccent)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt, color: Colors.blueAccent)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: mq.width * 0.19,
            child: MaterialButton(
              shape: const CircleBorder(),
              onPressed: () {
                //Sending Message
                if (textboxController.text.isNotEmpty) {
                  APIs.sendMessage(
                      widget.user, textboxController.text.toString());
                  textboxController.text = '';
                }
              },
              minWidth: 0,
              color: Colors.green,
              child: const Padding(
                padding: EdgeInsets.only(right: 5, top: 8, left: 8, bottom: 8),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              icon: const Icon(
                Icons.keyboard_backspace,
                color: Colors.black54,
              )),
          CircleAvatar(
            radius: mq.height * 0.025, // Radius for the profile picture
            backgroundImage: CachedNetworkImageProvider(
                widget.user.image), // User image from ChatUser object
            child: null,
          ),
          SizedBox(width: mq.width * 0.05),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              Text(
                "Last seen on ${widget.user.lastActive}",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              )
            ],
          )
        ],
      ),
    );
  }
}
