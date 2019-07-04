import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyConverterDialog extends StatefulWidget {
  final Function(String string) _onConvert;
  final String Function(Int64 amount) validatorFn;

  CurrencyConverterDialog(this._onConvert, this.validatorFn);

  @override
  CurrencyConverterDialogState createState() {
    return new CurrencyConverterDialogState();
  }
}

class CurrencyConverterDialogState extends State<CurrencyConverterDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fiatAmountController = new TextEditingController();
  final FocusNode _fiatAmountFocusNode = FocusNode();

  AnimationController _controller;
  Animation<Color> _colorAnimation;

  AccountBloc _accountBloc;
  UserProfileBloc _userProfileBloc;

  Currency _currency = Currency.BTC;
  FiatConversion _fiatCurrency;
  List<FiatConversion> _fiatConversionList = List<FiatConversion>();

  String _amount;
  String _formattedAmount;
  double _exchangeRate;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
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
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _fiatAmountController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountModel>(
        stream: _accountBloc.accountStream,
        builder: (context, snapshot) {
          AccountModel account = snapshot.data;
          if (!snapshot.hasData) {
            return Container();
          }

          _currency = account.currency;
          _fiatCurrency = account.fiatCurrency;
          _fiatConversionList = account.fiatConversionList;

          if (_fiatConversionList == null && _fiatCurrency == null) {
            return Loader();
          }

          double exchangeRate = _fiatConversionList
              .firstWhere((fiatConversion) => fiatConversion.currencyData.symbol == _fiatCurrency.currencyData.symbol, orElse: () => null)
              .exchangeRate;
          _updateExchangeLabel(exchangeRate);

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
                        value: _fiatCurrency.currencyData.shortName,
                        style: theme.alertTitleStyle,
                        items: _fiatConversionList.map((FiatConversion value) {
                          return new DropdownMenuItem<String>(
                            value: value.currencyData.shortName,
                            child: new Text(
                              value.currencyData.shortName,
                              textAlign: TextAlign.left,
                              style: theme.alertTitleStyle,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            titlePadding: EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 8.0),
            contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: theme.greyBorderSide),
                          focusedBorder: UnderlineInputBorder(borderSide: theme.greyBorderSide),
                          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          errorMaxLines: 2,
                          errorStyle: theme.errorStyle.copyWith(color: Colors.red),
                          prefix: Text(
                            _fiatCurrency.currencyData.symbol,
                            style: theme.alertStyle,
                          )),
                      // Do not allow '.' when fractionSize is 0 and only allow fiat currencies fractionSize number of digits after decimal point
                      inputFormatters: [
                        WhitelistingTextInputFormatter(_fiatCurrency.currencyData.fractionSize == 0
                            ? RegExp(r'\d+')
                            : RegExp("^\\d+\\.?\\d{0,${_fiatCurrency.currencyData.fractionSize ?? 2}}"))
                      ],
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      focusNode: _fiatAmountFocusNode,
                      controller: _fiatAmountController,
                      validator: (_) {
                        if (widget.validatorFn != null) {
                          return widget.validatorFn(_currency.parse(_amount));
                        }
                        return null;
                      },
                      style: theme.alertStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Column(
                    children: <Widget>[
                      Text("${_fiatAmountController.text.isNotEmpty ? _formattedAmount : 0} ${_currency.symbol}",
                          style: theme.headline.copyWith(fontSize: 16.0)),
                      _buildExchangeRateLabel()
                    ],
                  ),
                ),
              ],
            ),
            actions: _buildActions(),
          );
        });
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("Cancel", style: theme.buttonStyle))];

    // Show done button only when the converted amount is bigger than 0
    if (_formattedAmount != null && _currency.parse(_amount) > 0) {
      actions.add(new FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              widget._onConvert(_amount);
              Navigator.pop(context);
            }
          },
          child: new Text("Done", style: theme.buttonStyle)));
    }
    return actions;
  }

  _updateExchangeLabel(double exchangeRate) {
    if (_exchangeRate != exchangeRate) {
      // Blink exchange rate label when exchange rate changes (also switches between fiat currencies)
      if (_exchangeRate != null && !_controller.isAnimating) {
        _controller.forward();
      }
      _exchangeRate = exchangeRate;
    }
  }

  _convertCurrency() {
    var _bitcoinEquivalent = _fiatAmountController.text.isNotEmpty ? _fiatCurrency.convertToBTC(double.parse(_fiatAmountController.text ?? 0)) : 0;
    var _satoshies = (_bitcoinEquivalent * 100000000).toStringAsFixed(0);
    setState(() {
      _formattedAmount = _currency.format(Int64.parseInt(_satoshies), includeSymbol: false);
      _amount = _currency.format(Int64.parseInt(_satoshies), includeSymbol: false, userInput: true);
    });
  }

  Widget _buildExchangeRateLabel() {
    // Empty string widget is returned so that the dialogs height is not changed when the exchange rate is shown
    return _exchangeRate == null
        ? Text("", style: theme.smallTextStyle)
        : Text("1 BTC = $_exchangeRate ${_fiatCurrency.currencyData.shortName}",
            style: theme.smallTextStyle.copyWith(color: _colorAnimation.value));
  }

  _selectFiatCurrency(shortName) {
    setState(() {
      int _oldFractionSize = _fiatCurrency.currencyData.fractionSize;
      _fiatCurrency = _fiatConversionList.firstWhere((f) => f.currencyData.shortName == shortName);
      // Remove decimal points to match the selected fiat currencies fractionSize
      if (_oldFractionSize > _fiatCurrency.currencyData.fractionSize) {
        _fiatAmountController.text = double.parse(_fiatAmountController.text).toStringAsFixed(_fiatCurrency.currencyData.fractionSize);
      }
      _userProfileBloc.fiatConversionSink.add(shortName);
      _updateExchangeLabel(_exchangeRate);
      _convertCurrency();
    });
  }
}
