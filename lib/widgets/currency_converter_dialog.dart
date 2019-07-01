import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/fiat_currency.dart';
import 'package:breez/bloc/user_profile/fiat_conversion.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyConverterDialog extends StatefulWidget {
  final Function(String string) _onConvert;

  CurrencyConverterDialog(this._onConvert);

  @override
  CurrencyConverterDialogState createState() {
    return new CurrencyConverterDialogState();
  }
}

class CurrencyConverterDialogState extends State<CurrencyConverterDialog> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;

  AccountBloc _accountBloc;
  UserProfileBloc _userProfileBloc;
  StreamSubscription<AccountModel> _accountSubscription;
  StreamSubscription<Rates> _exchangeRateSubscription;

  Currency _currency = Currency.BTC;
  FiatCurrency _fiatCurrency = FiatCurrency.USD;
  List<FiatConversion>_fiatConversionList = List<FiatConversion>();
  final TextEditingController _fiatAmountController = new TextEditingController();
  final FocusNode _fiatAmountFocusNode = FocusNode();

  String _amount;
  double _exchangeRate;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _amount = _currency.format(Int64(0), includeSymbol: false);
    _fiatAmountController.addListener(_convertCurrency);

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _colorAnimation = new ColorTween(
      begin: Colors.black45,
      end: theme.BreezColors.blue[500],
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    // Loop back to start and stop
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.stop();
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      registerListeners();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void registerListeners() {
    _accountSubscription = _accountBloc.accountStream.listen((acc) {
      setState(() {
        _currency = acc.currency;
        _fiatCurrency = acc.fiatCurrency;
        _fiatConversionList = acc.fiatConversionList;
      });
    });
    _exchangeRateSubscription = _accountBloc.exchangeRateStream.listen((rates) {
      _getExchangeRate();
      _convertCurrency();
    });
  }

  _getExchangeRate(){
    double exchangeRate = _fiatConversionList
        .firstWhere((fiatConversion) => fiatConversion.currencyData.symbol == _fiatCurrency.symbol)
        .exchangeRate;
    if (_exchangeRate != exchangeRate) {
      // Blink exchange rate label when exchange rate changes (also switches between fiat currencies, excluding initialization)
      if (_exchangeRate != null && !_controller.isAnimating) {
        _controller.forward();
      }
      _exchangeRate = exchangeRate;
    }
  }

  @override
  void dispose() {
    _fiatAmountController.dispose();
    _accountSubscription?.cancel();
    _exchangeRateSubscription?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  _convertCurrency() {
    // set _amount to converted value
    var _bitcoinEquivalent = _fiatAmountController.text.isNotEmpty ? double.parse(_fiatAmountController.text) / _exchangeRate : 0.0;
    var _satoshies = (_bitcoinEquivalent * 100000000).toStringAsFixed(0);
    setState(() {
      _amount = _currency.format(Int64.parseInt(_satoshies), includeSymbol: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: new Theme(
          data: Theme.of(context).copyWith(
            brightness: Brightness.light,
            canvasColor: theme.BreezColors.white[500],
          ),
          child: Row(
            children: <Widget>[
              Padding(
                child: Text(
                  "Enter amount in",
                  style: theme.alertTitleStyle,
                ),
                padding: const EdgeInsets.only(right: 0.0, bottom: 2.0),
              ),
              new DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: new DropdownButton(
                    onChanged: (value) => _selectFiatCurrency(value),
                    value: _fiatCurrency.shortName,
                    style: theme.alertTitleStyle,
                    items: FiatCurrency.currencies.map((FiatCurrency value) {
                      return new DropdownMenuItem<String>(
                        value: value.shortName,
                        child: new Text(
                          value.shortName,
                          textAlign: TextAlign.left,
                          style: theme.alertTitleStyle,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          )),
      titlePadding: EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 8.0),
      contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: theme.greyBorderSide),
                  focusedBorder: UnderlineInputBorder(borderSide: theme.greyBorderSide),
                  prefix: Text(
                    _fiatCurrency.symbol,
                    style: theme.alertStyle,
                  )),
              inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'\d+\.?\d*'))],
              keyboardType: TextInputType.number,
              focusNode: _fiatAmountFocusNode,
              controller: _fiatAmountController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter amount in ${_fiatCurrency.shortName}';
                }
                return null;
              },
              style: theme.alertStyle),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              children: <Widget>[
                Text("$_amount ${_currency.symbol}", style: theme.headline.copyWith(fontSize: 16.0)),
                _buildExchangeRateLabel()
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("Cancel", style: theme.buttonStyle)),
        new FlatButton(
            onPressed: () {
              // Remove all whitespace
              widget._onConvert(_amount.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
              Navigator.pop(context);
            },
            child: new Text("Done", style: theme.buttonStyle))
      ],
    );
  }

  Widget _buildExchangeRateLabel() {
    // Empty string widget is returned so that the dialogs height is not changed when the exchange rate is shown
    return _exchangeRate == null
        ? Text("", style: theme.smallTextStyle)
        : Text("1 BTC = $_exchangeRate ${_fiatCurrency.shortName}", style: theme.smallTextStyle.copyWith(color: _colorAnimation.value));
  }

  _selectFiatCurrency(value) {
    setState(() {
      _fiatCurrency = FiatCurrency.fromSymbol(value);
      _userProfileBloc.fiatCurrencySink.add(FiatCurrency.currencies[FiatCurrency.currencies.indexOf(_fiatCurrency)]);
      _getExchangeRate();
      _convertCurrency();
    });
  }
}
