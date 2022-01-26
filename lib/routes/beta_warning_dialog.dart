import 'dart:io';

import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';

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
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Theme.of(context).canvasColor,
      ),
      child: AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          context.l10n.beta_warning_title,
          style: Theme.of(context).dialogTheme.titleTextStyle,
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
              context.l10n.beta_warning_action_exit,
              style: Theme.of(context).primaryTextTheme.button,
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
              context.l10n.beta_warning_action_continue,
              style: Theme.of(context).primaryTextTheme.button,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getContent(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 12.0),
        child: Text(
          context.l10n.beta_warning_message,
          style: Theme.of(context).primaryTextTheme.headline3.copyWith(
            fontSize: 16,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
        child: Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Theme.of(context).textTheme.button.color,
              ),
              child: Checkbox(
                activeColor: Theme.of(context).canvasColor,
                value: _isUnderstood,
                onChanged: (value) {
                  setState(() {
                    _isUnderstood = value;
                  });
                },
              ),
            ),
            Text(
              context.l10n.beta_warning_understand,
              style: Theme.of(context).primaryTextTheme.headline3.copyWith(
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
            context.l10n.beta_warning_understand_confirmation,
            style: Theme.of(context).primaryTextTheme.headline3
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
