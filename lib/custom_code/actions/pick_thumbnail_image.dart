// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'package:image_picker/image_picker.dart';

Future<String?> pickThumbnailImage() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth:
        1280, // YouTube ki 2MB limit ke andar rakhne ke liye [cite: 154, 199]
    maxHeight: 720,
    imageQuality: 85,
  );
  return image?.path;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
