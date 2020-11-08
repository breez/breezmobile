import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/print_pdf.dart';
import 'package:breez/widgets/practicles_animations.dart';
import 'package:breez/widgets/print_parameters.dart';
import 'package:flutter/material.dart';

class SuccessfulPaymentRoute extends StatefulWidget {
  final PrintParameters printParameters;

  SuccessfulPaymentRoute({
    this.printParameters,
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
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: AlertDialog(
                    contentPadding: EdgeInsets.fromLTRB(40.0, 28.0, 0.0, 0.0),
                    content: _SuccessfulPaymentMessage(
                      printParameters: widget.printParameters,
                    )),
              );
            }).whenComplete(() => Navigator.of(context).pop());
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
}

class _SuccessfulPaymentMessage extends StatefulWidget {
  final PrintParameters printParameters;

  _SuccessfulPaymentMessage({
    this.printParameters,
  });

  @override
  State<StatefulWidget> createState() {
    return _SuccessfulPaymentMessageState();
  }
}

class _SuccessfulPaymentMessageState extends State<_SuccessfulPaymentMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Payment approved!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline4
                        .copyWith(fontSize: 16),
                  ),
                ),
                (widget.printParameters != null)
                    ? IconButton(
                        alignment: Alignment.centerRight,
                        tooltip: "Print",
                        iconSize: 24.0,
                        color: Theme.of(context).primaryTextTheme.button.color,
                        icon: Icon(Icons.local_print_shop_outlined),
                        onPressed: () => PrintService(
                                widget.printParameters.currentUser,
                                widget.printParameters.currentCurrency,
                                widget.printParameters.account,
                                widget.printParameters.submittedSale,
                                widget.printParameters.paymentInfo)
                            .printAsPDF(),
                      )
                    : SizedBox(width: 40),
              ],
            )),
        Padding(
          padding: EdgeInsets.only(bottom: 40.0, right: 40),
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
    );
  }
}
