import 'dart:async';
import 'dart:io';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/routes/shared/security_pin/restore_pin.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/restore_dialog.dart';
import 'package:breez/routes/user/home/beta_warning_dialog.dart';

class InitialWalkthroughPage extends StatefulWidget {
  final UserProfileBloc _registrationBloc;
  final BackupBloc _backupBloc;
  final bool _isPos;

  InitialWalkthroughPage(this._registrationBloc, this._backupBloc, this._isPos);

  @override
  State createState() => new InitialWalkthroughPageState();
}

class InitialWalkthroughPageState extends State<InitialWalkthroughPage>
    with TickerProviderStateMixin {
  final String _instructions =
      "The simplest, fastest & safest way\nto spend your bitcoins";
  AnimationController _controller;
  Animation<int> _animation;

  StreamSubscription<bool> _restoreFinishedSubscription;
  StreamSubscription<List<SnapshotInfo>> _multipleRestoreSubscription;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _registered = false;

  @override
  void initState() {
    super.initState();

    _multipleRestoreSubscription =
        widget._backupBloc.multipleRestoreStream.listen((options) async {
      if (options.length == 0) {
        popToWalkthrough(error: "Could not locate backup for this account");
        return;
      }


      SnapshotInfo toRestore;
      if (options.length == 1) {
        toRestore = options.first;
      } else {
        popToWalkthrough();
        toRestore = await showDialog<SnapshotInfo>(
            context: context,
            builder: (_) =>
                new RestoreDialog(context, widget._backupBloc, options));
      }

      String restorePIN;
      if (toRestore != null) {
        if (toRestore.encrypted) {
          restorePIN = await getRestorePIN();
          if (restorePIN == null) {
            return;
          }
        }
        widget._backupBloc.restoreRequestSink
            .add(RestoreRequest(toRestore, restorePIN));
        Navigator.push(
            context,
            createLoaderRoute(context,
                message: "Restoring data...", opacity: 0.8));
      }
    }, onError: (error) {
      popToWalkthrough(
          error: error.runtimeType != SignInFailedException
              ? error.toString()
              : null);
    });

    _restoreFinishedSubscription =
        widget._backupBloc.restoreFinishedStream.listen((restored) {
      popToWalkthrough();
      if (restored) {
        _proceedToRegister();
      }
    }, onError: (error) {
      popToWalkthrough(
          error: error.runtimeType != SignInFailedException
              ? error.toString()
              : null);
    });

    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2720))
      ..forward(from: 0.0);
    _animation = new IntTween(begin: 0, end: 67).animate(_controller);
    if (_controller.isCompleted) {
      _controller.stop();
      _controller.dispose();
    }
  }

  Future<String> getRestorePIN() {
    return Navigator.of(context).push(new FadeInRoute(
      builder: (BuildContext context) {
        return RestorePinCode();
      },
    ));
  }

  void popToWalkthrough({String error}) {
    Navigator.popUntil(context, (route) {
      return route.settings.name == "/intro";
    });
    if (error != null) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 3),
          content: new Text(error.toString())));
    }
  }

  @override
  void dispose() {
    _multipleRestoreSubscription.cancel();
    _restoreFinishedSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _proceedToRegister() {
    widget._registrationBloc.registerSink.add(null);
    _registered = true;
    Navigator.of(context).pop();
  }

  Future<bool> _onWillPop() async {
    if (!_registered) {
      exit(0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Padding(
            padding: new EdgeInsets.only(top: 24.0),
            child: new Stack(children: <Widget>[
              new Column(
                children: <Widget>[
                  new Expanded(flex: 244, child: new Container()),
                  new Expanded(
                      flex: 372,
                      child: new Image.asset(
                        'src/images/waves-middle.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )),
                ],
              ),
              new Column(
                children: <Widget>[
                  new Expanded(flex: 60, child: new Container()),
                  new Expanded(
                    flex: 151,
                    child: new AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget child) {
                        String frame =
                            _animation.value.toString().padLeft(2, '0');
                        return new Image.asset(
                          'src/animations/welcome/frame_${frame}_delay-0.04s.png',
                          gaplessPlayback: true,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  new Expanded(flex: 190, child: new Container()),
                  new Expanded(
                    flex: 48,
                    child: new Text(
                      _instructions,
                      textAlign: TextAlign.center,
                      style: theme.welcomeTextStyle,
                    ),
                  ),
                  new Expanded(flex: 79, child: new Container()),
                  new Container(
                      height: 48.0,
                      width: 168.0,
                      child: new RaisedButton(
                          child: new Text("LET'S BREEZ!",
                              style: theme.buttonStyle),
                          color: theme.whiteColor,
                          elevation: 0.0,
                          shape: const StadiumBorder(),
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return BetaWarningDialog();
                                }).then((approved) {
                              if (approved) {
                                _proceedToRegister();
                              }
                            });
                          })),
                  new Expanded(
                    flex: 40,
                    child: new Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: new GestureDetector(
                            onTap: () {
                              // Restore then start lightninglib
                              Navigator.push(
                                  context, createLoaderRoute(context));
                              widget._backupBloc.restoreRequestSink.add(null);
                            },
                            child: new Text(
                              "Restore from backup",
                              style: theme.restoreLinkStyle,
                            ))),
                  ),
                ],
              )
            ])),
      ),
    );
  }
}
