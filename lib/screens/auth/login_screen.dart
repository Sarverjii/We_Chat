import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //The boolean used to
  bool _isAnimate = false;

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 500), () {
      setState(() {
        _isAnimate = true;
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
            AnimatedPositioned(
                duration: const Duration(seconds: 1),
                top: mq.height * 0.15,
                width: mq.width * 0.6,
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()));
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
