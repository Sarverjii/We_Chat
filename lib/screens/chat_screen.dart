import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/home_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 179, 212, 233),
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
                  // Stream that listens to changes in the 'Messages' collection in Firestore
                  stream: APIs.getAllMessages(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                          //While waiting for the connection, show a loading spinner
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        // Once data is received, process it
                        final data = snapshot.data?.docs;
                        log("Data : ${jsonEncode(data![0].data())}");
                        // // Map the Firestore documents to a list of ChatUser objects
                        // _list =
                        //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        //         [];
                        final _list = [];

                        if (_list.isNotEmpty) {
                          // If the list is not empty, display the list of connections
                          return ListView.builder(
                              padding: EdgeInsets.only(top: mq.height * 0.01),
                              physics: const BouncingScrollPhysics(),
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                return Text("Messages : ${_list[index]}");
                              });
                        } else {
                          // If no connections are found, display a message
                          return const Center(
                            child: Text(
                              "Say Hi!! 👋",
                              style: TextStyle(fontSize: 25),
                            ),
                          );
                        }
                    }
                    ;
                  }),
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
                  const Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                      minLines: 1,
                      decoration: InputDecoration(
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
              onPressed: () {},
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
