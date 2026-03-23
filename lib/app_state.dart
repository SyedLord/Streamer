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
    _safeInit(() {
      _globalRtmp = prefs.getString('ff_globalRtmp') ?? _globalRtmp;
    });
    _safeInit(() {
      _globalStreamKey =
          prefs.getString('ff_globalStreamKey') ?? _globalStreamKey;
    });
    _safeInit(() {
      _isLoggedIn = prefs.getBool('ff_isLoggedIn') ?? _isLoggedIn;
    });
    _safeInit(() {
      _channelName = prefs.getString('ff_channelName') ?? _channelName;
    });
    _safeInit(() {
      _selectedVideoPath =
          prefs.getString('ff_selectedVideoPath') ?? _selectedVideoPath;
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

  String _globalRtmp = '';
  String get globalRtmp => _globalRtmp;
  set globalRtmp(String value) {
    _globalRtmp = value;
    prefs.setString('ff_globalRtmp', value);
  }

  String _globalStreamKey = '';
  String get globalStreamKey => _globalStreamKey;
  set globalStreamKey(String value) {
    _globalStreamKey = value;
    prefs.setString('ff_globalStreamKey', value);
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    prefs.setBool('ff_isLoggedIn', value);
  }

  String _channelName = '';
  String get channelName => _channelName;
  set channelName(String value) {
    _channelName = value;
    prefs.setString('ff_channelName', value);
  }

  String _selectedVideoPath = '';
  String get selectedVideoPath => _selectedVideoPath;
  set selectedVideoPath(String value) {
    _selectedVideoPath = value;
    prefs.setString('ff_selectedVideoPath', value);
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
