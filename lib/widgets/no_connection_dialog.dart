import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:share_extend/share_extend.dart';

import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;

Future<bool> showNoConnectionDialog(BuildContext context) {
  return showDialog<bool>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          title: Text(
            "No Internet Connection",
            style: Theme.of(context).dialogTheme.titleTextStyle,
          ),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                  text: "You can try:\n",
                  children: <TextSpan>[
                    TextSpan(
                        text: "• Turning off airplane mode\n",
                        style: Theme.of(context).dialogTheme.contentTextStyle),
                    TextSpan(
                        text: "• Turning on mobile data or Wi-Fi\n",
                        style: Theme.of(context).dialogTheme.contentTextStyle),
                    TextSpan(
                        text: "• Checking the signal in your area\n",
                        style: Theme.of(context).dialogTheme.contentTextStyle),
                    TextSpan(
                        text: "• ",
                        style: Theme.of(context).dialogTheme.contentTextStyle),
                    TextSpan(
                        text: "View ",
                        style: theme.blueLinkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            var logPath = await ServiceInjector()
                                .breezBridge
                                .getLogPath();
                            ShareExtend.share(logPath, "file");
                          }),
                    TextSpan(
                        text: "your logs \n",
                        style: Theme.of(context).dialogTheme.contentTextStyle),
                  ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL",
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("TRY AGAIN",
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}
