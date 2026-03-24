// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports (Aapke pakray hue sahi naam ke sath)
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

Future startFFmpegStream(
  String? videoPath,
  String? streamUrl,
  String? streamKey,
) async {
  // Agar koi cheez miss hai toh stream start na ho
  if (videoPath == null || streamUrl == null || streamKey == null) {
    print("Error: Missing Data for Stream");
    return;
  }

  // YouTube ka mukammal RTMP URL banana
  String fullRtmpUrl = "$streamUrl/$streamKey";

  // FFmpeg ki command
  // -re ka matlab hai video ko uski original speed par stream karna
  // -c copy ka matlab hai phone ka processor use kiye bina direct file bhejna
  // String command = "-re -i \"$videoPath\" -c copy -f flv \"$fullRtmpUrl\"";
  // The Pure PS5 Direct Copy Command (Python Exact Match)
  // YouTube Optimized Command (Mobile Network Stutter Fix)
  // String command = "-re -i \"$videoPath\" "
  //     "-c:v libx264 -preset ultrafast "
  //     "-b:v 3000k -maxrate 3000k -bufsize 6000k "
  //     "-g 60 -c:a aac -b:a 128k -ar 44100 "
  //     "-f flv \"$fullRtmpUrl\"";
  // YouTube 1080p High-Quality Command
  String command = "-re -i \"$videoPath\" "
      "-c:v libx264 -preset ultrafast "
      "-b:v 6800k -maxrate 6800k -bufsize 13600k "
      "-g 60 -c:a aac -b:a 128k -ar 44100 "
      "-f flv \"$fullRtmpUrl\"";

  print("Starting stream with command: $command");

  // Stream start karna (Background mein chalti rahegi)
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
