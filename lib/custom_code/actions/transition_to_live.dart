// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> transitionToLive(
  String? token,
  String? broadcastId,
  String? streamId,
) async {
  if (token == null ||
      token.isEmpty ||
      broadcastId == null ||
      broadcastId.isEmpty ||
      streamId == null ||
      streamId.isEmpty) {
    print("Transition: Missing params");
    return false;
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  const maxAttempts = 24;
  const waitDuration = Duration(seconds: 5);

  for (int attempt = 1; attempt <= maxAttempts; attempt++) {
    print("Health check $attempt/$maxAttempts...");
    await Future.delayed(waitDuration);

    try {
      final healthRes = await http.get(
        Uri.parse(
            'https://youtube.googleapis.com/youtube/v3/liveStreams?part=status&id=$streamId'),
        headers: headers,
      );

      if (healthRes.statusCode != 200) continue;

      final items = jsonDecode(healthRes.body)['items'] as List?;
      if (items == null || items.isEmpty) continue;

      final streamStatus = items[0]['status']['streamStatus'];
      print("Stream status: $streamStatus");

      if (streamStatus == 'active') {
        print("Stream active! Transitioning to LIVE...");
        final transRes = await http.post(
          Uri.parse(
              'https://youtube.googleapis.com/youtube/v3/liveBroadcasts/transition?broadcastStatus=live&id=$broadcastId&part=status'),
          headers: headers,
        );

        if (transRes.statusCode == 200) {
          print("LIVE!");
          return true;
        } else {
          print("Transition failed: ${transRes.body}");
          return false;
        }
      }
    } catch (e) {
      print("Health check error: $e");
    }
  }

  print("Timeout");
  return false;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
