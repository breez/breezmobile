import 'dart:io';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:breez_translations/breez_translations_locales.dart';

void listenUnexpectedError(
    BuildContext context, AccountBloc accountBloc) async {
  final texts = context.texts();
  final themeData = Theme.of(context);
  final torEnabled = await ServiceInjector().breezBridge.getTorActive();
  accountBloc.lightningDownStream.listen((allowRetry) {
    promptError(
      context,
      texts.unexpected_error_title,
      RichText(
        text: TextSpan(
          style: themeData.dialogTheme.contentTextStyle,
          text: texts.unexpected_error_suggestions,
          children: <TextSpan>[
            TextSpan(
              text: texts.unexpected_error_airplane,
              style: themeData.dialogTheme.contentTextStyle,
            ),
            TextSpan(
              text: texts.unexpected_error_wifi,
              style: themeData.dialogTheme.contentTextStyle,
            ),
            TextSpan(
              text: texts.unexpected_error_signal,
              style: themeData.dialogTheme.contentTextStyle,
            ),
            if (torEnabled) ...<TextSpan>[
              TextSpan(
                  text: texts.unexpected_error_bullet,
                  style: Theme.of(context).dialogTheme.contentTextStyle),
              TextSpan(
                  text: '${texts.unexpected_error_deactivate_tor} ',
                  style: theme.blueLinkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      _promptForRestart(context).then((ok) async {
                        if (ok) {
                          await ServiceInjector()
                              .breezBridge
                              .setTorActive(false);
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
              text: texts.unexpected_error_bullet,
              style: themeData.dialogTheme.contentTextStyle,
            ),
            TextSpan(
              text: texts.unexpected_error_recover,
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
                },
            ),
            TextSpan(
              text: texts.unexpected_error_chain_information,
              style: themeData.dialogTheme.contentTextStyle,
            ),
            TextSpan(
              text: texts.unexpected_error_bullet,
              style: themeData.dialogTheme.contentTextStyle,
            ),
            TextSpan(
              text: texts.unexpected_error_reset,
              style: theme.blueLinkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  ResetNetwork resetAction = ResetNetwork();
                  accountBloc.userActionsSink.add(resetAction);
                  await resetAction.future;
                  Navigator.pop(context);
                  accountBloc.userActionsSink.add(RestartDaemon());
                },
            ),
            TextSpan(
              text: texts.unexpected_error_bitcoin_node,
              style: themeData.dialogTheme.contentTextStyle,
            ),
            TextSpan(
              text: texts.unexpected_error_bullet,
              style: themeData.dialogTheme.contentTextStyle,
            ),
            TextSpan(
              text: texts.unexpected_error_view,
              style: theme.blueLinkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final logFile = XFile(
                    await ServiceInjector().breezBridge.getLogPath(),
                  );
                  Share.shareXFiles(
                    [logFile],
                  );
                },
            ),
            TextSpan(
              text: texts.unexpected_error_logs,
              style: themeData.dialogTheme.contentTextStyle,
            ),
          ],
        ),
      ),
      okText: allowRetry
          ? texts.unexpected_error_action_try_again
          : texts.unexpected_error_action_just_exit,
      okFunc: allowRetry
          ? () => accountBloc.userActionsSink.add(RestartDaemon())
          : () => exit(0),
      optionText:
          allowRetry ? texts.unexpected_error_action_exit_for_retry : null,
      optionFunc: () => exit(0),
      disableBack: true,
    );
  });
}

Future _promptForRestart(BuildContext context) {
  final themeData = Theme.of(context);
  final texts = context.texts();
  return promptAreYouSure(
    context,
    null,
    Text(
      texts.unexpected_error_restoring_chain_message,
      style: themeData.dialogTheme.contentTextStyle,
    ),
    cancelText: texts.unexpected_error_action_cancel,
    okText: texts.unexpected_error_action_exit,
  );
}
