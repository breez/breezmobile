import 'dart:io';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

void listenUnexpectedError(
    BuildContext context, AccountBloc accountBloc) async {
  final torEnabled = await ServiceInjector().breezBridge.isTorActive();

  accountBloc.lightningDownStream.listen((allowRetry) {
    promptError(
      context,
      "Unexpected Error",
      RichText(
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
              if (torEnabled) ...<TextSpan>[
                TextSpan(
                    text: "• ",
                    style: Theme.of(context).dialogTheme.contentTextStyle),
                TextSpan(
                    text: "Disable ",
                    style: theme.blueLinkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        _promptForRestart(context).then((ok) async {
                          if (ok) {
                            await ServiceInjector()
                                .breezBridge
                                .enableOrDisableTor(false);
                            ResetNetwork resetAction = ResetNetwork();
                            accountBloc.userActionsSink.add(resetAction);
                            await resetAction.future;
                            Navigator.pop(context);
                            accountBloc.userActionsSink.add(RestartDaemon());
                          }
                        });
                      }),
                TextSpan(
                    text: "Tor\n",
                    style: Theme.of(context).dialogTheme.contentTextStyle)
              ],
              TextSpan(
                  text: "• ",
                  style: Theme.of(context).dialogTheme.contentTextStyle),
              TextSpan(
                  text: "Recover ",
                  style: theme.blueLinkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      _promptForRestart(context).then((ok) async {
                        if (ok) {
                          ResetChainService resetAction = ResetChainService();
                          accountBloc.userActionsSink.add(resetAction);
                          await resetAction.future;
                          exit(0);
                        }
                      });
                    }),
              TextSpan(
                  text: "chain information\n",
                  style: Theme.of(context).dialogTheme.contentTextStyle),
              TextSpan(
                  text: "• ",
                  style: Theme.of(context).dialogTheme.contentTextStyle),
              TextSpan(
                  text: "Reset ",
                  style: theme.blueLinkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      ResetNetwork resetAction = ResetNetwork();
                      accountBloc.userActionsSink.add(resetAction);
                      await resetAction.future;
                      Navigator.pop(context);
                      accountBloc.userActionsSink.add(RestartDaemon());
                    }),
              TextSpan(
                  text: "your Bitcoin node\n",
                  style: Theme.of(context).dialogTheme.contentTextStyle),
              TextSpan(
                  text: "• ",
                  style: Theme.of(context).dialogTheme.contentTextStyle),
              TextSpan(
                  text: "View ",
                  style: theme.blueLinkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      var logPath =
                          await ServiceInjector().breezBridge.getLogPath();
                      ShareExtend.share(logPath, "file");
                    }),
              TextSpan(
                  text: "your logs \n",
                  style: Theme.of(context).dialogTheme.contentTextStyle),
            ]),
      ),
      // Text(
      //     "You can try:\n• Turning off airplane mode\n• Turning on mobile data or Wi-Fi\n• Checking the signal in your area",
      //     style: Theme.of(context).dialogTheme.contentTextStyle),
      okText: allowRetry ? "TRY AGAIN" : "EXIT",
      okFunc: allowRetry
          ? () => accountBloc.userActionsSink.add(RestartDaemon())
          : () => exit(0),
      optionText: allowRetry ? "EXIT" : null,
      optionFunc: () => exit(0),
      disableBack: true,
    );
  });
}

Future _promptForRestart(BuildContext context) {
  return promptAreYouSure(
      context,
      null,
      Text("Restoring chain information might take several minutes.",
          style: Theme.of(context).dialogTheme.contentTextStyle),
      cancelText: "CANCEL",
      okText: "EXIT BREEZ");
}
