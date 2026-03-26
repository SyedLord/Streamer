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
      _isStreamLive = prefs.getBool('ff_isStreamLive') ?? _isStreamLive;
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
  }

  String _youtubeAccessToken = '';
  String get youtubeAccessToken => _youtubeAccessToken;
  set youtubeAccessToken(String value) {
    _youtubeAccessToken = value;
  }

  String _liveTime = '00:00:00';
  String get liveTime => _liveTime;
  set liveTime(String value) {
    _liveTime = value;
  }

  String _liveHealth = 'Checking...';
  String get liveHealth => _liveHealth;
  set liveHealth(String value) {
    _liveHealth = value;
  }

  String _liveViewers = '0';
  String get liveViewers => _liveViewers;
  set liveViewers(String value) {
    _liveViewers = value;
  }

  double _liveBitrate = 0.0;
  double get liveBitrate => _liveBitrate;
  set liveBitrate(double value) {
    _liveBitrate = value;
  }

  List<double> _bitrateHistory = [0.0];
  List<double> get bitrateHistory => _bitrateHistory;
  set bitrateHistory(List<double> value) {
    _bitrateHistory = value;
  }

  void addToBitrateHistory(double value) {
    bitrateHistory.add(value);
  }

  void removeFromBitrateHistory(double value) {
    bitrateHistory.remove(value);
  }

  void removeAtIndexFromBitrateHistory(int index) {
    bitrateHistory.removeAt(index);
  }

  void updateBitrateHistoryAtIndex(
    int index,
    double Function(double) updateFn,
  ) {
    bitrateHistory[index] = updateFn(_bitrateHistory[index]);
  }

  void insertAtIndexInBitrateHistory(int index, double value) {
    bitrateHistory.insert(index, value);
  }

  int _streamSecondsCounter = 0;
  int get streamSecondsCounter => _streamSecondsCounter;
  set streamSecondsCounter(int value) {
    _streamSecondsCounter = value;
  }

  List<String> _bitrateLabels = ['0s'];
  List<String> get bitrateLabels => _bitrateLabels;
  set bitrateLabels(List<String> value) {
    _bitrateLabels = value;
  }

  void addToBitrateLabels(String value) {
    bitrateLabels.add(value);
  }

  void removeFromBitrateLabels(String value) {
    bitrateLabels.remove(value);
  }

  void removeAtIndexFromBitrateLabels(int index) {
    bitrateLabels.removeAt(index);
  }

  void updateBitrateLabelsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    bitrateLabels[index] = updateFn(_bitrateLabels[index]);
  }

  void insertAtIndexInBitrateLabels(int index, String value) {
    bitrateLabels.insert(index, value);
  }

  List<int> _bitrateXData = [0];
  List<int> get bitrateXData => _bitrateXData;
  set bitrateXData(List<int> value) {
    _bitrateXData = value;
  }

  void addToBitrateXData(int value) {
    bitrateXData.add(value);
  }

  void removeFromBitrateXData(int value) {
    bitrateXData.remove(value);
  }

  void removeAtIndexFromBitrateXData(int index) {
    bitrateXData.removeAt(index);
  }

  void updateBitrateXDataAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    bitrateXData[index] = updateFn(_bitrateXData[index]);
  }

  void insertAtIndexInBitrateXData(int index, int value) {
    bitrateXData.insert(index, value);
  }

  String _currentVideoId = '';
  String get currentVideoId => _currentVideoId;
  set currentVideoId(String value) {
    _currentVideoId = value;
  }

  String _currentStreamId = '';
  String get currentStreamId => _currentStreamId;
  set currentStreamId(String value) {
    _currentStreamId = value;
  }

  bool _isStreamLive = false;
  bool get isStreamLive => _isStreamLive;
  set isStreamLive(bool value) {
    _isStreamLive = value;
    prefs.setBool('ff_isStreamLive', value);
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
