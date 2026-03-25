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

Future<dynamic> fetchLiveStreamStats(
  String token,
  String videoId,
  String streamId,
) async {
  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  String viewers = "0";
  String health = "Checking...";
  String duration = "00:00:00";

  try {
    // ─── 1. FETCH VIEWERS & UPTIME (TIME) ───
    final videoRes = await http.get(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/videos?part=liveStreamingDetails&id=$videoId'),
      headers: headers,
    );

    if (videoRes.statusCode == 200) {
      final videoData = jsonDecode(videoRes.body);
      if (videoData['items'] != null && videoData['items'].isNotEmpty) {
        final details = videoData['items'][0]['liveStreamingDetails'];

        // Views fetch kar rahe hain
        viewers = details['concurrentViewers'] ?? "0";

        // Time calculate kar rahe hain (Start time se abhi tak ka farq)
        if (details['actualStartTime'] != null) {
          DateTime startTime = DateTime.parse(details['actualStartTime']);
          Duration diff = DateTime.now().toUtc().difference(startTime);

          String hours = diff.inHours.toString().padLeft(2, '0');
          String minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
          String seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
          duration = "$hours:$minutes:$seconds";
        } else {
          duration = "Starting...";
        }
      }
    }

    // ─── 2. FETCH STREAM HEALTH ───
    final streamRes = await http.get(
      Uri.parse(
          'https://youtube.googleapis.com/youtube/v3/liveStreams?part=status&id=$streamId'),
      headers: headers,
    );

    if (streamRes.statusCode == 200) {
      final streamData = jsonDecode(streamRes.body);
      if (streamData['items'] != null && streamData['items'].isNotEmpty) {
        final statusStr =
            streamData['items'][0]['status']['healthStatus']['status'];

        // YouTube ke status ko Studio wale words mein badalna:
        if (statusStr == 'good')
          health = "Excellent";
        else if (statusStr == 'ok')
          health = "Good";
        else if (statusStr == 'bad')
          health = "Poor";
        else if (statusStr == 'noData')
          health = "No Data";
        else
          health = "Checking...";
      }
    }

    // Teeno cheezein JSON mein wapas bhej dein
    return {"viewers": viewers, "health": health, "duration": duration};
  } catch (e) {
    print("Stats fetch error: $e");
    return null;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
