// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> setupYouTubeLiveEvent(
  String? token,
  String? title,
  String? privacy,
  String? categoryId, // String numeric category pass
) async {
  // Master check: If essential strings are null or EMPTY, fail fast and return null.
  if (token == null ||
          token.isEmpty ||
          title == null ||
          title.isEmpty ||
          privacy == null ||
          privacy.isEmpty ||
          categoryId == null ||
          categoryId.isEmpty // This check was missing!
      ) {
    print("Error: Missing essential details for YouTube stream.");
    return null;
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  try {
    print("1. Creating Broadcast (Title, Privacy, Category: $categoryId)...");
    final broadcastRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts?part=snippet,status,contentDetails'),
      headers: headers,
      body: jsonEncode({
        "snippet": {
          "title": title,
          "categoryId":
              categoryId, // Passing the validated string category ID directly.
          "description": "Live Streamed from SyedLord Studio",
          "scheduledStartTime": DateTime.now().toUtc().toIso8601String()
        },
        "status": {"privacyStatus": privacy},
        // Auto-start and auto-stop are essential for professional streaming.
        "contentDetails": {"enableAutoStart": true, "enableAutoStop": true}
      }),
    );

    // Safety check for broadcast creation.
    if (broadcastRes.statusCode != 200) {
      print(
          "Failed to create broadcast. YouTube API Response: ${broadcastRes.body}");
      return null;
    }
    final broadcastData = jsonDecode(broadcastRes.body);
    final broadcastId = broadcastData['id'];

    print("2. Generating New Stream Key...");
    final streamRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveStreams?part=snippet,cdn'),
      headers: headers,
      body: jsonEncode({
        "snippet": {"title": "$title - Stream"},
        "cdn": {
          "frameRate": "variable",
          "ingestionType": "rtmp",
          "resolution": "variable"
        }
      }),
    );

    // Safety check for stream key generation.
    if (streamRes.statusCode != 200) {
      print(
          "Failed to generate stream key. YouTube API Response: ${streamRes.body}");
      return null;
    }
    final streamData = jsonDecode(streamRes.body);
    final streamId = streamData['id'];
    // This is the essential key we need to pass to FFmpeg.
    final newStreamKey = streamData['cdn']['ingestionInfo']['streamName'];

    print("3. Binding Stream to Broadcast...");
    final bindRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts/bind?id=$broadcastId&part=id&streamId=$streamId'),
      headers: headers,
    );

    // Safety check for binding.
    if (bindRes.statusCode != 200) {
      print(
          "Failed to bind stream to broadcast. YouTube API Response: ${bindRes.body}");
      return null;
    }

    print(
        "SUCCESS! Livestream event generated and bound. Key is ready: $newStreamKey");
    return newStreamKey; // Success, return the key.
  } catch (e) {
    print("An unexpected API error occurred: $e");
    return null; // Unexpected error, return null.
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
