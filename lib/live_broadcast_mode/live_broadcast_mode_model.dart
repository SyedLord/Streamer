import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'live_broadcast_mode_widget.dart' show LiveBroadcastModeWidget;
import 'package:flutter/material.dart';

class LiveBroadcastModeModel extends FlutterFlowModel<LiveBroadcastModeWidget> {
  ///  Local state fields for this page.

  String liveTime = '00:00:00';

  String liveHealth = 'Connecting...';

  String liveViewers = '0';

  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - fetchLiveStreamStats] action in LiveBroadcastMode widget.
  dynamic youtubeFetchData;
  InstantTimer? instantTimer2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
    instantTimer2?.cancel();
  }
}
