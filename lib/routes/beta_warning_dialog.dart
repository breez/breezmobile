import 'dart:io';

import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';

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
    var l10n = context.l10n;
    ThemeData theme = context.theme;
    DialogTheme dialogTheme = theme.dialogTheme;
    TextTheme primaryTextTheme = theme.primaryTextTheme;

    return Theme(
      data: theme.copyWith(
        unselectedWidgetColor: theme.canvasColor,
      ),
      child: AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          l10n.beta_warning_title,
          style: dialogTheme.titleTextStyle,
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
              l10n.beta_warning_action_exit,
              style: primaryTextTheme.button,
            ),
          ),
          TextButton(
            onPressed: (() {
              if (_isUnderstood) {
                context.pop(_isUnderstood);
              } else {
                setState(() {
                  _showReminderText = !_isUnderstood;
                });
              }
            }),
            child: Text(
              l10n.beta_warning_action_continue,
              style: primaryTextTheme.button,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getContent(BuildContext context) {
    var l10n = context.l10n;
    ThemeData theme = context.theme;
    Color unselectedWidgetColor = theme.textTheme.button.color;
    TextStyle headline3 =
        theme.primaryTextTheme.headline3.copyWith(fontSize: 16);

    return [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 12.0),
        child: Text(l10n.beta_warning_message, style: headline3),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
        child: Row(
          children: [
            Theme(
              data:
                  theme.copyWith(unselectedWidgetColor: unselectedWidgetColor),
              child: Checkbox(
                activeColor: theme.canvasColor,
                value: _isUnderstood,
                onChanged: (value) {
                  setState(() {
                    _isUnderstood = value;
                  });
                },
              ),
            ),
            Text(l10n.beta_warning_understand, style: headline3),
          ],
        ),
      ),
      Visibility(
        visible: _showReminderText,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Text(
            l10n.beta_warning_understand_confirmation,
            style: headline3.copyWith(fontSize: 12.0, color: Colors.red),
          ),
        ),
      ),
    ];
  }
}
