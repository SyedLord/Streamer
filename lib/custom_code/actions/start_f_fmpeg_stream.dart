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

  FFmpegKit.executeAsync(command, (session) async {
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      print("SUCCESS: Stream finished.");
    } else if (ReturnCode.isCancel(returnCode)) {
      print("CANCELLED: Stream stopped.");
    } else {
      final logs = await session.getLogs();
      logs.reversed
          .take(5)
          .forEach((log) => print("FFmpeg: ${log.getMessage()}"));
      print("ERROR: Code $returnCode");
    }
  });
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
