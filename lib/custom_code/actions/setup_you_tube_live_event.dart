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
  print("=== PARAMETER CHECK ===");
  print(
      "Token: ${token == null ? 'NULL' : token.isEmpty ? 'EMPTY' : 'OK (${token.substring(0, 15)}...)'}");
  print(
      "Title: ${title == null ? 'NULL' : title.isEmpty ? 'EMPTY' : 'OK: $title'}");
  print(
      "Privacy: ${privacy == null ? 'NULL' : privacy.isEmpty ? 'EMPTY' : 'OK: $privacy'}");
  print(
      "CategoryId: ${categoryId == null ? 'NULL' : categoryId.isEmpty ? 'EMPTY' : 'OK: $categoryId'}");
  print(
      "ThumbnailPath: ${thumbnailPath == null ? 'NULL' : thumbnailPath.isEmpty ? 'EMPTY' : 'OK: $thumbnailPath'}");
  print("=======================");

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
      print("Category failed (non-fatal): ${categoryRes.body}");
    } else {
      print("Category OK");
    }

    // ─── STEP 3: Thumbnail ─────────────────────────────────────────────────
    if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
      print("3. Uploading thumbnail...");
      await _uploadThumbnail(
          token: token, videoId: broadcastId, thumbnailPath: thumbnailPath);
    } else {
      print("3. No thumbnail, skipping.");
    }

    // ─── STEP 4: Stream key banao ──────────────────────────────────────────
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
    final newStreamKey = streamData['cdn']['ingestionInfo']['streamName'];
    final streamId = streamData['id'];
    print("Stream key OK: $newStreamKey");

    // ─── STEP 5: Bind karo ─────────────────────────────────────────────────
    print("5. Binding...");
    final bindRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts/bind?id=$broadcastId&part=id&streamId=$streamId'),
      headers: headers,
    );

    if (bindRes.statusCode != 200) {
      print("Bind failed: ${bindRes.body}");
      return null;
    }

    // ─── STEP 6: HATA DIYA ─────────────────────────────────────────────────
    // _waitAndTransitionToLive hata diya — enableAutoStart khud handle karta hai
    // FFmpeg connect hoga toh YouTube auto live kar dega

    print("SUCCESS! Returning stream key.");
    return newStreamKey;
  } catch (e) {
    print("Exception: $e");
    return null;
  }
}

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
      print("Warning: Thumbnail over 2MB, may fail.");
    }

    final res = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/upload/youtube/v3/thumbnails/set?videoId=$videoId&uploadType=media'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': mimeType,
        'Content-Length': imageBytes.length.toString(),
      },
      body: imageBytes,
    );

    print(res.statusCode == 200
        ? "Thumbnail OK"
        : "Thumbnail failed (non-fatal): ${res.body}");
  } catch (e) {
    print("Thumbnail error (non-fatal): $e");
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
