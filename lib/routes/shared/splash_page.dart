import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  final BreezUserModel _user;
  SplashPage(this._user);

  @override
  SplashPageState createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkIfFirstRun();
  }

  Future checkIfFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _isFirstRun = (prefs.getBool('isFirstRun') ?? true);
    if (widget._user.registered == null ||
        widget._user.registered == false ||
        _isFirstRun) {
      prefs.setBool('isFirstRun', false);
      _startTime();
    } else {
      prefs.setBool('isFirstRun', true);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  _startTime() async {
    return new Timer(new Duration(milliseconds: 3600), () {
      Navigator.of(context).pushReplacementNamed('/intro');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(children: <Widget>[
      new Center(
        child: new Image.asset(
          'src/images/splash-animation.gif',
          fit: BoxFit.contain,
          gaplessPlayback: true,
          width: MediaQuery.of(context).size.width / 3,
        ),
      ),
      new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Image.asset('src/images/waves-bottom.png', fit: BoxFit.cover)
          ])
    ]));
  }
}
