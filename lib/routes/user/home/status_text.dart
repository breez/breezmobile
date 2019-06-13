import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
        ? Text("Start using Breez by adding funds to your balance or by receiving payments from other users.", textAlign: TextAlign.center)
        : (widget.loading ? LoadingAnimatedText(widget._statusMessage) : Text(widget._statusMessage, textAlign: TextAlign.center));        
  }
}
