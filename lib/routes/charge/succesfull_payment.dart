import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/practicles_animations.dart';
import 'package:flutter/material.dart';

class SuccesfullPaymentRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SuccesfullPaymentRouteState();
  }
}

class SuccesfullPaymentRouteState extends State<SuccesfullPaymentRoute>
    with WidgetsBindingObserver {
  Future _showFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_showFuture == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _showFuture = showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                  contentPadding: EdgeInsets.fromLTRB(40.0, 28.0, 40.0, 0.0),
                  content: _SuccessfullPaymentMessage());
            }).whenComplete(() => Navigator.of(context).pop());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Particles(50, color: Colors.blue.withAlpha(150))),
      ],
    );
  }
}

class _SuccessfullPaymentMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      //child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Text(
              'Payment approved!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .primaryTextTheme
                  .display1
                  .copyWith(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).buttonColor,
                shape: BoxShape.circle,
              ),
              child: Image(
                image: AssetImage("src/icon/ic_done.png"),
                height: 48.0,
                color: theme.themeId == "BLUE"
                    ? Color.fromRGBO(0, 133, 251, 1.0)
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
      // ),
    );
  }
}
