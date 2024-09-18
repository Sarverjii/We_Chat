import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user.dart';

class APIs {
  //for saving current user info
  static late ChatUser me;

  //For Authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //To return Current User
  static get currentUser => auth.currentUser!;

  //For Accesing the Firebase Database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //For Accesing the Firebase Storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //Checking if the user is registered or not
  static Future<bool> existUser() async {
    return (await firestore.collection('users').doc(currentUser.uid).get())
        .exists;
  }

  //For getting current user info
  static Future<void> getSelfInfo() async {
    // Fetch the user document from Firestore
    final userDoc =
        await firestore.collection('users').doc(currentUser.uid).get();

    // Check if the document exists
    if (userDoc.exists) {
      // If it exists, populate the 'me' object with the data from Firestore
      me = ChatUser.fromJson(userDoc.data()!);
    } else {
      // If the user doesn't exist in Firestore, create a new user
      await createUser();
      await getSelfInfo(); // Re-fetch the user info after creation
    }
  }

  //For creating a new User
  static Future<void> createUser() async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final user = ChatUser(
        image: currentUser.photoURL.toString(),
        about: "Hi, I'm using We Chat",
        name: currentUser.displayName.toString(),
        createdAt: timestamp,
        lastActive: timestamp,
        isOnline: false,
        id: currentUser.uid,
        pushToken: '',
        email: currentUser.email.toString());

    return await firestore
        .collection('users')
        .doc(currentUser.uid)
        .set(user.toJson());
  }

  //For getting all the users list except the current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return APIs.firestore
        .collection('users')
        .where('id', isNotEqualTo: currentUser.uid)
        .snapshots();
  }

//Updates the Firebase
  static Future<void> updateFirebase() async {
    firestore.collection('users').doc(currentUser.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  //For updating Profile Picture
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log("Extension is : $ext");
    final ref = storage.ref().child('profile_pictures/${currentUser.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((val) {
      log("Data Transfererd : ${val.bytesTransferred / 1000} kb");
    });
    me.image = await ref.getDownloadURL();

    await firestore.collection('users').doc(currentUser.uid).update({
      'image': me.image,
    });
  }

  ///*********************Messages Related API****************/

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return APIs.firestore.collection('messages').snapshots();
  }
}
