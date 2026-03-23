import 'dart:convert';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetYouTubeStreamDataCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Get YouTube Stream Data',
      apiUrl: 'https://youtube.googleapis.com/youtube/v3/liveStreams',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
      },
      params: {
        'part': "cdn",
        'mine': true,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic rtmpUrl(dynamic response) => getJsonField(
        response,
        r'''$.items[0].cdn.ingestionInfo.ingestionAddress''',
      );
  static dynamic streamKey(dynamic response) => getJsonField(
        response,
        r'''$.items[0].cdn.ingestionInfo.streamName''',
      );
}

class GetYouTubeChannelInfoCall {
  static Future<ApiCallResponse> call({
    String? accessToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Get YouTube Channel Info',
      apiUrl:
          'https://youtube.googleapis.com/youtube/v3/channels?part=snippet&mine=true',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic channelTitle(dynamic response) => getJsonField(
        response,
        r'''$.items[0].snippet.title''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
