// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'dart:io';
import 'package:video_player/video_player.dart';

class LocalVideoPreview2 extends StatefulWidget {
  const LocalVideoPreview2({
    Key? key,
    this.width,
    this.height,
    this.videoPath, // Naya parameter (Path lega, Bytes nahi)
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? videoPath;

  @override
  _LocalVideoPreview2State createState() => _LocalVideoPreview2State();
}

class _LocalVideoPreview2State extends State<LocalVideoPreview2> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  // Jab naya path aaye toh player reload ho
  @override
  void didUpdateWidget(LocalVideoPreview2 oldWidget) {
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
    if (widget.videoPath == null || widget.videoPath!.isEmpty) return;

    VideoPlayerController newController;

    // NAYA LOGIC: Agar rasta 'content://' se shuru ho raha hai (SAF URI)
    if (widget.videoPath!.startsWith('content://')) {
      newController =
          VideoPlayerController.contentUri(Uri.parse(widget.videoPath!));
    } else {
      // Purana Fallback (agar koi normal path aaye)
      File videoFileObj = File(widget.videoPath!);
      if (!videoFileObj.existsSync()) return;
      newController = VideoPlayerController.file(videoFileObj);
    }

    _controller = newController;

    await _controller!.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller!.setLooping(true);
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
