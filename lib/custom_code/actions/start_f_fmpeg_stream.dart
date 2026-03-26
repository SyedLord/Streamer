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
// 🛠️ FIX 1: Import ko theek kar diya (_new laga diya)
import 'package:ffmpeg_kit_flutter_new/statistics.dart';

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

  // 🛠️ FIX 2: Nayi stream shuru hone se pehle purana graph data zero/khaali karein
  FFAppState().update(() {
    FFAppState().streamSecondsCounter = 0;
    FFAppState().bitrateHistory = [];
    FFAppState().bitrateLabels = [];
    FFAppState().bitrateXData = [];
  });

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
      // 2. Log Callback (Errors aur details ke liye)
      (log) {
    // print("FFmpeg Log: ${log.getMessage()}");
  },
      // 3. STATISTICS CALLBACK (THE SLIDING WINDOW MAGIC)
      (statistics) {
    try {
      double rawBitrate = statistics.getBitrate();

      if (rawBitrate > 0) {
        double mbps = rawBitrate / 1000.0;
        double roundedMbps = double.parse(mbps.toStringAsFixed(1));

        FFAppState().update(() {
          // Bitrate update
          FFAppState().liveBitrate = roundedMbps;

          // 1. Time counter barhayein
          FFAppState().streamSecondsCounter += 1;
          int currentSec = FFAppState().streamSecondsCounter;

          // 2. Format banayein (e.g., 61s -> "1m1s")
          String timeLabel = "";
          if (currentSec < 60) {
            timeLabel = "${currentSec}s";
          } else {
            int m = currentSec ~/ 60; // Minutes nikalne ke liye
            int s = currentSec % 60; // Baqi bache seconds
            timeLabel = "${m}m${s}s";
          }

          // 3. Teeno lists fetch karein
          List<double> history = FFAppState().bitrateHistory;
          List<String> labels = FFAppState().bitrateLabels;
          List<int> xData = FFAppState().bitrateXData;

          // Naya data add karein
          history.add(roundedMbps);
          labels.add(timeLabel);
          xData.add(currentSec);

          // 4. Sirf aakhri 9 items rakhein (Sliding Window)
          if (history.length > 9) {
            history.removeAt(0);
            labels.removeAt(0);
            xData.removeAt(0);
          }

          // Wapas save karein
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
