// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new/statistics.dart';

// 🟢 CLAUDE'S OPTIMIZATION: Throttle ke liye local variables
DateTime _lastStatUpdate = DateTime.fromMillisecondsSinceEpoch(0);
int _localSecondsCounter = 0;

Future startFFmpegStream(
  String? videoPath,
  String? streamUrl,
  String? streamKey,
) async {
  if (videoPath == null || streamUrl == null || streamKey == null) {
    print("Error: Missing Data for Stream");
    return;
  }

  String fullRtmpUrl = "$streamUrl/$streamKey";
  String inputPath = videoPath;

  // content:// URI ko FFmpeg ki samajh mein translate karo
  if (videoPath.startsWith('content://')) {
    inputPath =
        await FFmpegKitConfig.getSafParameterForRead(videoPath) ?? videoPath;
    print("SAF translated path: $inputPath");
  }

  String command = "-re -i \"$inputPath\" "
      "-c:v libx264 -preset ultrafast "
      "-b:v 6800k -maxrate 6800k -bufsize 13600k "
      "-g 60 -c:a aac -b:a 128k -ar 44100 "
      "-f flv \"$fullRtmpUrl\"";

  print("Starting stream: $command");

  // 🛠️ THE CRASH FIX: Nayi stream shuru hone se pehle purana graph zero karein
  FFAppState().update(() {
    FFAppState().streamSecondsCounter = 0;
    FFAppState().bitrateHistory = [0.0];
    FFAppState().bitrateLabels = ["0s"];
    FFAppState().bitrateXData = [0];
  });

  // Reset local counter
  _localSecondsCounter = 0;

  FFmpegKit.executeAsync(command,
      // 1. Complete Callback (Jab stream band ho)
      (session) async {
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      print("SUCCESS: Stream finished.");
    } else if (ReturnCode.isCancel(returnCode)) {
      print("CANCELLED: Stream stopped.");
    } else {
      print("ERROR: Stream failed with code $returnCode.");
    }
  },
      // 2. Log Callback
      (log) {
    // print("FFmpeg Log: ${log.getMessage()}");
  },
      // 3. STATISTICS CALLBACK (THE SLIDING WINDOW + THROTTLE MAGIC)
      (statistics) {
    try {
      // 🟢 THROTTLE FIX: Har 1 second mein sirf ek dafa andar aane do
      final now = DateTime.now();
      if (now.difference(_lastStatUpdate).inMilliseconds < 1000) return;
      _lastStatUpdate = now;

      double rawBitrate = statistics.getBitrate();

      if (rawBitrate > 0) {
        double mbps = rawBitrate / 1000.0;
        double roundedMbps = double.parse(mbps.toStringAsFixed(1));

        // 1. Time counter barhayein (Local Variable use kiya, faster hai)
        _localSecondsCounter += 1;
        int currentSec = _localSecondsCounter;

        // 2. Format banayein (e.g., 61s -> "1m1s")
        String timeLabel = "";
        if (currentSec < 60) {
          timeLabel = "${currentSec}s";
        } else {
          int m = currentSec ~/ 60; // Minutes nikalne ke liye
          int s = currentSec % 60; // Baqi bache seconds
          timeLabel = "${m}m${s}s";
        }

        // 🟢 Ek hi list step mein merge karein (Claude Optimization)
        final history = List<double>.from(FFAppState().bitrateHistory)
          ..add(roundedMbps);
        final labels = List<String>.from(FFAppState().bitrateLabels)
          ..add(timeLabel);

        // 4. Sirf aakhri 5 items rakhein (Sliding Window)
        if (history.length > 5) {
          history.removeAt(0);
          labels.removeAt(0);
        }

        // 🌟 THE LABEL FIX: X-Data ko aage mat bhagao, hamesha lock rakho (0, 1, 2... 9)
        final xData = List<int>.generate(history.length, (index) => index);

        // Ek sath App State update karein
        FFAppState().update(() {
          FFAppState().liveBitrate = roundedMbps;
          FFAppState().streamSecondsCounter = currentSec;
          FFAppState().bitrateHistory = history;
          FFAppState().bitrateLabels = labels;
          FFAppState().bitrateXData = xData;
        });
      }
    } catch (e) {
      print("Stats update error: $e");
    }
  });
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
