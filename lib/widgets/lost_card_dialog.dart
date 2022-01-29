import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class LostCardDialog extends StatelessWidget {
  const LostCardDialog();

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    DialogTheme dialogTheme = themeData.dialogTheme;
    TextStyle btnTextStyle = themeData.primaryTextTheme.button;

    Flushbar _lostCardFlush;
    _lostCardFlush = Flushbar(
      titleText: Text(
        l10n.lost_card_dialog_flush_title,
        style: TextStyle(
          height: 0.0,
        ),
      ),
      messageText: Text(
        l10n.lost_card_dialog_flush_message,
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
          l10n.lost_card_dialog_flush_action_order,
          style: theme.validatorStyle,
        ),
      ),
    );

    return AlertDialog(
      title: Text(
        l10n.lost_card_dialog_title,
        style: dialogTheme.titleTextStyle,
        maxLines: 2,
      ),
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 8.0),
      content: Container(
        width: context.mediaQuerySize.width,
        child: AutoSizeText(
          l10n.lost_card_dialog_message,
          style: dialogTheme.contentTextStyle,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 8.0),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            l10n.lost_card_dialog_action_cancel,
            style: btnTextStyle,
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            _lostCardFlush.show(context);
          },
          child: Text(
            l10n.lost_card_dialog_action_deactivate,
            style: btnTextStyle,
          ),
        ),
      ],
    );
  }
}
