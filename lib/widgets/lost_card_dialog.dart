import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:breez/theme_data.dart' as theme;

Flushbar _lostCardFlush;

class LostCardDialog extends StatelessWidget {
  final BuildContext context;

  LostCardDialog({this.context});

  @override
  Widget build(BuildContext context) {
    return showLostCardDialog();
  }

  Widget showLostCardDialog() {
    _lostCardFlush =
        Flushbar() // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
          ..titleText = new Text("", style: TextStyle(height: 0.0))
          ..messageText = new Text("Your card has been deactivated.\nYou may order a new card now.",
              style: theme.snackBarStyle, textAlign: TextAlign.left)
          ..duration = Duration(seconds: 8)
          ..backgroundColor = theme.snackBarBackgroundColor
          ..mainButton = FlatButton(
            onPressed: () {
              _lostCardFlush.dismiss(true);
              Navigator.pushReplacementNamed(context, "/order_card");
            },
            child: Text("ORDER", style: theme.validatorStyle),
          );
    return new AlertDialog(
      title: new Text(
        "Lost or Stolen Card",
        style: theme.alertTitleStyle,
      ),
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 8.0),
      content: new Text(
          "If your card has been lost or stolen, you should deactivate it now to prevent it from being used by others. Deactivate means you won't be able to use any of your existing cards until you re-activate them.",
          style: theme.alertStyle),
      contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 8.0),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("CANCEL", style: theme.buttonStyle),
        ),
        new FlatButton(
          onPressed: (() {
            Navigator.pop(context);
            _lostCardFlush.show(context);
          }),
          child: new Text("DEACTIVATE", style: theme.buttonStyle),
        ),
      ],
    );
  }
}
