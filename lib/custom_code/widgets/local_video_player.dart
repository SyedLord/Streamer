// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'package:video_player/video_player.dart';
import 'dart:io';

class LocalVideoPlayer extends StatefulWidget {
  const LocalVideoPlayer({
    Key? key,
    this.width,
    this.height,
    this.videoPath,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? videoPath;

  @override
  _LocalVideoPlayerState createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  // Jab video ka path change ho, player ko reload karna zaroori hai
  @override
  void didUpdateWidget(covariant LocalVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _controller.dispose();
      _initialized = false;
      _initializePlayer();
    }
  }

  // Local file path se player initialize karna
  void _initializePlayer() {
    if (widget.videoPath == null || widget.videoPath!.isEmpty) return;

    // File object banana local path se
    File videoFile = File(widget.videoPath!);
    if (!videoFile.existsSync()) {
      print("Video file nahi mili: ${widget.videoPath}");
      return;
    }

    _controller = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
          _controller.setLooping(true); // Preview loop hota rahay
          _controller.play(); // Auto-play
        });
      }).catchError((error) {
        print("Video initialize karne mein error: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoPath == null || widget.videoPath!.isEmpty) {
      return const Center(child: Text("Koi video select nahi ki"));
    }

    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // AspectRatio widget video ke sahi dimensions maintain karta hai
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
