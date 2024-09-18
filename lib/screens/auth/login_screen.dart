import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //The boolean used for the Main Icon Animation
  bool _isAnimate = false;

  @override
  void initState() {
    //Adds the Delay before starting the animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        //Sets the boolean that triggers the animation
        _isAnimate = true;
      });
    });

    super.initState();
  }

  //Handels the Login Button Click
  _handleGoogleBtnClick() {
    //To Show the Progress Bar
    Dialogs.showProgressBar(context);
    //Calling the Firebase Function for Google Signin
    _signInWithGoogle().then((user) async {
      //To Hide the Progress Bar
      Navigator.pop(context);
      //Checking if user is null and performing the required tasks
      if (user != null) {
        if (await APIs.existUser()) {
          log("User Exists");
          //Navigating to the Home Screen
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          log("Created User : ${user.user}");
          await APIs.createUser().then((value) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()))
              });
        }

        // log("\n User : ${user.user}");
        // log("\n User Additional Info : ${user.additionalUserInfo}");
      }
    });
  }

  //The Function Provided by Firebase for google Login
  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log("\n _signInWithGoogle $e");
      Dialogs.showSnackbar(context, "Something went wrong!!(Check Internet)");
      return null;
    }
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
            AnimatedPositioned(
                duration: const Duration(seconds: 1),
                top: mq.height * 0.15,
                width: mq.width * 0.6,
                //Using ternary operator to do the animation
                left: _isAnimate ? mq.width * 0.2 : mq.width,
                child: Image.asset('images/icon.png')),
            //The google sign in button
            Positioned(
                bottom: mq.height * 0.15,
                width: mq.width * 0.7,
                left: mq.width * 0.15,
                height: mq.height * 0.07,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 223, 255, 187),
                        shape: const StadiumBorder(),
                        elevation: 1),
                    onPressed: () {
                      //Navigates to the HomeScreen and we use pushReplacement so that the user cannot come back to this screen
                      _handleGoogleBtnClick();
                    },
                    //Puts the google Icon
                    icon: Image.asset(
                      "images/google.png",
                      height: mq.height * 0.04,
                    ),
                    label: RichText(
                        text: const TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                          TextSpan(text: "Login with "),
                          TextSpan(
                              text: "Google",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ])))),
          ],
        ));
  }
}
