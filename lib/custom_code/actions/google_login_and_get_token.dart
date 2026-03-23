// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'package:google_sign_in/google_sign_in.dart';

Future<String?> googleLoginAndGetToken() async {
  try {
    // Google SignIn shuru karna aur YouTube ki permission mangna
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/youtube',
      ],
    );

    // User ko login popup dikhana
    final GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account != null) {
      // Login successful! Ab hum token nikalenge
      final GoogleSignInAuthentication auth = await account.authentication;
      return auth.accessToken; // Yeh hai hamari API ki chabi!
    }
  } catch (error) {
    print("Google Login mein masla aagaya: $error");
    return null;
  }
  return null;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
