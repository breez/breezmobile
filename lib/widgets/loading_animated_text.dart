import 'dart:async';

import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';

import '../theme_data.dart';

class LoadingAnimatedText extends StatefulWidget {
  final String _loadingMessage;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final List<TextSpan> textElements;

  LoadingAnimatedText(this._loadingMessage,
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
    ThemeData theme = context.theme;
    TextTheme textTheme = theme.textTheme;
    Color secondaryColor =
        (themeId == "BLUE") ? BreezColors.grey[600] : Colors.white;

    var textElements = widget.textElements.toList();
    return RichText(
        text: TextSpan(
            style: widget.textStyle ??
                textTheme.bodyText2.copyWith(color: secondaryColor),
            text: widget._loadingMessage,
            children: textElements
              ..addAll(<TextSpan>[
                TextSpan(text: loadingDots),
                TextSpan(
                    text: paddingDots,
                    style: TextStyle(color: Colors.transparent))
              ])),
        textAlign:
        widget.textAlign == null ? TextAlign.center : widget.textAlign);
  }

  String get loadingDots => '${List.filled(_timerIteration % 4, ".").join("")}';

  String get paddingDots =>
      '${List.filled(3 - _timerIteration % 4, ".").join("")}';
}
