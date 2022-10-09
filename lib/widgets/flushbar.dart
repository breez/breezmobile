import 'package:breez/theme_data.dart' as theme;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Flushbar showFlushbar(
  BuildContext context, {
  String title,
  String message,
  Widget messageWidget,
  String buttonText,
  FlushbarPosition position = FlushbarPosition.BOTTOM,
  bool Function() onDismiss,
  bool isDismissible = true,
  Widget icon,
  Widget button,
  Duration duration = const Duration(seconds: 8),
}) {
  final themeData = Theme.of(context);
  final texts = AppLocalizations.of(context);

  Flushbar flush;
  flush = Flushbar(
    isDismissible: isDismissible,
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
          message ?? texts.flushbar_default_message,
          style: theme.snackBarStyle,
          textAlign: TextAlign.left,
        ),
    backgroundColor: theme.snackBarBackgroundColor,
    icon: icon,
    mainButton: button != null ? button : buttonText == "" ? null : TextButton(
      onPressed: () {
        bool dismiss = onDismiss != null ? onDismiss() : true;
        if (dismiss) {
          flush.dismiss(true);
        }
      },
      child: Text(
        buttonText ?? texts.flushbar_default_action,
        style: theme.snackBarStyle.copyWith(
          color: themeData.errorColor,
        ),
      ),
    ),
  )..show(context);

  return flush;
}

void popFlushbars(BuildContext context) {
  Navigator.popUntil(context, (route) {
    return route.settings.name != FLUSHBAR_ROUTE_NAME;
  });
}
