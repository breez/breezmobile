import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class StatusText extends StatefulWidget {
  final String _statusMessage;

  StatusText(this._statusMessage);

  @override
  State<StatefulWidget> createState() {
    return new _StatusTextState();
  }
}

class _StatusTextState extends State<StatusText> {
  Timer _loadingTimer;
  int _timerIteration = 0;    

  @override
  void initState() {
    super.initState();    

    _loadingTimer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      setState(() {
        _timerIteration++;
      });
    });
  }

  @override
  void dispose() {
    _loadingTimer.cancel();    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget._statusMessage == null
        ? LoadingAnimatedText("Start using Breez\nby adding funds to your balance.")
        : LoadingAnimatedText(widget._statusMessage);        
  }

  String get _animatedDots =>
      '${List.filled(_timerIteration % 4, ".").join("")}';
}
