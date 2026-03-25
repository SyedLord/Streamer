// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> setupYouTubeLiveEvent(
  String? token,
  String? title,
  String? privacy,
  String? categoryId,
  String? thumbnailPath,
) async {
  if (token == null ||
      token.isEmpty ||
      title == null ||
      title.isEmpty ||
      privacy == null ||
      privacy.isEmpty ||
      categoryId == null ||
      categoryId.isEmpty) {
    print("Error: Missing essential details.");
    return null;
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  try {
    // ─── STEP 1: Broadcast banao ───────────────────────────────────────────
    print("1. Creating Broadcast...");
    final broadcastRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts?part=snippet,status,contentDetails'),
      headers: headers,
      body: jsonEncode({
        "snippet": {
          "title": title,
          "description": "Live Streamed from SyedLord Studio",
          "scheduledStartTime": DateTime.now().toUtc().toIso8601String()
        },
        "status": {"privacyStatus": privacy},
        "contentDetails": {
          "enableAutoStart": true,
          "enableAutoStop": true,
          // ✅ Ye flag zaroori hai — bina iske YouTube DVR data store karta
          // hai aur transition mein delay aata hai
          "enableDvr": false,
          "recordFromStart": false,
        }
      }),
    );

    if (broadcastRes.statusCode != 200) {
      print("Broadcast failed: ${broadcastRes.body}");
      return null;
    }

    final broadcastId = jsonDecode(broadcastRes.body)['id'];
    print("Broadcast ID: $broadcastId");

    // ─── STEP 2: Category set karo ────────────────────────────────────────
    print("2. Setting category: $categoryId...");
    final categoryRes = await http.put(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/videos?part=snippet'),
      headers: headers,
      body: jsonEncode({
        "id": broadcastId,
        "snippet": {
          "title": title,
          "categoryId": categoryId,
          "description": "Live Streamed from SyedLord Studio"
        }
      }),
    );

    if (categoryRes.statusCode != 200) {
      print("Warning: Category failed (non-fatal): ${categoryRes.body}");
    }

    // ─── STEP 3: Thumbnail upload karo ────────────────────────────────────
    if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
      print("3. Uploading thumbnail...");
      await _uploadThumbnail(
          token: token, videoId: broadcastId, thumbnailPath: thumbnailPath);
    }

    // ─── STEP 4: Stream key banao ─────────────────────────────────────────
    print("4. Generating stream key...");
    final streamRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveStreams?part=snippet,cdn,status'),
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
      print("Stream key failed: ${streamRes.body}");
      return null;
    }

    final streamData = jsonDecode(streamRes.body);
    final streamId = streamData['id'];
    final newStreamKey = streamData['cdn']['ingestionInfo']['streamName'];

    // ─── STEP 5: Bind karo ────────────────────────────────────────────────
    print("5. Binding stream to broadcast...");
    final bindRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts/bind?id=$broadcastId&part=id&streamId=$streamId'),
      headers: headers,
    );

    if (bindRes.statusCode != 200) {
      print("Bind failed: ${bindRes.body}");
      return null;
    }

    // ─── STEP 6: FFmpeg connect hone ka wait karo, phir manually transition
    // enableAutoStart par rely nahi kar rahe — khud transition kar rahe hain
    print("6. Waiting for stream to become active before transitioning...");
    final transitioned = await _waitAndTransitionToLive(
      token: token,
      broadcastId: broadcastId,
      streamId: streamId,
      headers: headers,
    );

    if (!transitioned) {
      // Non-fatal — enableAutoStart phir bhi try karega
      print("Warning: Manual transition failed, relying on enableAutoStart.");
    }

    print("SUCCESS! Stream key ready: $newStreamKey");
    return newStreamKey;
  } catch (e) {
    print("Unexpected error: $e");
    return null;
  }
}

// ─── STREAM ACTIVE HONE KA WAIT KARO, PHIR LIVE KARO ─────────────────────────
// YouTube require karta hai ke stream "active" ho pehle transition se
// Ye function FFmpeg connect hone ke baad stream health check karta hai
Future<bool> _waitAndTransitionToLive({
  required String token,
  required String broadcastId,
  required String streamId,
  required Map<String, String> headers,
}) async {
  // Max 2 minute wait karo (24 attempts x 5 seconds)
  const maxAttempts = 24;
  const waitDuration = Duration(seconds: 5);

  for (int attempt = 1; attempt <= maxAttempts; attempt++) {
    print("Checking stream health (attempt $attempt/$maxAttempts)...");
    await Future.delayed(waitDuration);

    try {
      // Stream ki health check karo
      final healthRes = await http.get(
        Uri.parse(
            'https://youtube.googleapis.com/youtube/v3/liveStreams?part=status&id=$streamId'),
        headers: headers,
      );

      if (healthRes.statusCode != 200) continue;

      final healthData = jsonDecode(healthRes.body);
      final items = healthData['items'] as List?;
      if (items == null || items.isEmpty) continue;

      final streamStatus = items[0]['status']['streamStatus'];
      print("Stream status: $streamStatus");

      // "active" matlab FFmpeg connected hai aur data aa raha hai
      if (streamStatus == 'active') {
        print("Stream is active! Transitioning broadcast to LIVE...");

        final transitionRes = await http.post(
          Uri.parse(
              'https://youtube.googleapis.com/youtube/v3/liveBroadcasts/transition?broadcastStatus=live&id=$broadcastId&part=status'),
          headers: headers,
        );

        if (transitionRes.statusCode == 200) {
          print("Broadcast is now LIVE!");
          return true;
        } else {
          print("Transition failed: ${transitionRes.body}");
          return false;
        }
      }
    } catch (e) {
      print("Health check error (attempt $attempt): $e");
    }
  }

  print("Timeout: Stream never became active in 2 minutes.");
  return false;
}

// ─── THUMBNAIL HELPER (same as before) ───────────────────────────────────────
Future<void> _uploadThumbnail({
  required String token,
  required String videoId,
  required String thumbnailPath,
}) async {
  try {
    final imageFile = File(thumbnailPath);
    if (!await imageFile.exists()) {
      print("Thumbnail not found: $thumbnailPath");
      return;
    }

    final imageBytes = await imageFile.readAsBytes();
    final extension = thumbnailPath.split('.').last.toLowerCase();
    final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

    if (imageBytes.length > 2 * 1024 * 1024) {
      print("Warning: Thumbnail over 2MB, upload may fail.");
    }

    final thumbnailRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/upload/youtube/v3/thumbnails/set?videoId=$videoId&uploadType=media'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': mimeType,
        'Content-Length': imageBytes.length.toString(),
      },
      body: imageBytes,
    );

    if (thumbnailRes.statusCode == 200) {
      print("Thumbnail uploaded successfully.");
    } else {
      print("Thumbnail failed (non-fatal): ${thumbnailRes.body}");
    }
  } catch (e) {
    print("Thumbnail error (non-fatal): $e");
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
