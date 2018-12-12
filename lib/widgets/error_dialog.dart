import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

Future<Null> promptError(BuildContext context, String title, Widget body,
    {String okText = "OK", String optionText, Function optionFunc, Function okFunc, bool disableBack = false}) {

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
            title: title == null ? null : new Text(title, style: theme.alertTitleStyle,),
            content: new SingleChildScrollView(
              child: body,
            ),
            actions: <Widget>[
              optionText != null ? new FlatButton(
                child: new Text(optionText,style: new TextStyle(
                    fontFamily: "IBMPlexSansMedium", fontSize: 16.4, letterSpacing: 0.0, color: Colors.black),),
                onPressed: () {
                  canPop = true;
                  optionFunc();
                },
              ) : null,
              new FlatButton(
                child: new Text(okText, style: theme.buttonStyle),
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

Future promptAreYouSure(BuildContext context, String title, Widget body, {String okText = "YES", String cancelText = "NO", TextStyle textStyle = const TextStyle(color: Colors.white)}) {  
  return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          contentPadding: EdgeInsets.only(top:32.0,left: 32.0,right: 32.0),
          title: title == null ? null : new Text(title, style: textStyle),
          content: new SingleChildScrollView(
            child: body,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(cancelText, style: textStyle),
              onPressed: () {
                Navigator.of(context).pop(false);                
              },
            ),
            new FlatButton(
              child: new Text(okText, style: textStyle),
              onPressed: () {
                Navigator.of(context).pop(true);                
              },
            ),
          ],
        );
      });
}
