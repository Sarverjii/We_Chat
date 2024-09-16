import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to We Chat"),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Positioned(
                top: mq.height * 0.15,
                width: mq.width * 0.6,
                left: mq.width * 0.2,
                child: Image.asset('images/icon.png')),
            Positioned(
                bottom: mq.height * 0.15,
                width: mq.width * 0.7,
                left: mq.width * 0.15,
                height: mq.height * 0.07,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 223, 255, 187),
                        shape: StadiumBorder(),
                        elevation: 1),
                    onPressed: () {},
                    icon: Image.asset(
                      "images/google.png",
                      height: mq.height * 0.04,
                    ),
                    label: RichText(
                        text: const TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                          TextSpan(text: "Sign in with "),
                          TextSpan(
                              text: "Google",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ])))),
          ],
        ));
  }
}
