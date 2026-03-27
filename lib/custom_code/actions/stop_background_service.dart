// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_background/flutter_background.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

Future<void> stopBackgroundService() async {
  try {
    // 1. FFmpeg band karo
    await FFmpegKit.cancel();

    // 2. Foreground service (Single Notification) band karo
    if (FlutterBackground.isBackgroundExecutionEnabled) {
      await FlutterBackground.disableBackgroundExecution();
    }

    // 3. App State theek karo
    FFAppState().update(() {
      FFAppState().liveBitrate = 0.0;
      FFAppState().streamSecondsCounter = 0;
      FFAppState().bitrateHistory = [0.0];
      FFAppState().bitrateLabels = ["0s"];
      FFAppState().bitrateXData = [0];
      FFAppState().currentVideoId = '';
      FFAppState().currentStreamId = '';
      FFAppState().isStreamLive = false; // 🌟 Yeh lazmi hai
    });

    print("✅ Stream and single notification stopped.");
  } catch (e) {
    print("Stop Background Error: $e");
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
