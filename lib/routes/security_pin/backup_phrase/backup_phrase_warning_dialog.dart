import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class BackupPhraseWarningDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getContent(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              texts.backup_phrase_warning_action_no,
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              texts.backup_phrase_warning_action_yes,
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getContent(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return [
      Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 12.0,
        ),
        child: Text(
          texts.backup_phrase_warning_disclaimer,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      ),
    ];
  }
}
