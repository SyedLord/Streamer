// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_background/flutter_background.dart';
import 'package:permission_handler/permission_handler.dart'; // Battery bypass ke liye

Future<bool> startBackgroundService(String streamTitle) async {
  try {
    // 🌟 1. Battery Optimization Bypass (App ka gala ghontne se roke)
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    String finalTitle =
        streamTitle.isNotEmpty ? streamTitle : "SyedLord Gaming Live";

    // 🌟 2. Sirf EK Clean Notification (Foreground Service wali)
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "🔴 Live: $finalTitle",
      notificationText: "Tap here to open app and stop stream.",
      notificationImportance: AndroidNotificationImportance.normal,
      notificationIcon:
          AndroidResource(name: 'ic_launcher_foreground', defType: 'drawable'),
    );

    bool initialized =
        await FlutterBackground.initialize(androidConfig: androidConfig);

    if (initialized) {
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
