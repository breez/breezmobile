import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BetaWarningDialog extends StatefulWidget {
  @override
  _BetaWarningDialogState createState() => _BetaWarningDialogState();
}

class _BetaWarningDialogState extends State<BetaWarningDialog> {
  bool _isUnderstood = false;
  bool _showReminderText = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          texts.beta_warning_title,
          style: themeData.dialogTheme.titleTextStyle,
        ),
        contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getContent(context),
        ),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: Text(
              texts.beta_warning_action_exit,
              style: themeData.primaryTextTheme.button,
            ),
          ),
          TextButton(
            onPressed: (() {
              if (_isUnderstood) {
                Navigator.of(context).pop(_isUnderstood);
              } else {
                setState(() {
                  _showReminderText = !_isUnderstood;
                });
              }
            }),
            child: Text(
              texts.beta_warning_action_continue,
              style: themeData.primaryTextTheme.button,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getContent(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 12.0),
        child: Text(
          texts.beta_warning_message,
          style: themeData.primaryTextTheme.headline3.copyWith(
            fontSize: 16,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
        child: Row(
          children: [
            Theme(
              data: themeData.copyWith(
                unselectedWidgetColor: themeData.textTheme.button.color,
              ),
              child: Checkbox(
                activeColor: themeData.canvasColor,
                value: _isUnderstood,
                onChanged: (value) {
                  setState(() {
                    _isUnderstood = value;
                  });
                },
              ),
            ),
            Text(
              texts.beta_warning_understand,
              style: themeData.primaryTextTheme.headline3.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      Visibility(
        visible: _showReminderText,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Text(
            texts.beta_warning_understand_confirmation,
            style: themeData.primaryTextTheme.headline3
                .copyWith(
                  fontSize: 16,
                )
                .copyWith(
                  fontSize: 12.0,
                  color: Colors.red,
                ),
          ),
        ),
      ),
    ];
  }
}
