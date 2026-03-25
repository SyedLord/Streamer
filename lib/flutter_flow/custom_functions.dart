import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';

String incrementLiveTime(String currentTime) {
  // Agar stream abhi start nahi hui, toh time change na karo
  if (currentTime == "Starting..." || currentTime == "Checking...") {
    return currentTime;
  }

  try {
    // Time ko hisson mein toro (00:05:30 -> 00, 05, 30)
    List<String> parts = currentTime.split(':');
    if (parts.length != 3) return currentTime;

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // 1 second aage barhao
    seconds++;

    // 60 seconds poore hone par minute barhao
    if (seconds >= 60) {
      seconds = 0;
      minutes++;
    }
    // 60 minutes poore hone par hour barhao
    if (minutes >= 60) {
      minutes = 0;
      hours++;
    }

    // Wapas 00:00:00 format mein joro
    String h = hours.toString().padLeft(2, '0');
    String m = minutes.toString().padLeft(2, '0');
    String s = seconds.toString().padLeft(2, '0');

    return "$h:$m:$s";
  } catch (e) {
    return currentTime;
  }
}
