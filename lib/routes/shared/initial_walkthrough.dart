import 'dart:async';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/restore_dialog.dart';

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
  StreamSubscription<Map<String, String>> _multipleRestoreSubscription;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _multipleRestoreSubscription = widget._backupBloc.multipleRestoreStream.listen((options) {
        popToWalkthrough();
        showDialog(context: context, builder: (_) =>
        new RestoreDialog(context, widget._backupBloc, options));
    });

    _restoreFinishedSubscription =
        widget._backupBloc.restoreFinishedStream.listen((restored) { 
        popToWalkthrough();         
        if (restored) {
          _proceedToRegister();
        }
    });

    _restoreFinishedSubscription.onError((error){
      popToWalkthrough();
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 3),
          content: new Text(error.toString())));
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

  void popToWalkthrough(){
    Navigator.popUntil(context, (route) {
      return route.settings.name == "/intro";          
    }); 
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: new Padding(
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
                        _proceedToRegister();
                      }
                    )),
                new Expanded(
                    flex: 40,
                    child: new Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: new GestureDetector(
                          onTap: () {
                            // Restore then start lightninglib
                            Navigator.push(context, TransparentPageRoute((context){
                              return Container(
                                color: Colors.black.withOpacity(0.3),
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Loader()
                                )
                              );
                            }));
                            widget._backupBloc.restoreRequestSink.add("");
                          },
                          child: new Text("Restore from backup", style: theme.restoreLinkStyle,)
                    )
                  ),
                ),
              ],
            )
          ])),
    );
  }
}
