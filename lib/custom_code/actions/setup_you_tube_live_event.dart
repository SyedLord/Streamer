// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cross_file/cross_file.dart'; // Web/Mobile Safe Library

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
    print("1. Creating Broadcast (Title: $title)...");
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
          "enableAutoStop": true
          // DVR aur RecordFromStart hata diye gaye hain taake channel error na de
        }
      }),
    );

    if (broadcastRes.statusCode != 200) {
      print("Broadcast API Error: ${broadcastRes.body}");
      return null;
    }

    final broadcastData = jsonDecode(broadcastRes.body);
    final broadcastId = broadcastData['id'];

    // ─── STEP 2: Set Category ID ──────────────────────────
    print("2. Setting Category ID ($categoryId)...");
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
      print("3. Uploading Thumbnail...");
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

    if (streamRes.statusCode != 200) {
      print("Stream Key Error: ${streamRes.body}");
      return null;
    }

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

    if (bindRes.statusCode != 200) {
      print("Bind Error: ${bindRes.body}");
      return null;
    }

    // Fauran chaabi (key) return karein taake FFmpeg shuru ho aur delay na aaye
    print("SUCCESS! Stream key ready: $newStreamKey");
    return newStreamKey;
  } catch (e) {
    print("Unexpected error: $e");
    return null;
  }
}

// ─── THUMBNAIL UPLOAD HELPER FUNCTION ──────────────────────────
Future<void> _uploadThumbnail({
  required String token,
  required String videoId,
  required String thumbnailPath,
}) async {
  try {
    final imageFile = XFile(thumbnailPath);
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
      print("Thumbnail failed: ${thumbnailRes.body}");
    }
  } catch (e) {
    print("Thumbnail error: $e");
  }
}
