import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/profile_screen.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List that stores all the user Connections
  List<ChatUser> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("We Chat"),
        leading: const Icon(Icons.home),
        actions: [
          //Button to search within the connections
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          //Button to move to the Profile Screen
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: APIs.me)));
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      //FLoating Button for creating new Connections
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_comment_outlined),
        ),
      ),
      body: StreamBuilder(
          // Stream that listens to changes in the 'users' collection in Firestore
          stream: APIs.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  // While waiting for the connection, show a loading spinner
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                // Once data is received, process it
                final data = snapshot.data?.docs;
                // Map the Firestore documents to a list of ChatUser objects
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
                if (list.isNotEmpty) {
                  // If the list is not empty, display the list of connections
                  return ListView.builder(
                      padding: EdgeInsets.only(top: mq.height * 0.01),
                      physics: BouncingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        // Create a card for each user connection
                        return ChatUserCard(user: list[index]);
                      });
                } else {
                  // If no connections are found, display a message
                  return const Center(
                    child: Text(
                      "No Connections Found!",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
            }
            ;
          }),
    );
  }
}
