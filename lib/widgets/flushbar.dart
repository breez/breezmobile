import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

Flushbar showFlushbar(BuildContext context, {String title = "", String message = "", Duration duration = const Duration(seconds: 8)}) {
  Flushbar flush;
  flush = Flushbar() // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
    ..titleText = new Text(title, style: TextStyle(height: 0.0))
    ..messageText = new Text(message, style: theme.snackBarStyle, textAlign: TextAlign.left)    
    ..backgroundColor = theme.snackBarBackgroundColor
    ..mainButton = FlatButton(
      onPressed: () {
        flush.dismiss(true); // result = true
      },
      child: Text("OK", style: theme.validatorStyle),
    )
    ..show(context);
  
  if (duration != null) {    
    Timer(duration, (){  
      if (!flush.isDismissed()) {          
        flush.dismiss();
      }
    });
  }
  return flush;
}

void popFlushbars(BuildContext context){
  Navigator.popUntil(context, (route) {          
    return route.settings.name != FLUSHBAR_ROUTE_NAME;
  });
}
