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

  // ---> YEH NAYA HISSA HAI JO VIDEO CHANGE HONE PAR TRIGGER HOGA <---
  @override
  void didUpdateWidget(LocalVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check karega ke nayi file purani se alag hai ya nahi
    if (widget.videoFile != oldWidget.videoFile) {
      _controller?.dispose(); // Purani video ka engine band karega
      setState(() {
        _isInitialized = false; // Loading screen wapas layega
      });
      _initializeVideo(); // Nayi video ko load karega
    }
  }
  // ------------------------------------------------------------------

  Future<void> _initializeVideo() async {
    // Agar video bytes nahi hain toh wapas jao
    if (widget.videoFile.bytes == null) return;

    final tempDir = await getTemporaryDirectory();
    // Naya timestamp lagaya taake purani video cache na ho jaye
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempFile = File('${tempDir.path}/preview_$timestamp.mp4');

    await tempFile.writeAsBytes(widget.videoFile.bytes!);

    _controller = VideoPlayerController.file(tempFile)
      ..initialize().then((_) {
        // Yeh mounted check app ko crash hone se bachata hai agar user back chala jaye
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller!.setLooping(true);
        }
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
