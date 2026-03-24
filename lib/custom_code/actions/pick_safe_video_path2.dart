// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';

// Channel name bilkul wahi hona chahiye jo Kotlin file mein hoga
const _channel = MethodChannel('com.yourapp/file_picker');

Future<String?> pickSafeVideoPath2() async {
  try {
    // Android native code ko awaaz lagayega file pick karne ke liye
    final String? contentUri = await _channel.invokeMethod('pickVideoUri');

    if (contentUri == null || contentUri.isEmpty) {
      print("Picker cancelled.");
      return null;
    }

    print("Got safe URI without copying: $contentUri");
    return contentUri;
  } on PlatformException catch (e) {
    print("Platform error: ${e.message}");
    return null;
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
