// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'package:google_sign_in/google_sign_in.dart';

Future googleLogout() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Pehle sign out karega
    await googleSignIn.signOut();

    // Yeh disconnect wali line bohat zaroori hai!
    // Is se Google completely bhool jayega aur agli dafa account choose karne ka popup dega.
    await googleSignIn.disconnect();

    print("User successfully logged out!");
  } catch (error) {
    print("Logout mein thora masla aaya: $error");
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
