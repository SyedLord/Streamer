import '/components/status_badge_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'creator_studio_hub_widget.dart' show CreatorStudioHubWidget;
import 'package:flutter/material.dart';

class CreatorStudioHubModel extends FlutterFlowModel<CreatorStudioHubWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? finalVideoToStream;

  ///  State fields for stateful widgets in this page.

  // Model for status_badge component.
  late StatusBadgeModel statusBadgeModel;
  // Stores action output result for [Custom Action - pickSafeVideoPath] action in ChangeVideoBtn widget.
  String? pickedNewVideo;
  // Stores action output result for [Custom Action - pickSafeVideoPath] action in TapToUpload widget.
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
