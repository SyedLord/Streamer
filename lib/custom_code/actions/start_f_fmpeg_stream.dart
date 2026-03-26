// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new/statistics.dart';

// Claude ki batayi hui local variables
DateTime _lastStatUpdate = DateTime.fromMillisecondsSinceEpoch(0);
int _localSecondsCounter = 0;

Future startFFmpegStream(
  String? videoPath,
  String? streamUrl,
  String? streamKey,
) async {
  if (videoPath == null || streamUrl == null || streamKey == null) {
    print("Error: Missing Data");
    return;
  }

  String fullRtmpUrl = "$streamUrl/$streamKey";
  String inputPath = videoPath;

  if (videoPath.startsWith('content://')) {
    inputPath =
        await FFmpegKitConfig.getSafParameterForRead(videoPath) ?? videoPath;
  }

  String command = "-re -i \"$inputPath\" "
      "-c:v libx264 -preset ultrafast "
      "-b:v 6800k -maxrate 6800k -bufsize 13600k "
      "-g 60 -c:a aac -b:a 128k -ar 44100 "
      "-f flv \"$fullRtmpUrl\"";

  // Nayi stream par state clear karna
  FFAppState().update(() {
    FFAppState().streamSecondsCounter = 0;
    FFAppState().bitrateHistory = [];
    FFAppState().bitrateLabels = [];
    FFAppState().bitrateXData = [];
  });

  _localSecondsCounter = 0;

  FFmpegKit.executeAsync(
      command,
      (session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          print("SUCCESS: Stream finished.");
        } else {
          print("Stream ended with code $returnCode.");
        }
      },
      (log) {},
      (statistics) {
        try {
          // 🟢 THROTTLE: Har 1 second mein sirf ek dafa andar aane do
          final now = DateTime.now();
          if (now.difference(_lastStatUpdate).inMilliseconds < 1000) return;
          _lastStatUpdate = now;

          double rawBitrate = statistics.getBitrate();
          if (rawBitrate <= 0) return;

          double mbps = double.parse((rawBitrate / 1000.0).toStringAsFixed(1));

          _localSecondsCounter += 1;
          int currentSec = _localSecondsCounter;
          String timeLabel = currentSec < 60
              ? "${currentSec}s"
              : "${currentSec ~/ 60}m${currentSec % 60}s";

          // 🟢 Ek hi update call mein sab kuch karna
          final history = List<double>.from(FFAppState().bitrateHistory)
            ..add(mbps);
          final labels = List<String>.from(FFAppState().bitrateLabels)
            ..add(timeLabel);
          final xData = List<int>.from(FFAppState().bitrateXData)
            ..add(currentSec);

          if (history.length > 9) {
            history.removeAt(0);
            labels.removeAt(0);
            xData.removeAt(0);
          }

          FFAppState().update(() {
            FFAppState().liveBitrate = mbps;
            FFAppState().streamSecondsCounter = currentSec;
            FFAppState().bitrateHistory = history;
            FFAppState().bitrateLabels = labels;
            FFAppState().bitrateXData = xData;
          });
        } catch (e) {
          print("Stats update error: $e");
        }
      });
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
