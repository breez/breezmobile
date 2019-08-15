import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flushbar.dart';

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

  double _exchangeRate;  

  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _fiatAmountController.addListener(() => setState(() {}));
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
      FetchRates fetchRatesAction = FetchRates();      
      _accountBloc.userActionsSink.add(fetchRatesAction);

      fetchRatesAction.future.catchError((err){
        if (this.mounted) {
          setState((){          
            Navigator.pop(context);
            showFlushbar(context, message: "Failed to retrieve BTC exchange rate.");
          });
        }        
      });
      
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

          if (account.fiatConversionList.isEmpty || account.fiatCurrency == null) {
            return Loader();
          }

          double exchangeRate = account.fiatConversionList
              .firstWhere((fiatConversion) => fiatConversion.currencyData.symbol == account.fiatCurrency.currencyData.symbol,
                  orElse: () => null)
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      child: AutoSizeText(
                        "Enter amount in",
                        style: theme.alertTitleStyle,
                        maxLines: 1,
                        group: _autoSizeGroup,
                      ),
                      padding: const EdgeInsets.only(right: 0.0, bottom: 2.0),
                    ),
                  ),
                  new DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: new DropdownButton(
                        onChanged: (value) => _selectFiatCurrency(account, value),
                        value: account.fiatCurrency.currencyData.shortName,
                        style: theme.alertTitleStyle,
                        items: account.fiatConversionList.map((FiatConversion value) {
                          return new DropdownMenuItem<String>(
                            value: value.currencyData.shortName,
                            child: SizedBox(
                              width: 32.0,
                              child: AutoSizeText(
                                value.currencyData.shortName,
                                textAlign: TextAlign.left,
                                style: theme.alertTitleStyle,
                                maxLines: 1,
                                group: _autoSizeGroup,
                              ),
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
                            account.fiatCurrency.currencyData.symbol,
                            style: theme.alertStyle,
                          )),
                      // Do not allow '.' when fractionSize is 0 and only allow fiat currencies fractionSize number of digits after decimal point
                      inputFormatters: [
                        WhitelistingTextInputFormatter(account.fiatCurrency.currencyData.fractionSize == 0
                            ? RegExp(r'\d+')
                            : RegExp("^\\d+\\.?\\d{0,${account.fiatCurrency.currencyData.fractionSize ?? 2}}"))
                      ],
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      focusNode: _fiatAmountFocusNode,
                      autofocus: true,
                      controller: _fiatAmountController,
                      validator: (_) {
                        if (widget.validatorFn != null) {
                          return widget.validatorFn(_convertedSatoshies(account));
                        }
                        return null;
                      },
                      style: theme.alertStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                          "${_fiatAmountController.text.isNotEmpty ? account.currency.format(_convertedSatoshies(account), includeSymbol: false) : 0} ${account.currency.symbol}",
                          style: theme.headline.copyWith(fontSize: 16.0)),
                      _buildExchangeRateLabel(account.fiatCurrency)
                    ],
                  ),
                ),
              ],
            ),
            actions: _buildActions(account),
          );
        });
  }

  List<Widget> _buildActions(AccountModel account) {
    List<Widget> actions = [new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("Cancel", style: theme.buttonStyle))];

    // Show done button only when the converted amount is bigger than 0
    if (_fiatAmountController.text.isNotEmpty && _convertedSatoshies(account) > 0) {
      actions.add(new FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              widget._onConvert(account.currency.format(_convertedSatoshies(account), includeSymbol: false, userInput: true));
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

  _convertedSatoshies(AccountModel account) {
    return _fiatAmountController.text.isNotEmpty ? account.fiatCurrency.fiatToSat(double.parse(_fiatAmountController.text ?? 0)) : 0;
  }

  Widget _buildExchangeRateLabel(FiatConversion fiatConversion) {
    // Empty string widget is returned so that the dialogs height is not changed when the exchange rate is shown
    return _exchangeRate == null
        ? Text("", style: theme.smallTextStyle)
        : Text("1 BTC = $_exchangeRate ${fiatConversion.currencyData.shortName}",
            style: theme.smallTextStyle.copyWith(color: _colorAnimation.value));
  }

  _selectFiatCurrency(AccountModel accountModel, shortName) {
    setState(() {
      int _oldFractionSize = accountModel.fiatCurrency.currencyData.fractionSize;
      _userProfileBloc.fiatConversionSink.add(shortName);
      // Remove decimal points to match the selected fiat currencies fractionSize
      if (_oldFractionSize > accountModel.fiatCurrency.currencyData.fractionSize) {
        _fiatAmountController.text =
            double.parse(_fiatAmountController.text).toStringAsFixed(accountModel.fiatCurrency.currencyData.fractionSize);
      }
      _updateExchangeLabel(_exchangeRate);
    });
  }
}
