import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/routes/user/home/status_indicator.dart';
import 'dart:math';

class WalletDashboard extends StatelessWidget {
  static const CHART_MAX_VERTICAL_OFFSET = 70.0;
  static const CHART_MAX_HORIZONTAL_OFFSET = 30.0;
  static const BALANCE_OFFSET_TRANSITION = 30.0;
  final AccountModel _accountModel;
  final AccountSettings _accSettings;
  final double _height;
  final double _offsetFactor;
  final Function(Currency currency) _onCurrencyChange;  

  WalletDashboard(this._accSettings, this._accountModel, this._height, this._offsetFactor, this._onCurrencyChange);

  @override
  Widget build(BuildContext context) {
    double startHeaderSize = theme.headline.fontSize;
    double endHeaderFontSize = theme.headline.fontSize - 8.0;

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            height: _height,
            decoration: BoxDecoration(color: Colors.white)
        ),
        Positioned(
            width: MediaQuery.of(context).size.width ,
            left: CHART_MAX_HORIZONTAL_OFFSET * _offsetFactor,
            height: this._height + CHART_MAX_VERTICAL_OFFSET * _offsetFactor,
            bottom: -CHART_MAX_VERTICAL_OFFSET * _offsetFactor,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("src/images/chart_graph.png"),
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.bottomCenter,
                    )))),
        _accSettings?.showConnectProgress == true || _accountModel?.channelRequested == false ? 
          Positioned(top: 0.0, child: StatusIndicator(_accountModel)) : SizedBox(), 
        Positioned(
            top: 10.0,
            child: Center(
              child: _accountModel != null
                  ? Text("Balance", style: theme.subtitle.copyWith(color: theme.subtitle.color.withOpacity( pow(1 - _offsetFactor, 8))))
                  : SizedBox(),
            )),
        Positioned(
            top: 30 - BALANCE_OFFSET_TRANSITION * _offsetFactor,
            child: Center(
              child: _accountModel != null
                  ? FlatButton(
                  onPressed: () {
                    var nextCurrencyIndex = (Currency.currencies.indexOf(_accountModel.currency) + 1) % Currency.currencies.length;
                    _onCurrencyChange(Currency.currencies[nextCurrencyIndex]);
                  },
                  child: Text(_accountModel.currency.format(_accountModel.balance, fixedDecimals: false),
                      style: theme.headline.copyWith(fontSize: startHeaderSize - (startHeaderSize - endHeaderFontSize) * _offsetFactor)))
                  : SizedBox(),
            ))
      ],
    );
  }
}
