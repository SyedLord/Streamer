import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _rtmpUrl = prefs.getString('ff_rtmpUrl') ?? _rtmpUrl;
    });
    _safeInit(() {
      _streamKey = prefs.getString('ff_streamKey') ?? _streamKey;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _rtmpUrl = '';
  String get rtmpUrl => _rtmpUrl;
  set rtmpUrl(String value) {
    _rtmpUrl = value;
    prefs.setString('ff_rtmpUrl', value);
  }

  String _streamKey = '';
  String get streamKey => _streamKey;
  set streamKey(String value) {
    _streamKey = value;
    prefs.setString('ff_streamKey', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
