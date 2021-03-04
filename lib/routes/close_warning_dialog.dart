import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class CloseWarningDialog extends StatefulWidget {
  final int inactiveDuration;

  CloseWarningDialog(this.inactiveDuration);

  @override
  _CloseWarningDialogState createState() => _CloseWarningDialogState();
}

class _CloseWarningDialogState extends State<CloseWarningDialog> {
  @override
  void initState() {
    super.initState();
  }

  _getContent() {
    List<Widget> children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 12.0),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
            text: """You haven't made any payments with Breez for """ +
                (widget.inactiveDuration ~/ 86400).toString() +
                """ days, so your LSP might have to close your channels.
Should this happen, Breez will generate an on-chain address and sweep your funds into it. You will retain complete control of your money, less the mining fee incurred by the sweep transaction, and you can come back any time. To learn more about why this happens, read our post on """,
            style: Theme.of(context)
                .primaryTextTheme
                .headline3
                .copyWith(fontSize: 16),
          ),
          _LinkTextSpan(
              text: "inbound liquidity",
              url:
                  "https://medium.com/breez-technology/lightning-economics-how-i-learned-to-stop-worrying-and-love-inbound-liquidity-511d05aa8b8b",
              style: Theme.of(context).primaryTextTheme.headline3.copyWith(
                  fontSize: 16, decoration: TextDecoration.underline)),
          TextSpan(
            text: ".",
            style: Theme.of(context)
                .primaryTextTheme
                .headline3
                .copyWith(fontSize: 16),
          ),
        ])),
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
            "Inactive Channels",
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
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child:
                  Text("OK", style: Theme.of(context).primaryTextTheme.button),
            ),
          ],
        ));
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceSafariVC: false);
              });
}
