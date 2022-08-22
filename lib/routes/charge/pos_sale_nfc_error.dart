import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PosSaleNfcError extends StatelessWidget {
  final String error;

  const PosSaleNfcError(
    this.error, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return AlertDialog(
      title: Text(
        texts.pos_payment_nfc_error_title,
        style: themeData.dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            error,
            style: themeData.dialogTheme.contentTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              texts.pos_payment_nfc_error_action_close,
              style: themeData.primaryTextTheme.button,
            ),
          )
        ],
      ),
    );
  }
}
