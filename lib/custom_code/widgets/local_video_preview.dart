// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'dart:io';
import 'package:video_player/video_player.dart';

class LocalVideoPreview extends StatefulWidget {
  const LocalVideoPreview({
    Key? key,
    this.width,
    this.height,
    this.videoPath, // Naya parameter (Path lega, Bytes nahi)
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? videoPath;

  @override
  _LocalVideoPreviewState createState() => _LocalVideoPreviewState();
}

class _LocalVideoPreviewState extends State<LocalVideoPreview> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  // Jab naya path aaye toh player reload ho
  @override
  void didUpdateWidget(LocalVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPath != oldWidget.videoPath) {
      _controller?.dispose();
      setState(() {
        _isInitialized = false;
      });
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    // Agar path khali hai toh wapas jao
    if (widget.videoPath == null || widget.videoPath!.isEmpty) return;

    // Direct phone ki storage wali file pakar rahe hain (No RAM usage)
    File videoFileObj = File(widget.videoPath!);

    if (!videoFileObj.existsSync()) {
      print("File nahi mili!");
      return;
    }

    _controller = VideoPlayerController.file(videoFileObj)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller!.setLooping(true); // Loop set kar diya
        }
      }).catchError((error) {
        print("Player error: $error");
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Icon(
                  _controller!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white.withOpacity(0.7),
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
