// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class LocalImagePreview extends StatefulWidget {
  const LocalImagePreview({
    Key? key,
    this.width,
    this.height,
    this.imagePath,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? imagePath;

  @override
  State<LocalImagePreview> createState() => _LocalImagePreviewState();
}

class _LocalImagePreviewState extends State<LocalImagePreview> {
  @override
  Widget build(BuildContext context) {
    // Agar koi path nahi hai, toh transparent box dikhao
    // taake piche wala "Upload" icon aur text nazar aaye
    if (widget.imagePath == null || widget.imagePath!.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.transparent,
      );
    }

    // Agar image select ho gayi hai:
    if (kIsWeb) {
      // Web preview ke liye
      return Image.network(
        widget.imagePath!,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
      );
    } else {
      // Asli Android/iOS device ke liye
      return Image.file(
        File(widget.imagePath!),
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
      );
    }
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
