import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/particles_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme_data.dart';

class SuccessfulPaymentRoute extends StatefulWidget {
  final Function() onPrint;

  SuccessfulPaymentRoute({
    this.onPrint,
  });

  @override
  State<StatefulWidget> createState() {
    return SuccessfulPaymentRouteState();
  }
}

class SuccessfulPaymentRouteState extends State<SuccessfulPaymentRoute>
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
            barrierDismissible: true,
            builder: (BuildContext context) {
              Color iconColor = context.appBarTheme.actionsIconTheme.color;

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  context.pop();
                },
                child: AlertDialog(
                  title: (widget.onPrint != null)
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                      tooltip: "Print",
                            iconSize: 24.0,
                            color: iconColor,
                            icon: SvgPicture.asset(
                              "src/icon/printer.svg",
                              color: iconColor,
                              fit: BoxFit.contain,
                              width: 24.0,
                              height: 24.0,
                            ),
                            onPressed: widget.onPrint,
                          ),
                        )
                      : SizedBox(
                          height: 40,
                        ),
                  titlePadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  contentPadding: EdgeInsets.symmetric(horizontal: 40),
                  content: _buildSuccessfulPaymentMessage(),
                ),
              );
            }).whenComplete(() => context.pop());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: Particles(50, color: Colors.blue.withAlpha(150))),
      ],
    );
  }

  _buildSuccessfulPaymentMessage() {
    ThemeData themeData = context.theme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Payment received!',
          textAlign: TextAlign.center,
          style: themeData.primaryTextTheme.headline4.copyWith(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: Container(
            decoration: new BoxDecoration(
              color: (themeId == "BLUE")
                  ? Colors.white
                  : themeData.primaryColorLight,
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
    );
  }
}
