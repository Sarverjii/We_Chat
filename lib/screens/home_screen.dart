import 'package:flutter/material.dart';

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
            onPressed: () {},
            icon: Icon(Icons.more_vert),
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
