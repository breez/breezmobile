import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Null> promptError(BuildContext context, String title, Widget body,
    {String okText = "OK",
    String optionText,
    Function optionFunc,
    Function okFunc,
    bool disableBack = false}) {
  bool canPop = !disableBack;
  Future<bool> Function() canPopCallback = () => Future.value(canPop);

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
                    style: Theme.of(context).dialogTheme.titleTextStyle,
                  ),
            content: SingleChildScrollView(
              child: body,
            ),
            actions: <Widget>[
              optionText != null
                  ? TextButton(
                      child: Text(
                        optionText,
                        style: Theme.of(context).primaryTextTheme.button,
                      ),
                      onPressed: () {
                        canPop = true;
                        optionFunc();
                      },
                    )
                  : Container(),
              TextButton(
                child: Text(okText,
                    style: Theme.of(context).primaryTextTheme.button),
                onPressed: () {
                  canPop = true;
                  Navigator.of(context).pop();
                  if (okFunc != null) {
                    okFunc();
                  }
                },
              ),
            ],
          ),
        );
      });
}

Future<bool> promptAreYouSure(BuildContext context, String title, Widget body,
    {contentPadding = const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
    bool wideTitle = false,
    String okText = "YES",
    String cancelText = "NO",
    TextStyle textStyle = const TextStyle(color: Colors.white)}) {
  Widget titleWidget = title == null
      ? null
      : Text(title, style: Theme.of(context).dialogTheme.titleTextStyle);
  if (titleWidget != null && wideTitle) {
    titleWidget = Container(
      child: titleWidget,
      width: MediaQuery.of(context).size.width,
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
          actions: <Widget>[
            TextButton(
              child: Text(cancelText,
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(okText,
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}

Future<bool> promptMessage(BuildContext context, String title, Widget body,
    {contentPadding = const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
    bool wideTitle = false,
    String closeText = "CLOSE",
    TextStyle textStyle = const TextStyle(color: Colors.white)}) {
  Widget titleWidget = title == null
      ? null
      : Text(title, style: Theme.of(context).dialogTheme.titleTextStyle);
  if (titleWidget != null && wideTitle) {
    titleWidget = Container(
      child: titleWidget,
      width: MediaQuery.of(context).size.width,
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
          actions: <Widget>[
            TextButton(
              child: Text(closeText,
                  style: Theme.of(context).primaryTextTheme.button),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      });
}
