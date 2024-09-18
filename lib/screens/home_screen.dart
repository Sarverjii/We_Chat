import 'package:flutter/cupertino.dart';
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
  List<ChatUser> _list = [];
  //List that stores all the Users that match the search
  List<ChatUser> _searchList = [];

//the boolean that tells us if the user is searching or not
  bool isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Gets the Current User Info in APIs.me
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    //We use GestureDectector so that when we click on someplace other than
    //the keyboard the keyboard is hidden
    return GestureDetector(
      //Hides the keyboard on clicking something else
      onTap: () => FocusScope.of(context).unfocus(),
      //We us PopScope to ensure
      //if we are searching back button closes the search
      //if we are not searching back button closes the app
      child: PopScope(
        canPop: !isSearching,
        onPopInvokedWithResult: (didPop, result) {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            //Using ternary operator on isSearching to switch between title and search bar
            title: isSearching
                //Showwing Search bar if we click on search
                ? TextField(
                    decoration: const InputDecoration(
                        hintText: "Name, Email...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black38)),
                    //When search is clicked there is a cursor automatically on the search bar
                    autofocus: true,
                    onChanged: (value) {
                      _searchList.clear();
                      //checking each User
                      for (var i in _list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                //The title of the app bar if we are not searching
                : const Text("We Chat"),
            leading: const Icon(Icons.home),
            actions: [
              //Button to search within the connections
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                //Changing the icon using ternary operator on isSearching
                icon: isSearching
                    ? const Icon(CupertinoIcons.clear_circled_solid)
                    : const Icon(Icons.search),
              ),
              //Button to move to the Profile Screen
              IconButton(
                //Navigates to Profile Page
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
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (_list.isNotEmpty) {
                      // If the list is not empty, display the list of connections
                      return ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              isSearching ? _searchList.length : _list.length,
                          itemBuilder: (context, index) {
                            // Create a card for each user connection
                            return ChatUserCard(
                                user: isSearching
                                    ? _searchList[index]
                                    : _list[index]);
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
        ),
      ),
    );
  }
}
