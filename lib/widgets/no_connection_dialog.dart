import 'dart:async';

import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

Future<bool> showNoConnectionDialog(BuildContext context) {
  var l10n = context.l10n;
  ThemeData themeData = context.theme;
  DialogTheme dialogTheme = themeData.dialogTheme;
  TextStyle dialogContentTextStyle = dialogTheme.contentTextStyle;
  TextStyle btnTextStyle = themeData.primaryTextTheme.button;

  return showDialog<bool>(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        title: Text(
          l10n.no_connection_dialog_title,
          style: dialogTheme.titleTextStyle,
        ),
        content: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: dialogContentTextStyle,
              text: l10n.no_connection_dialog_tip_begin,
              children: [
                TextSpan(
                  text: l10n.no_connection_dialog_tip_airplane,
                  style: dialogContentTextStyle,
                ),
                TextSpan(
                  text: l10n.no_connection_dialog_tip_wifi,
                  style: dialogContentTextStyle,
                ),
                TextSpan(
                  text: l10n.no_connection_dialog_tip_signal,
                  style: dialogContentTextStyle,
                ),
                TextSpan(
                  text: "• ",
                  style: dialogContentTextStyle,
                ),
                TextSpan(
                  text: l10n.no_connection_dialog_log_view_action,
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
                  text: l10n.no_connection_dialog_log_view_message,
                  style: dialogContentTextStyle,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              l10n.no_connection_dialog_action_cancel,
              style: btnTextStyle,
            ),
            onPressed: () => context.pop(false),
          ),
          TextButton(
            child: Text(
              l10n.no_connection_dialog_action_try_again,
              style: btnTextStyle,
            ),
            onPressed: () => context.pop(true),
          ),
        ],
      );
    },
  );
}
