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
      notificationText: "Streaming to YouTube...",
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

    // ─── STEP 2: Notification initialize karo ─────────────────────────────
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.actionId == 'stop_stream') {
          print("User ne notification se stream stop kiya.");
          // stopBackgroundService action call hoga
          await stopBackgroundService();
        }
      },
    );

    // ─── STEP 3: Stop button wali notification show karo ──────────────────
    await flutterLocalNotificationsPlugin.show(
      888,
      '🔴 Live: $finalTitle',
      'Streaming to YouTube...',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'stream_channel',
          'Live Stream Controls',
          channelDescription: 'Controls for your live stream',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false,
          actions: [
            AndroidNotificationAction(
              'stop_stream',
              '⏹ Stop Stream',
              cancelNotification: true,
              showsUserInterface: false,
            ),
          ],
        ),
      ),
    );

    print("✅ Notification with Stop button active.");
    return true;
  } catch (e) {
    print("Background Service Error: $e");
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
