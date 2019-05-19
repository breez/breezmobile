import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProcessingPaymentDialog extends StatefulWidget {
  final BuildContext context;

  ProcessingPaymentDialog(this.context);

  @override
  ProcessingPaymentDialogState createState() {
    return new ProcessingPaymentDialogState();
  }
}

class ProcessingPaymentDialogState extends State<ProcessingPaymentDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _buildProcessingPaymentDialog());
  }

  List<Widget> _buildProcessingPaymentDialog() {
    List<Widget> _processingPaymentDialog = <Widget>[];
    Widget _title = _buildTitle();
    Widget _content = _buildContent();
    _processingPaymentDialog.add(_title);
    _processingPaymentDialog.add(_content);
    return _processingPaymentDialog;
  }

  Container _buildTitle() {
    return Container(
      height: 64.0,
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        "Processing Payment",
        style: theme.alertTitleStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Expanded _buildContent() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoadingAnimatedText(
                'Please wait while your payment is being processed',
                textStyle: theme.alertStyle,
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'src/images/breez_loader.gif',
                height: 64.0,
                colorBlendMode: BlendMode.multiply,
                color: Colors.transparent,
                gaplessPlayback: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
