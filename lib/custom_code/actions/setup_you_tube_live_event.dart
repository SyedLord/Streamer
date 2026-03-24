// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> setupYouTubeLiveEvent(
  String? token,
  String? title,
  String? privacy,
  String? categoryId,
) async {
  if (token == null ||
      token.isEmpty ||
      title == null ||
      title.isEmpty ||
      privacy == null ||
      privacy.isEmpty ||
      categoryId == null ||
      categoryId.isEmpty) {
    print("Error: Missing essential details for YouTube stream.");
    return null;
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  try {
    // ─── STEP 1: Create Broadcast (categoryId intentionally OMITTED) ───────
    print("1. Creating Broadcast (Title: $title, Privacy: $privacy)...");
    final broadcastRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts?part=snippet,status,contentDetails'),
      headers: headers,
      body: jsonEncode({
        "snippet": {
          "title": title,
          "description": "Live Streamed from SyedLord Studio",
          "scheduledStartTime": DateTime.now().toUtc().toIso8601String()
          // ❌ categoryId is NOT placed here — YouTube ignores it silently
        },
        "status": {"privacyStatus": privacy},
        "contentDetails": {"enableAutoStart": true, "enableAutoStop": true}
      }),
    );

    if (broadcastRes.statusCode != 200) {
      print("Failed to create broadcast. Response: ${broadcastRes.body}");
      return null;
    }

    final broadcastData = jsonDecode(broadcastRes.body);
    final broadcastId = broadcastData['id'];
    print("Broadcast created. ID: $broadcastId");

    // ─── STEP 2: Set categoryId via videos.update ──────────────────────────
    // The broadcastId IS the videoId for a live broadcast on YouTube.
    // categoryId must be set here on the videos resource, not liveBroadcasts.
    print("2. Setting Category ID ($categoryId) via videos.update...");
    final categoryRes = await http.put(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/videos?part=snippet'),
      headers: headers,
      body: jsonEncode({
        "id": broadcastId,
        "snippet": {
          "title": title, // Required: must re-send title
          "categoryId": categoryId, // ✅ This is the correct place for it
          "description": "Live Streamed from SyedLord Studio"
        }
      }),
    );

    if (categoryRes.statusCode != 200) {
      // Non-fatal: log the failure but continue — stream still works,
      // just without the custom category.
      print(
          "Warning: Category update failed (non-fatal). Response: ${categoryRes.body}");
    } else {
      print("Category set successfully to ID: $categoryId");
    }

    // ─── STEP 3: Generate New Stream Key ──────────────────────────────────
    print("3. Generating New Stream Key...");
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

    if (streamRes.statusCode != 200) {
      print("Failed to generate stream key. Response: ${streamRes.body}");
      return null;
    }

    final streamData = jsonDecode(streamRes.body);
    final streamId = streamData['id'];
    final newStreamKey = streamData['cdn']['ingestionInfo']['streamName'];

    // ─── STEP 4: Bind Stream to Broadcast ─────────────────────────────────
    print("4. Binding Stream to Broadcast...");
    final bindRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts/bind?id=$broadcastId&part=id&streamId=$streamId'),
      headers: headers,
    );

    if (bindRes.statusCode != 200) {
      print("Failed to bind stream. Response: ${bindRes.body}");
      return null;
    }

    print("SUCCESS! Stream ready. Key: $newStreamKey");
    return newStreamKey;
  } catch (e) {
    print("Unexpected error: $e");
    return null;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
