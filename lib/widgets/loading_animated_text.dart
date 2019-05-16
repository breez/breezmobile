
import 'dart:async';
import 'package:flutter/material.dart';

class LoadingAnimatedText extends StatefulWidget {
  final String _loadingMessage;
  final TextStyle textStyle;
  final TextAlign textAlign;

  LoadingAnimatedText(this._loadingMessage, {this.textStyle, this.textAlign});

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
    return RichText(
      text: TextSpan(
        style: widget.textStyle ?? DefaultTextStyle.of(context).style,
        text: widget._loadingMessage,
        children:<TextSpan>[
          TextSpan(text: loadingDots),
          TextSpan(text: paddingDots, style: TextStyle(color: Colors.transparent))
        ]), 
      textAlign: widget.textAlign == null ? TextAlign.center : widget.textAlign);
  }

  String get loadingDots => '${List.filled(_timerIteration % 4, ".").join("")}';
  String get paddingDots => '${List.filled(3 - _timerIteration % 4, ".").join("")}';
}