// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<bool> startBackgroundService(String streamTitle) async {
  try {
    String finalTitle =
        streamTitle.isNotEmpty ? streamTitle : "SyedLord Gaming Live";

    // ─── STEP 1: Foreground service start karo ────────────────────────────
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "🔴 Live: $finalTitle",
      notificationText: "Tap here to open app and manage stream.",
      notificationImportance: AndroidNotificationImportance.high,
      notificationIcon: AndroidResource(
        name: 'ic_launcher',
        defType: 'mipmap',
      ),
    );

    bool initialized =
        await FlutterBackground.initialize(androidConfig: androidConfig);
    if (!initialized) {
      print("Background service initialize nahi hua.");
      return false;
    }

    bool enabled = await FlutterBackground.enableBackgroundExecution();
    if (!enabled) {
      print("Background service enable nahi hua.");
      return false;
    }

    // ─── STEP 2: Ongoing notification — swipe se clear nahi hogi ──────────
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings),
    );

    await flutterLocalNotificationsPlugin.show(
      888,
      '🔴 Live: $finalTitle',
      'Tap here to open app and manage stream.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'stream_channel',
          'Live Stream Controls',
          channelDescription: 'Controls for your live stream',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true, // ✅ Swipe se clear nahi hogi
          autoCancel: false, // ✅ Tap se bhi clear nahi hogi
          // Koi action button nahi abhi
        ),
      ),
    );

    print("✅ Background service + ongoing notification active.");
    return true;
  } catch (e) {
    print("Background Service Error: $e");
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
