import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/theme_data.dart' as theme;

class BetaWarningDialog extends StatefulWidget {
  @override
  _BetaWarningDialogState createState() => new _BetaWarningDialogState();
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
        child: new Text(
          "Since Breez is still in beta, there is a chance your money will be lost. Use this app only if you are willing to take this risk.",
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
            padding: const EdgeInsets.only(
                top: 0.0, left: 16.0, right: 16.0, bottom: 0.0),
            child: Text(
              "Please confirm that you understand before you continue.",
              style: theme.paymentRequestSubtitleStyle
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
        child: new AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
          title: new Text(
            "Beta Warning",
            style: theme.alertTitleStyle,
          ),
          contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _getContent(),
          ),
          actions: [
            new SimpleDialogOption(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: new Text("Exit", style: theme.buttonStyle),
            ),
            new SimpleDialogOption(
              onPressed: (() {
                if (_isUnderstood) {
                  Navigator.of(context).pushReplacementNamed('/home');
                } else {
                  setState(() {
                    _showReminderText = !_isUnderstood;
                  });
                }
              }),
              child: new Text("Continue", style: theme.buttonStyle),
            ),
          ],
        ));
  }
}
