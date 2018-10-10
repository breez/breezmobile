import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class InitialWalkthroughPage extends StatefulWidget {
  final UserProfileBloc _registrationBloc;
  final bool _isPos;

  InitialWalkthroughPage(this._registrationBloc, this._isPos);

  @override
  State createState() => new InitialWalkthroughPageState();
}

class InitialWalkthroughPageState extends State<InitialWalkthroughPage>
    with TickerProviderStateMixin {
  final String _instructions =
      "The simplest, fastest & safest way\nto spend your bitcoins";
  AnimationController _controller;
  Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2720))
      ..forward(from: 0.0);
    _animation = new IntTween(begin: 0, end: 67).animate(_controller);
    if (_controller.isCompleted) {
      _controller.stop();
      _controller.dispose();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: new Key("RegistrationPage"),
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
                new Expanded(
                    flex: 48,
                    child: new Container(
                        height: 48.0,
                        width: 168.0,
                        child: new RaisedButton(
                          child: new Text("LET'S BREEZ!",
                              style: theme.buttonStyle),
                          color: theme.whiteColor,
                          elevation: 0.0,
                          shape: const StadiumBorder(),
                          onPressed: () {
                            widget._registrationBloc.registerSink.add(null);
                            if (widget._isPos) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator
                                  .of(context)
                                  .pushReplacementNamed("/order_card?skip=true");
                            }
                          },
                        ))),
                new Expanded(flex: 40, child: new Container())
              ],
            )
          ])),
    );
  }
}
