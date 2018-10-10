import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

showFlushbar(BuildContext context, {String title = "", String message = ""}) {
  var flush;
  flush = Flushbar() // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
    ..titleText = new Text(title, style: TextStyle(height: 0.0))
    ..messageText = new Text(message, style: theme.snackBarStyle, textAlign: TextAlign.left)
    ..duration = Duration(seconds: 8)
    ..backgroundColor = theme.snackBarBackgroundColor
    ..mainButton = FlatButton(
      onPressed: () {
        flush.dismiss(true); // result = true
      },
      child: Text("OK", style: theme.validatorStyle),
    )
    ..show(context);
}
