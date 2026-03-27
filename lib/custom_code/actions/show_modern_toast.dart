// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future showModernToast(
  BuildContext context,
  String message,
) async {
  // Pehle se agar koi toast khula hai toh usko band karo
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // Naya modern floating toast banao
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter', // Aap chahhein toh font change kar sakte hain
      ),
      textAlign: TextAlign.center, // Text ko center mein rakhne ke liye
    ),
    backgroundColor: const Color(0xFF1E1E1E), // Dark Glassy type color
    behavior: SnackBarBehavior
        .floating, // YEH HAI ASAL JADOO (Hawa mein tairne ke liye)
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.0), // Kinare bilkul gol (Round)
    ),
    margin: const EdgeInsets.only(
        bottom: 30.0, left: 24.0, right: 24.0), // Screen ke konon se door
    elevation: 8.0, // Thora sa shadow effect
    duration: const Duration(milliseconds: 2500), // 2.5 seconds baad khud gayab
  );

  // Toast ko screen par dikhao
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
