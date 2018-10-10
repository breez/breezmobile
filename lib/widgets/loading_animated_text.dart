
import 'dart:async';
import 'package:flutter/material.dart';

class LoadingAnimatedText extends StatefulWidget {
  final String _loadingMessage;
  final TextStyle textStyle;

  LoadingAnimatedText(this._loadingMessage, {this.textStyle = const TextStyle()});

  @override
  State<StatefulWidget> createState() {
    return new LoadingAnimatedTextState();
  }
}

class LoadingAnimatedTextState extends State<LoadingAnimatedText> {
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
    return new Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Positioned(child: Text(widget._loadingMessage + "...", style: widget.textStyle.copyWith(color: Colors.transparent))),
        Positioned(child: Text(widget._loadingMessage + loadingDots, style: widget.textStyle,), left: 0.0),        
      ]);      
  }

  String get loadingDots => '${List.filled(_timerIteration % 4, ".").join("")}';
}