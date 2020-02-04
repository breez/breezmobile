import 'package:breez/theme_data.dart' as theme;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar showFlushbar(BuildContext context,
    {String title,
    String message = "",
    Widget messageWidget,
    String buttonText = "OK",
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    bool Function() onDismiss,
    Duration duration = const Duration(seconds: 8)}) {
  Flushbar flush;
  flush = Flushbar(
      flushbarPosition: position,
      titleText:
          title == null ? null : Text(title, style: TextStyle(height: 0.0)),
      duration: duration == Duration.zero ? null : duration,
      messageText: messageWidget ??
          Text(message, style: theme.snackBarStyle, textAlign: TextAlign.left),
      backgroundColor: theme.snackBarBackgroundColor,
      mainButton: FlatButton(
        onPressed: () {
          bool dismiss = onDismiss != null ? onDismiss() : true;
          if (dismiss) {
            flush.dismiss(true);
          }
        },
        child: Text(buttonText,
            style: theme.snackBarStyle
                .copyWith(color: Theme.of(context).errorColor)),
      ))
    ..show(context);

  return flush;
}

void popFlushbars(BuildContext context) {
  Navigator.popUntil(context, (route) {
    return route.settings.name != FLUSHBAR_ROUTE_NAME;
  });
}
