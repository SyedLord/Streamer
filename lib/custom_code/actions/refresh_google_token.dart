// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_appauth/flutter_appauth.dart';

Future<String?> refreshGoogleToken(String savedRefreshToken) async {
  if (savedRefreshToken.isEmpty) return null;

  final FlutterAppAuth appAuth = FlutterAppAuth();
  final String clientId =
      '317407113056-18bu1c6uolr8jd8rmehrmv48tdg9fmea.apps.googleusercontent.com';
  final String redirectUrl = 'com.syedlord.streamer:/oauth2redirect';

  try {
    // 🌟 Bina kisi popup ke, Google ko refresh token bhejo aur naya access token lo
    final TokenResponse? result = await appAuth.token(
      TokenRequest(
        clientId,
        redirectUrl,
        refreshToken: savedRefreshToken,
        issuer: 'https://accounts.google.com',
      ),
    );

    if (result != null && result.accessToken != null) {
      print("Token Refreshed Successfully!");
      return result.accessToken; // Yeh raha aapka bilkul fresh token
    }
  } catch (e) {
    print("Silent Refresh Error: $e");
    return null;
  }
  return null;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
