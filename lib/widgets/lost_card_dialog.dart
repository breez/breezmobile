import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Flushbar _lostCardFlush;

class LostCardDialog extends StatelessWidget {
  final BuildContext context;

  LostCardDialog({this.context});

  @override
  Widget build(BuildContext context) {
    return showLostCardDialog();
  }

  Widget showLostCardDialog() {
    _lostCardFlush = Flushbar(
        titleText: Text("", style: TextStyle(height: 0.0)),
        messageText: Text(
            "Your card has been deactivated.\nYou may order a new card now.",
            style: theme.snackBarStyle,
            textAlign: TextAlign.left),
        duration: Duration(seconds: 8),
        backgroundColor: theme.snackBarBackgroundColor,
        mainButton: TextButton(
          onPressed: () {
            _lostCardFlush.dismiss(true);
            Navigator.pushReplacementNamed(context, "/order_card");
          },
          child: Text("ORDER", style: theme.validatorStyle),
        ));

    return AlertDialog(
      title: Text(
        "Lost or Stolen Card",
        style: Theme.of(context).dialogTheme.titleTextStyle,
        maxLines: 2,
      ),
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 8.0),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: AutoSizeText(
            "If your card has been lost or stolen, you should deactivate it now to prevent it from being used by others. Deactivate means you won't be able to use any of your existing cards until you re-activate them.",
            style: Theme.of(context).dialogTheme.contentTextStyle),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 8.0),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:
              Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
        ),
        TextButton(
          onPressed: (() {
            Navigator.pop(context);
            _lostCardFlush.show(context);
          }),
          child: Text("DEACTIVATE",
              style: Theme.of(context).primaryTextTheme.button),
        ),
      ],
    );
  }
}
