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

Future<void> showNativeToast(
  String message,
  bool isLong, // Agar true hoga toh zyada dair tak screen par rahega
) async {
  try {
    await _dialogChannel.invokeMethod('showNativeToast', {
      'message': message,
      'isLong': isLong,
    });
  } catch (e) {
    print("Native Toast error: $e");
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
