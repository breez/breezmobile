import 'dart:async';

import 'package:breez/theme_data.dart';
import 'package:flutter/material.dart';

class LoadingAnimatedText extends StatefulWidget {
  final String _loadingMessage;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final List<TextSpan> textElements;

  const LoadingAnimatedText(this._loadingMessage,
      {this.textStyle, this.textAlign, this.textElements = const []});

  @override
  State<StatefulWidget> createState() {
    return LoadingAnimatedTextState();
  }
}

class LoadingAnimatedTextState extends State<LoadingAnimatedText> {
  Timer _loadingTimer;
  int _timerIteration = 0;

  @override
  void initState() {
    super.initState();
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
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
    var textElements = widget.textElements.toList();
    return RichText(
        text: TextSpan(
            style: widget.textStyle ?? Theme.of(context).statusTextStyle,
            text: widget._loadingMessage,
            children: textElements
              ..addAll(<TextSpan>[
                TextSpan(text: loadingDots),
                TextSpan(
                    text: paddingDots,
                    style: const TextStyle(color: Colors.transparent))
              ])),
        textAlign:
            widget.textAlign ?? TextAlign.center);
  }

  String get loadingDots => List.filled(_timerIteration % 4, ".").join("");
  String get paddingDots =>
      List.filled(3 - _timerIteration % 4, ".").join("");
}
