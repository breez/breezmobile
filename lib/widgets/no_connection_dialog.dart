import 'dart:async';

import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';
import 'package:share_extend/share_extend.dart';

Future<bool> showNoConnectionDialog(BuildContext context) {
  return showDialog<bool>(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        title: Text(
          context.l10n.no_connection_dialog_title,
          style: Theme.of(context).dialogTheme.titleTextStyle,
        ),
        content: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).dialogTheme.contentTextStyle,
              text: context.l10n.no_connection_dialog_tip_begin,
              children: [
                TextSpan(
                  text: context.l10n.no_connection_dialog_tip_airplane,
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
                TextSpan(
                  text: context.l10n.no_connection_dialog_tip_wifi,
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
                TextSpan(
                  text: context.l10n.no_connection_dialog_tip_signal,
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
                TextSpan(
                  text: "• ",
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
                TextSpan(
                  text: context.l10n.no_connection_dialog_log_view_action,
                  style: theme.blueLinkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      ShareExtend.share(
                        await ServiceInjector().breezBridge.getLogPath(),
                        "file",
                      );
                    },
                ),
                TextSpan(
                  text: context.l10n.no_connection_dialog_log_view_message,
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              context.l10n.no_connection_dialog_action_cancel,
              style: Theme.of(context).primaryTextTheme.button,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(
              context.l10n.no_connection_dialog_action_try_again,
              style: Theme.of(context).primaryTextTheme.button,
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
}
