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
  String? categoryId,
) async {
  if (token == null || title == null || privacy == null || categoryId == null) {
    print("Error: Missing Details");
    return null;
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  try {
    print("1. Creating Broadcast (Title & Privacy)...");
    final broadcastRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts?part=snippet,status'),
      headers: headers,
      body: jsonEncode({
        "snippet": {
          "title": title,
          "categoryId": categoryId,
          "scheduledStartTime": DateTime.now().toUtc().toIso8601String()
        },
        // "status": {"privacyStatus": privacy}
        "status": {
          "privacyStatus": privacy,
          "selfBroadcast": true,
          "enableAutoStart": true,
          "enableAutoStop": true
        }
      }),
    );

    if (broadcastRes.statusCode != 200) return null;
    final broadcastId = jsonDecode(broadcastRes.body)['id'];

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

    if (streamRes.statusCode != 200) return null;
    final streamData = jsonDecode(streamRes.body);
    final streamId = streamData['id'];
    // Yeh rahi hamari nayi Stream Key!
    final newStreamKey = streamData['cdn']['ingestionInfo']['streamName'];

    print("3. Binding Stream to Broadcast...");
    final bindRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts/bind?id=$broadcastId&part=id&streamId=$streamId'),
      headers: headers,
    );

    if (bindRes.statusCode != 200) return null;

    print("SUCCESS! New Stream Key is Ready.");
    return newStreamKey; // Nayi key wapas bhej di
  } catch (e) {
    print("API Error: $e");
    return null;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
