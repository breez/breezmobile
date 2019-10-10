import 'package:breez/theme_data.dart' as theme;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar showFlushbar(BuildContext context, {String title = "", String message = "", Duration duration = const Duration(seconds: 8)}) {
  Flushbar flush;
  flush = Flushbar(
    titleText: Text(title, style: TextStyle(height: 0.0)),
    duration: duration,
    messageText: new Text(message, style: theme.snackBarStyle, textAlign: TextAlign.left),
    backgroundColor: theme.snackBarBackgroundColor,
    mainButton: FlatButton(
      onPressed: () {
        flush.dismiss(true); // result = true
      },
      child: Text("OK", style: theme.validatorStyle),
    )
  )..show(context);

  return flush;
}

void popFlushbars(BuildContext context){
  Navigator.popUntil(context, (route) {          
    return route.settings.name != FLUSHBAR_ROUTE_NAME;
  });
}
