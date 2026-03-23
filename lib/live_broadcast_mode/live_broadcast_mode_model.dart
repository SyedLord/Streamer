import '/components/health_indicator_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'live_broadcast_mode_widget.dart' show LiveBroadcastModeWidget;
import 'package:flutter/material.dart';

class LiveBroadcastModeModel extends FlutterFlowModel<LiveBroadcastModeWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for health_indicator component.
  late HealthIndicatorModel healthIndicatorModel;

  @override
  void initState(BuildContext context) {
    healthIndicatorModel = createModel(context, () => HealthIndicatorModel());
  }

  @override
  void dispose() {
    healthIndicatorModel.dispose();
  }
}
