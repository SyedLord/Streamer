// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Naye imports
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Global Background Timers
Timer? _clockTimer;
Timer? _apiTimer;

Future<void> manageLiveDashboard(
  String command,
  String? token,
  String? videoId,
  String? streamId,
) async {
  // 🔴 AGAR COMMAND STOP HAI (To timers band kar do)
  if (command == "STOP") {
    _clockTimer?.cancel();
    _apiTimer?.cancel();
    print("Dashboard Timers Stopped.");
    return;
  }

  // 🟢 AGAR COMMAND START HAI (To dashboard chalu kar do)
  if (command == "START") {
    if (token == null || videoId == null || streamId == null) {
      print("Error: Missing keys for dashboard.");
      return;
    }

    // Pehle wale timers kill karein taake double na chalein
    _clockTimer?.cancel();
    _apiTimer?.cancel();

    // 🛠️ UPDATE: Default ko 00:00:00 se badal kar "Starting..." kar diya
    FFAppState().update(() {
      FFAppState().liveTime = "Starting...";
      FFAppState().liveHealth = "Checking...";
      FFAppState().liveViewers = "0";
    });

    // --- API FETCH FUNCTION ---
    Future<void> fetchStats() async {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      try {
        // Viewers aur Time
        final videoRes = await http.get(
          Uri.parse(
              'https://youtube.googleapis.com/youtube/v3/videos?part=liveStreamingDetails&id=$videoId'),
          headers: headers,
        );
        if (videoRes.statusCode == 200) {
          final videoData = jsonDecode(videoRes.body);
          if (videoData['items'] != null && videoData['items'].isNotEmpty) {
            final details = videoData['items'][0]['liveStreamingDetails'];
            String viewers = details['concurrentViewers'] ?? "0";

            // 🛠️ UPDATE: Agar YouTube ne time nahi diya toh "Starting..." hi rakho
            String duration = "Starting...";

            if (details['actualStartTime'] != null) {
              DateTime startTime = DateTime.parse(details['actualStartTime']);
              Duration diff = DateTime.now().toUtc().difference(startTime);
              String hours = diff.inHours.toString().padLeft(2, '0');
              String minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
              String seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
              duration = "$hours:$minutes:$seconds";
            }

            FFAppState().update(() {
              FFAppState().liveViewers = viewers;
              FFAppState().liveTime = duration;
            });
          }
        }

        // Health
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
            String health = "Checking...";
            if (statusStr == 'good')
              health = "Excellent";
            else if (statusStr == 'ok')
              health = "Good";
            else if (statusStr == 'bad')
              health = "Poor";
            else if (statusStr == 'noData') health = "No Data";

            FFAppState().update(() {
              FFAppState().liveHealth = health;
            });
          }
        }
      } catch (e) {
        print("API Error: $e");
      }
    }

    // Fauran pehli dafa fetch karein
    await fetchStats();

    // --- 1-SECOND CLOCK TIMER ---
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      String current = FFAppState().liveTime;
      // 🛠️ LOGIC: Agar text "Starting..." hai, toh ghari tick nahi karegi!
      if (current != "Starting..." && current != "Checking...") {
        try {
          List<String> parts = current.split(':');
          if (parts.length == 3) {
            int h = int.parse(parts[0]);
            int m = int.parse(parts[1]);
            int s = int.parse(parts[2]);

            s++;
            if (s >= 60) {
              s = 0;
              m++;
            }
            if (m >= 60) {
              m = 0;
              h++;
            }

            FFAppState().update(() {
              FFAppState().liveTime =
                  "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
            });
          }
        } catch (e) {}
      }
    });

    // --- 10-SECOND API TIMER ---
    _apiTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchStats();
    });
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
