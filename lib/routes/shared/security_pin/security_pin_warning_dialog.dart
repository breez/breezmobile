import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class SecurityPINWarningDialog extends StatefulWidget {
  @override
  _SecurityPINWarningDialogState createState() => new _SecurityPINWarningDialogState();
}

class _SecurityPINWarningDialogState extends State<SecurityPINWarningDialog> {
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
        child: new Text(
          "If you forget your PIN, you won't be able to to restore your balance and your funds will be lost. Breez doesn't provide any way to restore your PIN.",
          style: theme.paymentRequestSubtitleStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
        child: Row(
          children: <Widget>[
            Checkbox(
                activeColor: theme.BreezColors.blue[500],
                value: _isUnderstood,
                onChanged: (value) {
                  setState(() {
                    _isUnderstood = value;
                  });
                }),
            Text(
              "I understand",
              style: theme.paymentRequestSubtitleStyle,
            )
          ],
        ),
      ),
      Visibility(
        visible: _showReminderText,
        child: Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0, bottom: 0.0),
            child: Text(
              "Please confirm that you understand before you continue.",
              style: theme.paymentRequestSubtitleStyle.copyWith(fontSize: 12.0, color: Colors.red),
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
        child: new AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _getContent(),
          ),
          actions: [
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text("Cancel", style: theme.buttonStyle),
            ),
            new FlatButton(
              onPressed: (() {
                if (_isUnderstood) {
                  Navigator.of(context).pop(_isUnderstood);
                } else {
                  setState(() {
                    _showReminderText = !_isUnderstood;
                  });
                }
              }),
              child: new Text("Continue", style: theme.buttonStyle),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ));
  }
}
