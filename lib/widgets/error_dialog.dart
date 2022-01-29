import 'dart:async';

import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';

Future<Null> promptError(
  BuildContext context,
  String title,
  Widget body, {
  String okText,
  String optionText,
  Function optionFunc,
  Function okFunc,
  bool disableBack = false,
}) {
  bool canPop = !disableBack;
  Future<bool> Function() canPopCallback = () => Future.value(canPop);
  DialogTheme dialogTheme = context.dialogTheme;
  return showDialog<Null>(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: canPopCallback,
        child: AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          title: title == null
              ? null
              : Text(
            title,
                  style: dialogTheme.titleTextStyle,
                ),
          content: SingleChildScrollView(
            child: body,
          ),
          actions: [
            optionText != null
                ? TextButton(
                    child: Text(
                      optionText,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'IBMPlexSans',
                        fontSize: 16.4,
                        letterSpacing: 0.0,
                        color: dialogTheme.titleTextStyle.color,
                      ),
                    ),
                    onPressed: () {
                      canPop = true;
                      optionFunc();
                    },
                  )
                : Container(),
            TextButton(
              child: Text(
                okText ?? context.l10n.error_dialog_default_action_ok,
                style: context.primaryTextTheme.button,
              ),
              onPressed: () {
                canPop = true;
                context.pop();
                if (okFunc != null) {
                  okFunc();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<bool> promptAreYouSure(
  BuildContext context,
  String title,
  Widget body, {
  contentPadding = const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
  bool wideTitle = false,
  String okText,
  String cancelText,
  TextStyle textStyle = const TextStyle(color: Colors.white),
}) {
  var l10n = context.l10n;
  TextTheme primaryTextTheme = context.primaryTextTheme;

  Widget titleWidget = title == null
      ? null
      : Text(
          title,
          style: context.dialogTheme.titleTextStyle,
        );
  if (titleWidget != null && wideTitle) {
    titleWidget = Container(
      child: titleWidget,
      width: context.mediaQuerySize.width,
    );
  }
  return showDialog<bool>(
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: contentPadding,
        title: titleWidget,
        content: SingleChildScrollView(
          child: body,
        ),
        actions: [
          TextButton(
            child: Text(
              cancelText ?? l10n.error_dialog_default_action_no,
              style: primaryTextTheme.button,
            ),
            onPressed: () {
              context.pop(false);
            },
          ),
          TextButton(
            child: Text(
              okText ?? l10n.error_dialog_default_action_yes,
              style: primaryTextTheme.button,
            ),
            onPressed: () => context.pop(true),
          ),
        ],
      );
    },
  );
}

Future<bool> promptMessage(
  BuildContext context,
  String title,
  Widget body, {
  contentPadding = const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
  bool wideTitle = false,
  String closeText,
  TextStyle textStyle = const TextStyle(color: Colors.white),
}) {
  Widget titleWidget = title == null
      ? null
      : Text(
    title,
          style: context.dialogTheme.titleTextStyle,
        );
  if (titleWidget != null && wideTitle) {
    titleWidget = Container(
      child: titleWidget,
      width: context.mediaQuerySize.width,
    );
  }
  return showDialog<bool>(
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: contentPadding,
        title: titleWidget,
        content: SingleChildScrollView(
          child: body,
        ),
        actions: [
          TextButton(
            child: Text(
              closeText ?? context.l10n.error_dialog_default_action_close,
              style: context.primaryTextTheme.button,
            ),
            onPressed: () => context.pop(false),
          ),
        ],
      );
    },
  );
}
