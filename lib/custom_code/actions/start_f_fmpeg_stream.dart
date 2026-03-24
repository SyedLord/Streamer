// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

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

  // ✅ Sirf yahan se quotes hatao — content:// URI mein quotes nahi lagte
  String command = "-re -i $videoPath "
      "-c:v libx264 -preset ultrafast "
      "-b:v 6800k -maxrate 6800k -bufsize 13600k "
      "-g 60 -c:a aac -b:a 128k -ar 44100 "
      "-f flv \"$fullRtmpUrl\""; // RTMP URL par quotes rehne chahiye

  print("Starting stream with command: $command");

  FFmpegKit.executeAsync(command, (session) async {
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      print("SUCCESS: Stream completely finished.");
    } else if (ReturnCode.isCancel(returnCode)) {
      print("CANCELLED: Stream was stopped by user.");
    } else {
      print("ERROR: Stream failed with return code $returnCode.");
    }
  });
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
