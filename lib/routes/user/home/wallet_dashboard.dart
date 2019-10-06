import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/fade_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/routes/user/home/status_indicator.dart';
import 'dart:math';

class WalletDashboard extends StatefulWidget {
  final AccountModel _accountModel;
  final AccountSettings _accSettings;
  final double _height;
  final double _offsetFactor;
  final Function(Currency currency) _onCurrencyChange;  

  WalletDashboard(this._accSettings, this._accountModel, this._height, this._offsetFactor, this._onCurrencyChange);

  @override
  State<StatefulWidget> createState() {
    return new WalletDashboardState();
  }
}

class WalletDashboardState extends State<WalletDashboard> {
  static const CHART_MAX_VERTICAL_OFFSET = 70.0;
  static const CHART_MAX_HORIZONTAL_OFFSET = 30.0;
  static const BALANCE_OFFSET_TRANSITION = 30.0;
  bool _showFiatCurrency = false;


  @override
  Widget build(BuildContext context) {
    double startHeaderSize = Theme.of(context).textTheme.headline.fontSize;
    double endHeaderFontSize = Theme.of(context).textTheme.headline.fontSize - 8.0;
    bool showProgressBar = (widget._accSettings?.showConnectProgress == true && !widget._accountModel.initial) ||
        widget._accountModel?.isInitialBootstrap == true;

    return GestureDetector(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Container(width: MediaQuery.of(context).size.width, height: widget._height, decoration: BoxDecoration(color: Theme.of(context).backgroundColor)),
            Positioned(
              width: MediaQuery.of(context).size.width,
              left: CHART_MAX_HORIZONTAL_OFFSET * widget._offsetFactor,
              height: this.widget._height + CHART_MAX_VERTICAL_OFFSET * widget._offsetFactor,
              bottom: -CHART_MAX_VERTICAL_OFFSET * widget._offsetFactor,
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      image: DecorationImage(
                        image: AssetImage("src/images/chart_graph.png"),
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.bottomCenter,
                      ))),
            ),
            showProgressBar ? Positioned(top: 0.0, child: StatusIndicator(context, widget._accountModel)) : SizedBox(),
            Positioned(
                top: 10.0,
                child: Center(
                  child: widget._accountModel != null && !widget._accountModel.initial
                      ? Text("Balance",
                          style: Theme.of(context).textTheme.subtitle.copyWith(color: Theme.of(context).textTheme.subtitle.color.withOpacity(pow(1 - widget._offsetFactor, 8))))
                      : SizedBox(),
                )),
            Positioned(
              top: 30 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
              child: Center(
                child: widget._accountModel != null && !widget._accountModel.initial
                    ? FlatButton(
                        onPressed: () {
                          var nextCurrencyIndex =
                              (Currency.currencies.indexOf(widget._accountModel.currency) + 1) % Currency.currencies.length;
                          widget._onCurrencyChange(Currency.currencies[nextCurrencyIndex]);
                        },
                        child: (_showFiatCurrency && widget._accountModel.fiatCurrency != null)
                            ? Text("${widget._accountModel.formattedFiatBalance}",
                                style: Theme.of(context).textTheme.headline
                                    .copyWith(fontSize: startHeaderSize - (startHeaderSize - endHeaderFontSize) * widget._offsetFactor))
                            : Text(widget._accountModel.currency.format(widget._accountModel.balance, fixedDecimals: false),
                                style: Theme.of(context).textTheme.headline
                                    .copyWith(fontSize: startHeaderSize - (startHeaderSize - endHeaderFontSize) * widget._offsetFactor)))
                    : SizedBox(),
              ),
            )
          ],
        ),
        behavior: HitTestBehavior.translucent,
        onLongPressStart: (_) {
          setState(() {
            _showFiatCurrency = true;
          });
        },
        onLongPressEnd: (_) {
          setState(() {
            _showFiatCurrency = false;
          });
        },
    );
  }
}
