// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';

const _dialogChannel = MethodChannel('com.syedlord.streamer/dialog');

Future<void> showNativeAlert(
  String title,
  String message,
  String okText,
) async {
  try {
    await _dialogChannel.invokeMethod('showNativeAlert', {
      'title': title,
      'message': message,
      'okText': okText,
    });
  } catch (e) {
    print("Alert error: $e");
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
