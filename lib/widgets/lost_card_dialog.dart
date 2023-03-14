import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class LostCardDialog extends StatelessWidget {
  const LostCardDialog();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(context);
    final texts = context.texts();

    Flushbar lostCardFlush;
    lostCardFlush = Flushbar(
      titleText: Text(
        texts.lost_card_dialog_flush_title,
        style: const TextStyle(
          height: 0.0,
        ),
      ),
      messageText: Text(
        texts.lost_card_dialog_flush_message,
        style: theme.snackBarStyle,
        textAlign: TextAlign.left,
      ),
      duration: const Duration(seconds: 8),
      backgroundColor: theme.snackBarBackgroundColor,
      mainButton: TextButton(
        onPressed: () {
          lostCardFlush.dismiss(true);
          Navigator.pushReplacementNamed(context, "/order_card");
        },
        child: Text(
          texts.lost_card_dialog_flush_action_order,
          style: theme.validatorStyle,
        ),
      ),
    );

    return AlertDialog(
      title: Text(
        texts.lost_card_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
        maxLines: 2,
      ),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 8.0),
      content: SizedBox(
        width: queryData.size.width,
        child: AutoSizeText(
          texts.lost_card_dialog_message,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 8.0),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            texts.lost_card_dialog_action_cancel,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            lostCardFlush.show(context);
          },
          child: Text(
            texts.lost_card_dialog_action_deactivate,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
