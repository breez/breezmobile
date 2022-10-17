import 'dart:async';

import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  final ClovrUserModel _user;

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
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  _startTime() async {
    return Timer(Duration(milliseconds: 3600), () {
      Navigator.of(context).pushReplacementNamed('/intro');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Center(
        child: SizedBox(),
      ),
    ]));
  }
}
