import 'dart:math';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class WalletDashboard extends StatefulWidget {
  final AccountModel _accountModel;
  final BreezUserModel _userModel;
  final double _height;
  final double _offsetFactor;
  final Function(Currency currency) _onCurrencyChange;
  final Function(String fiatConversion) _onFiatCurrencyChange;

  WalletDashboard(this._userModel, this._accountModel, this._height,
      this._offsetFactor, this._onCurrencyChange, this._onFiatCurrencyChange);

  @override
  State<StatefulWidget> createState() {
    return WalletDashboardState();
  }
}

class WalletDashboardState extends State<WalletDashboard> {
  static const BALANCE_OFFSET_TRANSITION = 35.0;
  bool _showFiatCurrency = false;

  @override
  Widget build(BuildContext context) {
    double startHeaderSize =
        Theme.of(context).accentTextTheme.headline4.fontSize;
    double endHeaderFontSize =
        Theme.of(context).accentTextTheme.headline4.fontSize - 8.0;

    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: widget._height,
              decoration: BoxDecoration(
                color: theme.customData[theme.themeId].dashboardBgColor,
              )),
          Positioned(
            top: 35 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
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
                      highlightColor:
                          theme.customData[theme.themeId].paymentListBgColor,
                      child: (widget._offsetFactor > 0.8 &&
                              _showFiatCurrency &&
                              widget._accountModel.fiatCurrency != null)
                          ? Text("${widget._accountModel.formattedFiatBalance}",
                              style: Theme.of(context)
                                  .accentTextTheme
                                  .headline4
                                  .copyWith(
                                      fontSize: startHeaderSize -
                                          (startHeaderSize -
                                                  endHeaderFontSize) *
                                              widget._offsetFactor))
                          : RichText(
                              text: TextSpan(
                                  style: Theme.of(context)
                                      .accentTextTheme
                                      .headline4
                                      .copyWith(
                                          fontSize: startHeaderSize -
                                              (startHeaderSize -
                                                      endHeaderFontSize) *
                                                  widget._offsetFactor),
                                  text: widget._accountModel.currency.format(
                                      widget._accountModel.balance,
                                      removeTrailingZeros: true,
                                      addCurrencySuffix: false),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "  " +
                                          widget._accountModel.currency
                                              .displayName,
                                      style: Theme.of(context)
                                          .accentTextTheme
                                          .headline4
                                          .copyWith(
                                              fontSize: startHeaderSize * 0.6 -
                                                  (startHeaderSize * 0.6 -
                                                          endHeaderFontSize) *
                                                      widget._offsetFactor),
                                    ),
                                  ]),
                            ))
                  : SizedBox(),
            ),
          ),
          Positioned(
            top: 85 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
            child: Center(
              child: widget._accountModel != null &&
                      !widget._accountModel.initial &&
                      widget._accountModel.fiatConversionList.isNotEmpty &&
                      isAboveMinAmount(widget._accountModel?.fiatCurrency)
                  ? FlatButton(
                      onPressed: () {
                        var newFiatConversion = nextValidFiatConversion();
                        if (newFiatConversion != null)
                          widget._onFiatCurrencyChange(
                              newFiatConversion.currencyData.shortName);
                      },
                      highlightColor:
                          theme.customData[theme.themeId].paymentListBgColor,
                      child: Text(
                          "${widget._accountModel.formattedFiatBalance}",
                          style: Theme.of(context)
                              .accentTextTheme
                              .subtitle1
                              .copyWith(
                                  color: Theme.of(context)
                                      .accentTextTheme
                                      .subtitle1
                                      .color
                                      .withOpacity(pow(
                                          1.00 - widget._offsetFactor, 2)))),
                    )
                  : SizedBox(),
            ),
          ),
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
    var currentIndex = widget._accountModel.preferredFiatConversionList
        .indexOf(widget._accountModel.fiatCurrency);
    for (var i = 1;
        i < widget._accountModel.preferredFiatConversionList.length;
        i++) {
      var nextIndex = (i + currentIndex) %
          widget._accountModel.preferredFiatConversionList.length;
      if (isAboveMinAmount(
          widget._accountModel.preferredFiatConversionList[nextIndex])) {
        return widget._accountModel.preferredFiatConversionList[nextIndex];
      }
    }
    return null;
  }

  bool isAboveMinAmount(FiatConversion fiatConversion) {
    double fiatValue = fiatConversion.satToFiat(widget._accountModel.balance);
    int fractionSize = fiatConversion.currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    return fiatValue > minimumAmount;
  }
}
