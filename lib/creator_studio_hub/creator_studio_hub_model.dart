import '/components/status_badge_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'creator_studio_hub_widget.dart' show CreatorStudioHubWidget;
import 'package:flutter/material.dart';

class CreatorStudioHubModel extends FlutterFlowModel<CreatorStudioHubWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? finalVideoToStream;

  ///  State fields for stateful widgets in this page.

  // Model for status_badge component.
  late StatusBadgeModel statusBadgeModel;
  // Stores action output result for [Custom Action - pickVideoFilePath] action in ChangeVideoBtn widget.
  String? changedVideo;
  // Stores action output result for [Custom Action - pickVideoFilePath] action in TapToUpload widget.
  String? videoPathResult;

  @override
  void initState(BuildContext context) {
    statusBadgeModel = createModel(context, () => StatusBadgeModel());
  }

  @override
  void dispose() {
    statusBadgeModel.dispose();
  }
}
