// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports lazmi add karein
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

Future startFFmpegStream(
    FFUploadedFile videoData, String streamUrl, String streamKey) async {
  String rtmpUrl = '$streamUrl/$streamKey';

  final tempDir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final tempFilePath = '${tempDir.path}/live_stream_$timestamp.mp4';

  final tempFile = File(tempFilePath);
  await tempFile.writeAsBytes(videoData.bytes!);

  print("✅ Video file save ho gayi hai temp path par: $tempFilePath");

  String command =
      '-re -i "$tempFilePath" -c copy -f flv -flvflags no_duration_filesize "$rtmpUrl"';

  FFmpegKit.executeAsync(command, (session) async {
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      print("Stream Makkhan chal rahi hai!");
    } else {
      print("Bhai koi error aa gaya stream mein.");
    }
  });
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
