import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/auth/login_screen.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user; // ChatUser object passed from the previous screen
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar with title "Profile Screen"
        title: const Text("Profile Screen"),
      ),
      // FloatingActionButton for logging out
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            Dialogs.showProgressBar(context);
            // Sign out from Firebase and Google, then navigate to the Login Screen
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                //Removing The Progress Bar
                Navigator.pop(context);
                //Moving Back to the Home Screen
                Navigator.pop(context);
                //Moving to the login Screen
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              });
            });
          },
          icon: const Icon(Icons.logout),
          label: const Text("Log Out"),
        ),
      ),
      // Body of the profile screen
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.1),
        child: Column(
          children: [
            SizedBox(
              // Spacer to add padding at the top
              width: mq.width,
              height: mq.height * 0.05,
            ),
            // Circular profile picture using CachedNetworkImage
            Stack(
              children: [
                CircleAvatar(
                  radius: mq.height * 0.1, // Radius for the profile picture
                  backgroundImage: CachedNetworkImageProvider(
                      widget.user.image), // User image from ChatUser object
                  child: null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                      onPressed: () {},
                      shape: CircleBorder(),
                      color: Colors.white,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      )),
                )
              ],
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            // Displaying user email in Text widget
            Text(
              widget.user.email,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            // TextFormField to display and edit the user's name
            TextFormField(
              initialValue:
                  widget.user.name, // Prepopulate with the user's name
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.blue,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                hintText: "Eg : Rahul Gandhi",
                hintStyle: const TextStyle(color: Colors.black26),
                label: const Text("Name :"),
              ),
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            // TextFormField to display and edit the user's "about" information
            TextFormField(
              initialValue:
                  widget.user.about, // Prepopulate with user's "about" info
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  CupertinoIcons.info_circle_fill,
                  color: Colors.blue,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                hintText: "Eg : Feeling Lucky",
                hintStyle: const TextStyle(color: Colors.black26),
                label: const Text("About :"),
              ),
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            // Button to update the user's profile
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                minimumSize: Size(mq.width * 0.5, mq.height * 0.055),
              ),
              onPressed: () {
                // Code for updating the user's profile goes here
              },
              label: const Text(
                "Update",
                style: TextStyle(fontSize: 16),
              ),
              icon: const Icon(
                Icons.edit,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
