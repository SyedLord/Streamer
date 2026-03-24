// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'dart:convert';
import 'dart:io'; // Thumbnail file read karne ke liye [cite: 189]
import 'dart:typed_data'; // Image bytes ke liye [cite: 7]
import 'package:http/http.dart' as http;

Future<String?> setupYouTubeLiveEvent(
  String? token,
  String? title,
  String? privacy,
  String? categoryId,
  String? thumbnailPath, // Naya parameter [cite: 14]
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
    // ─── STEP 1: Create Broadcast ───────
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
        },
        "status": {"privacyStatus": privacy},
        "contentDetails": {"enableAutoStart": true, "enableAutoStop": true}
      }),
    );

    if (broadcastRes.statusCode != 200) return null;
    final broadcastData = jsonDecode(broadcastRes.body);
    final broadcastId = broadcastData['id'];

    // ─── STEP 2: Set categoryId via videos.update ──────────────────────────
    print("2. Setting Category ID ($categoryId) via videos.update...");
    await http.put(
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

    // ─── STEP 3: Upload Thumbnail (Agar select ki gayi hai) ────────────────
    if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
      print("3. Uploading Thumbnail from path: $thumbnailPath...");
      await _uploadThumbnail(
          token: token, videoId: broadcastId, thumbnailPath: thumbnailPath);
    }

    // ─── STEP 4: Generate New Stream Key ──────────────────────────────────
    print("4. Generating New Stream Key...");
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
    final newStreamKey = streamData['cdn']['ingestionInfo']['streamName'];

    // ─── STEP 5: Bind Stream to Broadcast ─────────────────────────────────
    print("5. Binding Stream to Broadcast...");
    final bindRes = await http.post(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveBroadcasts/bind?id=$broadcastId&part=id&streamId=$streamId'),
      headers: headers,
    );

    if (bindRes.statusCode != 200) return null;
    return newStreamKey;
  } catch (e) {
    print("Unexpected error: $e");
    return null;
  }
}

// ─── THUMBNAIL UPLOAD HELPER FUNCTION ─────────────────────────────────────
// Yeh function main API call se bahar (neechay) hi rahega [cite: 128]
Future<void> _uploadThumbnail({
  required String token,
  required String videoId,
  required String thumbnailPath,
}) async {
  try {
    final imageFile = File(thumbnailPath);
    if (!await imageFile.exists()) return;

    final Uint8List imageBytes = await imageFile.readAsBytes();

    final String extension = thumbnailPath.split('.').last.toLowerCase();
    final String mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

    final uploadUri = Uri.parse(
        'https://youtube.googleapis.com/upload/youtube/v3/thumbnails/set?videoId=$videoId&uploadType=media');

    final thumbnailRes = await http.post(
      uploadUri,
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
      print("Thumbnail upload failed. Status: ${thumbnailRes.statusCode}");
    }
  } catch (e) {
    print("Thumbnail error: $e");
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
