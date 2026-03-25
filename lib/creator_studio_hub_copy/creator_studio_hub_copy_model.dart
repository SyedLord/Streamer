import '/components/status_badge_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'creator_studio_hub_copy_widget.dart' show CreatorStudioHubCopyWidget;
import 'package:flutter/material.dart';

class CreatorStudioHubCopyModel
    extends FlutterFlowModel<CreatorStudioHubCopyWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? finalVideoToStream;

  ///  State fields for stateful widgets in this page.

  // Model for status_badge component.
  late StatusBadgeModel statusBadgeModel;
  // Stores action output result for [Custom Action - pickSafeVideoPath2] action in ChangeVideoBtn widget.
  String? pickedNewVideo;
  // Stores action output result for [Custom Action - pickSafeVideoPath2] action in TapToUpload widget.
  String? pickedPath;
  // State field(s) for VideoTitle widget.
  FocusNode? videoTitleFocusNode;
  TextEditingController? videoTitleTextController;
  String? Function(BuildContext, String?)? videoTitleTextControllerValidator;
  // State field(s) for Privacy widget.
  String? privacyValue;
  FormFieldController<String>? privacyValueController;
  // State field(s) for Category widget.
  String? categoryValue;
  FormFieldController<String>? categoryValueController;
  // Stores action output result for [Custom Action - setupYouTubeLiveEvent] action in Button widget.
  dynamic generatedKey;

  @override
  void initState(BuildContext context) {
    statusBadgeModel = createModel(context, () => StatusBadgeModel());
  }

  @override
  void dispose() {
    statusBadgeModel.dispose();
    videoTitleFocusNode?.dispose();
    videoTitleTextController?.dispose();
  }
}
