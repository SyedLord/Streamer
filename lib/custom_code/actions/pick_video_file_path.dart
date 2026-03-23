// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'package:file_picker/file_picker.dart';

Future<String?> pickVideoFilePath() async {
  try {
    // Yeh code video ko RAM mein load kiye bina sirf uska path layega
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
      withData: false, // YEH HAI MAGIC WORD! Is se OOM error nahi aayega.
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path; // Yeh FFmpeg ko dene wali chabi hai
    }
  } catch (e) {
    print("File picking mein masla: $e");
    return null;
  }
  return null;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
