import '/components/setup_step_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'stream_configuration_widget.dart' show StreamConfigurationWidget;
import 'package:flutter/material.dart';

class StreamConfigurationModel
    extends FlutterFlowModel<StreamConfigurationWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for setup_step component.
  late SetupStepModel setupStepModel1;
  // Model for setup_step component.
  late SetupStepModel setupStepModel2;
  // State field(s) for RTMPServer widget.
  FocusNode? rTMPServerFocusNode;
  TextEditingController? rTMPServerTextController;
  String? Function(BuildContext, String?)? rTMPServerTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {
    setupStepModel1 = createModel(context, () => SetupStepModel());
    setupStepModel2 = createModel(context, () => SetupStepModel());
  }

  @override
  void dispose() {
    setupStepModel1.dispose();
    setupStepModel2.dispose();
    rTMPServerFocusNode?.dispose();
    rTMPServerTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController2?.dispose();
  }
}
