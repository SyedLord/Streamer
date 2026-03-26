// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_background/flutter_background.dart';

Future<bool> startBackgroundService(String streamTitle) async {
  try {
    // Agar title khaali aaye toh default naam set karein
    String finalTitle =
        streamTitle.isNotEmpty ? streamTitle : "SyedLord Gaming Live";

    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "🔴 Live: $finalTitle",
      notificationText: "Tap here to open app and manage stream.",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'ic_launcher', defType: 'mipmap'), // Aapki app ka icon
    );

    // Permission aur initialization check karein
    bool initialized =
        await FlutterBackground.initialize(androidConfig: androidConfig);

    if (initialized) {
      // Notification screen par layen aur app ko background mein zinda rakhein
      return await FlutterBackground.enableBackgroundExecution();
    }
    return false;
  } catch (e) {
    print("Background Service Error: $e");
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
