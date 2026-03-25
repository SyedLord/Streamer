import '/components/status_badge_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'creator_studio_hub2_widget.dart' show CreatorStudioHub2Widget;
import 'package:flutter/material.dart';

class CreatorStudioHub2Model extends FlutterFlowModel<CreatorStudioHub2Widget> {
  ///  Local state fields for this page.

  String? localThumbnailPath;

  ///  State fields for stateful widgets in this page.

  // Model for status_badge component.
  late StatusBadgeModel statusBadgeModel;
  // State field(s) for VideoTitle widget.
  FocusNode? videoTitleFocusNode;
  TextEditingController? videoTitleTextController;
  String? Function(BuildContext, String?)? videoTitleTextControllerValidator;
  // Stores action output result for [Custom Action - pickThumbnailImage] action in Container widget.
  String? selectedThumbPath;
  // Stores action output result for [Custom Action - pickSafeVideoPath] action in TapToUpload widget.
  String? pickedPath;
  // Stores action output result for [Custom Action - pickSafeVideoPath] action in ChangeVideoBtn widget.
  String? pickedNewVideo;
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
