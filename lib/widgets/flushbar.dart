import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar showFlushbar(
  BuildContext context, {
  String title,
  String message,
  Widget messageWidget,
  String buttonText,
  FlushbarPosition position = FlushbarPosition.BOTTOM,
  bool Function() onDismiss,
  Duration duration = const Duration(seconds: 8),
}) {
  var l10n = context.l10n;

  Flushbar flush;
  flush = Flushbar(
    flushbarPosition: position,
    titleText: title == null
        ? null
        : Text(
            title,
            style: TextStyle(height: 0.0),
          ),
    duration: duration == Duration.zero ? null : duration,
    messageText: messageWidget ??
        Text(
          message ?? l10n.flushbar_default_message,
          style: theme.snackBarStyle,
          textAlign: TextAlign.left,
        ),
    backgroundColor: theme.snackBarBackgroundColor,
    mainButton: TextButton(
      onPressed: () {
        bool dismiss = onDismiss != null ? onDismiss() : true;
        if (dismiss) {
          flush.dismiss(true);
        }
      },
      child: Text(
        buttonText ?? l10n.flushbar_default_action,
        style: theme.snackBarStyle.copyWith(
          color: context.errorColor,
        ),
      ),
    ),
  )..show(context);

  return flush;
}

void popFlushbars(BuildContext context) {
  context.popUntil((route) {
    return route.settings.name != FLUSHBAR_ROUTE_NAME;
  });
}
