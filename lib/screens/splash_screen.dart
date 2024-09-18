import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:we_chat/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //Adds the delay of 1.5 seconds before we change the screen
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        //Brings back the UI of the Phone
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        //Sets the Control Center as Transparent
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.transparent));

        //Checking if the user is already signed in or not
        if (APIs.auth.currentUser != null) {
          log("\n User : ${APIs.auth.currentUser}");
          //Navigates to the HomeScreen without an option to come back
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          //Navigates to the LoginScreen without an option to come back
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Accessing the size of the screen
    mq = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to We Chat"),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            //The logo
            Positioned(
                top: mq.height * 0.15,
                width: mq.width * 0.6,
                left: mq.width * 0.2,
                child: Image.asset('images/icon.png')),
            //The google sign in button
            Positioned(
                bottom: mq.height * 0.15,
                width: mq.width * 0.7,
                left: mq.width * 0.15,
                height: mq.height * 0.07,
                child: const Center(
                    child: Text(
                  "Chat with Us ❤️",
                  style: TextStyle(
                      fontSize: 18, color: Colors.black87, letterSpacing: 2),
                ))),
          ],
        ));
  }
}
