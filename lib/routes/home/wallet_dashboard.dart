import 'dart:math';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:flutter/material.dart';

import '../status_indicator.dart';

class WalletDashboard extends StatefulWidget {
  final AccountModel _accountModel;
  final AccountSettings _accSettings;
  final double _height;
  final double _offsetFactor;
  final Function(Currency currency) _onCurrencyChange;
  final Function(String fiatConversion) _onFiatCurrencyChange;

  WalletDashboard(this._accSettings, this._accountModel, this._height,
      this._offsetFactor, this._onCurrencyChange, this._onFiatCurrencyChange);

  @override
  State<StatefulWidget> createState() {
    return WalletDashboardState();
  }
}

class WalletDashboardState extends State<WalletDashboard> {
  static const CHART_MAX_VERTICAL_OFFSET = 70.0;
  static const CHART_MAX_HORIZONTAL_OFFSET = 30.0;
  static const BALANCE_OFFSET_TRANSITION = 30.0;
  bool _showFiatCurrency = false;

  @override
  Widget build(BuildContext context) {
    double startHeaderSize = Theme.of(context).textTheme.headline5.fontSize;
    double endHeaderFontSize =
        Theme.of(context).textTheme.headline5.fontSize - 8.0;
    bool showProgressBar = (widget._accSettings?.showConnectProgress == true &&
            !widget._accountModel.initial) ||
        widget._accountModel?.isInitialBootstrap == true;

    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: widget._height,
              decoration:
                  BoxDecoration(color: Theme.of(context).backgroundColor)),
          Positioned(
            width: MediaQuery.of(context).size.width,
            left: CHART_MAX_HORIZONTAL_OFFSET * widget._offsetFactor,
            height: this.widget._height +
                CHART_MAX_VERTICAL_OFFSET * widget._offsetFactor,
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
          showProgressBar
              ? Positioned(
                  top: 0.0,
                  child: StatusIndicator(context, widget._accountModel))
              : SizedBox(),
          Positioned(
            top: 30 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
            child: Center(
              child: widget._accountModel != null &&
                      !widget._accountModel.initial
                  ? FlatButton(
                      onPressed: () {
                        var nextCurrencyIndex = (Currency.currencies
                                    .indexOf(widget._accountModel.currency) +
                                1) %
                            Currency.currencies.length;
                        widget._onCurrencyChange(
                            Currency.currencies[nextCurrencyIndex]);
                      },
                      child: (_showFiatCurrency &&
                              widget._accountModel.fiatCurrency != null)
                          ? Text("${widget._accountModel.formattedFiatBalance}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      fontSize: startHeaderSize -
                                          (startHeaderSize - endHeaderFontSize) *
                                              widget._offsetFactor))
                          : Text(widget._accountModel.currency.format(widget._accountModel.balance, removeTrailingZeros: true),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      fontSize: startHeaderSize -
                                          (startHeaderSize - endHeaderFontSize) *
                                              widget._offsetFactor)))
                  : SizedBox(),
            ),
          ),
          Positioned(
              top: 70 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
              child: Center(
                child: widget._accountModel != null &&
                        !widget._accountModel.initial &&
                        isAboveMinAmount(widget._accountModel?.fiatCurrency)
                    ? FlatButton(
                        onPressed: () {
                          var newFiatConversion = nextValidFiatConversion();
                          if (newFiatConversion != null)
                            widget._onFiatCurrencyChange(
                                newFiatConversion.currencyData.shortName);
                        },
                        child: Text(
                            "${widget._accountModel.formattedFiatBalance}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color
                                        .withOpacity(pow(
                                            0.95 - widget._offsetFactor, 8)))))
                    : SizedBox(),
              )),
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

  FiatConversion nextValidFiatConversion() {
    var currentIndex = widget._accountModel.fiatConversionList
        .indexOf(widget._accountModel.fiatCurrency);
    for (var i = 1; i < widget._accountModel.fiatConversionList.length; i++) {
      var nextIndex =
          (i + currentIndex) % widget._accountModel.fiatConversionList.length;
      if (isAboveMinAmount(
          widget._accountModel.fiatConversionList[nextIndex])) {
        return widget._accountModel.fiatConversionList[nextIndex];
      }
    }
    return null;
  }

  bool isAboveMinAmount(FiatConversion fiatConversion) {
    return (fiatConversion.satToFiat(widget._accountModel.balance) >
        (1 /
            (pow(10,
                widget._accountModel.fiatCurrency.currencyData.fractionSize))));
  }
}
