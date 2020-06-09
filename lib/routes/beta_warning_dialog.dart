import 'dart:io';

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

  _getContent() {
    List<Widget> children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 12.0),
        child: Text(
          "Since Breez is still in beta, there is a chance your money will be lost. Use this app only if you are willing to take this risk.",
          style: Theme.of(context)
              .primaryTextTheme
              .headline3
              .copyWith(fontSize: 16),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
        child: Row(
          children: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                  unselectedWidgetColor:
                      Theme.of(context).textTheme.button.color),
              child: Checkbox(
                  activeColor: Theme.of(context).canvasColor,
                  value: _isUnderstood,
                  onChanged: (value) {
                    setState(() {
                      _isUnderstood = value;
                    });
                  }),
            ),
            Text(
              "I understand",
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline3
                  .copyWith(fontSize: 16),
            )
          ],
        ),
      ),
      Visibility(
        visible: _showReminderText,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 16.0, right: 16.0, bottom: 0.0),
            child: Text(
              "Please confirm that you understand before you continue.",
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline3
                  .copyWith(fontSize: 16)
                  .copyWith(fontSize: 12.0, color: Colors.red),
            )),
      ),
    ];

    return children;
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
            "Beta Warning",
            style: Theme.of(context).dialogTheme.titleTextStyle,
          ),
          contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _getContent(),
          ),
          actions: [
            FlatButton(
              onPressed: () => exit(0),
              child: Text("EXIT",
                  style: Theme.of(context).primaryTextTheme.button),
            ),
            FlatButton(
              onPressed: (() {
                if (_isUnderstood) {
                  Navigator.of(context).pop(_isUnderstood);
                } else {
                  setState(() {
                    _showReminderText = !_isUnderstood;
                  });
                }
              }),
              child: Text("CONTINUE",
                  style: Theme.of(context).primaryTextTheme.button),
            ),
          ],
        ));
  }
}
