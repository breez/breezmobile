import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';

class LostCardDialog extends StatelessWidget {
  const LostCardDialog();

  @override
  Widget build(BuildContext context) {
    Flushbar _lostCardFlush;
    _lostCardFlush = Flushbar(
      titleText: Text(
        context.l10n.lost_card_dialog_flush_title,
        style: TextStyle(
          height: 0.0,
        ),
      ),
      messageText: Text(
        context.l10n.lost_card_dialog_flush_message,
        style: theme.snackBarStyle,
        textAlign: TextAlign.left,
      ),
      duration: Duration(seconds: 8),
      backgroundColor: theme.snackBarBackgroundColor,
      mainButton: TextButton(
        onPressed: () {
          _lostCardFlush.dismiss(true);
          Navigator.pushReplacementNamed(context, "/order_card");
        },
        child: Text(
          context.l10n.lost_card_dialog_flush_action_order,
          style: theme.validatorStyle,
        ),
      ),
    );

    return AlertDialog(
      title: Text(
        context.l10n.lost_card_dialog_title,
        style: Theme.of(context).dialogTheme.titleTextStyle,
        maxLines: 2,
      ),
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 8.0),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: AutoSizeText(
          context.l10n.lost_card_dialog_message,
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 8.0),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            context.l10n.lost_card_dialog_action_cancel,
            style: Theme.of(context).primaryTextTheme.button,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _lostCardFlush.show(context);
          },
          child: Text(
            context.l10n.lost_card_dialog_action_deactivate,
            style: Theme.of(context).primaryTextTheme.button,
          ),
        ),
      ],
    );
  }
}
