// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'package:flutter_appauth/flutter_appauth.dart';

Future<String?> webGoogleLogin() async {
  final FlutterAppAuth appAuth = FlutterAppAuth();

  // YAHAN APNI CLIENT ID PASTE KAREIN (Google Cloud wali)
  final String clientId =
      '317407113056-18bu1c6uolr8jd8rmehrmv48tdg9fmea.apps.googleusercontent.com';

  // YAHAN APNA PACKAGE NAME LIKHEIN (Aur aage :/oauth2redirect waise hi rehne dein)
  final String redirectUrl = 'com.syedlord.streamer:/oauth2redirect';

  try {
    final AuthorizationTokenResponse? result =
        await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        clientId,
        redirectUrl,
        issuer: 'https://accounts.google.com',
        scopes: ['email', 'profile', 'https://www.googleapis.com/auth/youtube'],
        // YEH WOH JADOO HAI JO HAR DAFA ACCOUNT/CHANNEL CHOOSE KARWAYEGA!
        promptValues: ['select_account'],
      ),
    );

    if (result != null) {
      return result.accessToken;
    }
  } catch (e) {
    print("Web Login Error: $e");
    return null;
  }
  return null;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
