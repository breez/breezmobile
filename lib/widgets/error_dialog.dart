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
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: canPopCallback,
          child: new AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            title: title == null
                ? null
                : new Text(
                    title,
                    style: Theme.of(context).dialogTheme.titleTextStyle,
                  ),
            content: new SingleChildScrollView(
              child: body,
            ),
            actions: <Widget>[
              optionText != null
                  ? new FlatButton(
                      child: new Text(
                        optionText,
                        style: new TextStyle(
                            fontFamily: "IBMPlexSansMedium",
                            fontSize: 16.4,
                            letterSpacing: 0.0,
                            color: Colors.black),
                      ),
                      onPressed: () {
                        canPop = true;
                        optionFunc();
                      },
                    )
                  : null,
              new FlatButton(
                child: new Text(okText, style: Theme.of(context).primaryTextTheme.button),
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
  
  Widget titleWidget = title == null ? null : Text(title, style: Theme.of(context).dialogTheme.titleTextStyle);
  if (titleWidget != null && wideTitle) {
    titleWidget = Container(
      child: titleWidget,
      width: MediaQuery.of(context).size.width,
    );
  }
  return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          contentPadding: contentPadding,
          title: titleWidget,
          content: new SingleChildScrollView(
            child: body,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(cancelText, style: Theme.of(context).primaryTextTheme.button),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text(okText, style: Theme.of(context).primaryTextTheme.button),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}
