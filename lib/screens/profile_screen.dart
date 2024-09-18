// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.1),
            child: SingleChildScrollView(
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
                      _image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * 0.1),
                              child: Image.file(
                                File(_image!),
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircleAvatar(
                              radius: mq.height *
                                  0.1, // Radius for the profile picture
                              backgroundImage: CachedNetworkImageProvider(widget
                                  .user
                                  .image), // User image from ChatUser object
                              child: null,
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
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
                    onSaved: (newValue) => APIs.me.name = newValue ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    initialValue:
                        widget.user.name, // Prepopulate with the user's name
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        CupertinoIcons.person_fill,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
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
                    onSaved: (newValue) => APIs.me.about = newValue ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    initialValue: widget
                        .user.about, // Prepopulate with user's "about" info
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        CupertinoIcons.info_circle_fill,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateFirebase().then((value) =>
                            Dialogs.showSnackbar(
                                context, "Profile Updated Succesfully"));
                      }
                      APIs.updateProfilePicture(File(_image!));

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
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return Padding(
            padding: EdgeInsets.only(
                top: mq.height * 0.03, bottom: mq.height * 0.05),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  "Pick Profile Picture",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            fixedSize: Size(mq.width * 0.35, mq.width * 0.35)),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            log("Image path ${image.path} mime type - ${image.mimeType}");
                            setState(() {
                              _image = image.path;
                            });
                            //APIs.updateProfilePicture(File(_image!));

                            //For hiding the bottom index
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset(
                          "images/image.png",
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(mq.width * 0.35, mq.width * 0.35)),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.camera);

                          if (photo != null) {
                            log("Photo path ${photo.path}");
                            setState(() {
                              _image = photo.path;
                            });

                            //APIs.updateProfilePicture(File(_image!));
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset(
                          "images/camera.png",
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }
}
