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
  bool isDataUploading_changedVideo = false;
  FFUploadedFile uploadedLocalFile_changedVideo =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_uploadData9d5 = false;
  FFUploadedFile uploadedLocalFile_uploadData9d5 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  @override
  void initState(BuildContext context) {
    statusBadgeModel = createModel(context, () => StatusBadgeModel());
  }

  @override
  void dispose() {
    statusBadgeModel.dispose();
  }
}
