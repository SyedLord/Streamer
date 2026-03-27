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

Future<bool> showNativeDialog(
  String title,
  String message,
  String confirmText,
  String cancelText,
) async {
  try {
    final bool? result = await _dialogChannel.invokeMethod('showNativeDialog', {
      'title': title,
      'message': message,
      'confirmText': confirmText,
      'cancelText': cancelText,
    });
    return result ?? false;
  } catch (e) {
    print("Dialog error: $e");
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
