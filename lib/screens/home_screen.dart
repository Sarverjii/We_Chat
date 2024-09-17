import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/screens/auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("We Chat"),
        //Adds the Home Icon
        leading: const Icon(Icons.home),
        actions: [
          //Adds the Search Icon
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          //Adds the Menu Icon
          IconButton(
            onPressed: () async {
              // Login for Logout
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      //Adds the Floating Button Icon that helps in creating new conversation
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add_comment_outlined,
          ),
        ),
      ),
      body: const Center(
        child: Text("We Chat"),
      ),
    );
  }
}
