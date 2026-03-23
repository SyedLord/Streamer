import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'health_indicator_model.dart';
export 'health_indicator_model.dart';

class HealthIndicatorWidget extends StatefulWidget {
  const HealthIndicatorWidget({super.key});

  @override
  State<HealthIndicatorWidget> createState() => _HealthIndicatorWidgetState();
}

class _HealthIndicatorWidgetState extends State<HealthIndicatorWidget> {
  late HealthIndicatorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HealthIndicatorModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).success,
            borderRadius: BorderRadius.circular(9999.0),
          ),
        ),
        Text(
          'Connection Healthy',
          style: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).success,
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                lineHeight: 1.3,
              ),
        ),
      ].divide(SizedBox(width: 8.0)),
    );
  }
}
