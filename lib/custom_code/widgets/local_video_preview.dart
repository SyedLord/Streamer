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
import 'package:path_provider/path_provider.dart';

class LocalVideoPreview extends StatefulWidget {
  const LocalVideoPreview({
    Key? key,
    this.width,
    this.height,
    required this.videoFile,
  }) : super(key: key);

  final double? width;
  final double? height;
  final FFUploadedFile videoFile;

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

  Future<void> _initializeVideo() async {
    // Agar video bytes nahi hain toh wapas jao
    if (widget.videoFile.bytes == null) return;

    // Video ko temp directory mein save karna taake player read kar sake
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/preview_video.mp4');
    await tempFile.writeAsBytes(widget.videoFile.bytes!);

    // Player ko file assign karna
    _controller = VideoPlayerController.file(tempFile)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller!.setLooping(true); // Khatam hone par dobara shuru
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Jab tak video load ho rahi hai, Lal rang ka loading circle dikhaye
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

    // Load hone ke baad Video aur Play/Pause button dikhaye
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
          // Play aur Pause button ka design
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
