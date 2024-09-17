import 'package:flutter/material.dart';

class Dialogs {
  //Function to show the SnackBar
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.blueAccent.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  //Function to show the ProgressBar
  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(child: CircularProgressIndicator()));
  }
}
