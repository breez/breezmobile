import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';

class StatusText extends StatefulWidget {
  final String _statusMessage;
  final bool loading;

  StatusText(this._statusMessage, {this.loading = true});

  @override
  State<StatefulWidget> createState() {
    return new _StatusTextState();
  }
}

class _StatusTextState extends State<StatusText> { 

  @override
  Widget build(BuildContext context) {
    return widget._statusMessage == null
        ? AutoSizeText(
            "Start using Breez by adding funds to your balance or by receiving payments from other users.",
            textAlign: TextAlign.center,
            minFontSize: MinFontSize(context).minFontSize,
            stepGranularity: 0.1,
          )
        : (widget.loading ? LoadingAnimatedText(widget._statusMessage) : Text(widget._statusMessage, textAlign: TextAlign.center));
  }
}
