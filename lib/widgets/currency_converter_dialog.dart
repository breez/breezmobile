import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/breez_dropdown.dart';
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
    return CurrencyConverterDialogState();
  }
}

class CurrencyConverterDialogState extends State<CurrencyConverterDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fiatAmountController = TextEditingController();
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
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
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

      fetchRatesAction.future.catchError((err) {
        if (this.mounted) {
          setState(() {
            Navigator.pop(context);
            showFlushbar(context,
                message: "Failed to retrieve BTC exchange rate.");
          });
        }
      });

      _colorAnimation = ColorTween(
        // change to white according to theme
        begin: Theme.of(context).primaryTextTheme.headline4.color,
        end: Theme.of(context).primaryTextTheme.button.color,
      ).animate(_controller)
        ..addListener(() {
          setState(() {});
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

          if (account.preferredFiatConversionList.isEmpty ||
              account.fiatCurrency == null) {
            return Loader();
          }

          double exchangeRate = account.preferredFiatConversionList
              .firstWhere(
                  (fiatConversion) =>
                      fiatConversion.currencyData.symbol ==
                      account.fiatCurrency.currencyData.symbol,
                  orElse: () => null)
              .exchangeRate;
          _updateExchangeLabel(exchangeRate);

          return AlertDialog(
            title: Theme(
              data: Theme.of(context).copyWith(
                brightness: Brightness.light,
                canvasColor: theme.BreezColors.white[500],
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        child: AutoSizeText(
                          "Enter amount in",
                          style: Theme.of(context).dialogTheme.titleTextStyle,
                          maxLines: 1,
                          minFontSize: MinFontSize(context).minFontSize,
                          stepGranularity: 0.1,
                          group: _autoSizeGroup,
                        ),
                        padding: const EdgeInsets.only(right: 0.0, bottom: 2.0),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Theme.of(context).backgroundColor,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: BreezDropdownButton(
                            onChanged: (value) =>
                                _selectFiatCurrency(account, value),
                            value: account.fiatCurrency.currencyData.shortName,
                            iconEnabledColor: Theme.of(context)
                                .dialogTheme
                                .titleTextStyle
                                .color,
                            style: Theme.of(context).dialogTheme.titleTextStyle,
                            items: account.preferredFiatConversionList
                                .map((FiatConversion value) {
                              return DropdownMenuItem<String>(
                                value: value.currencyData.shortName,
                                child: Material(
                                  child: Container(
                                    width: 36,
                                    child: AutoSizeText(
                                      value.currencyData.shortName,
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context)
                                          .dialogTheme
                                          .titleTextStyle,
                                      maxLines: 1,
                                      minFontSize:
                                          MinFontSize(context).minFontSize,
                                      stepGranularity: 0.1,
                                      group: _autoSizeGroup,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                        enabledBorder: UnderlineInputBorder(
                            borderSide: theme.greyBorderSide),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: theme.greyBorderSide),
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: theme.themeId == "BLUE"
                                    ? Colors.red
                                    : Theme.of(context).errorColor)),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: theme.themeId == "BLUE"
                                    ? Colors.red
                                    : Theme.of(context).errorColor)),
                        errorMaxLines: 2,
                        errorStyle: Theme.of(context)
                            .primaryTextTheme
                            .caption
                            .copyWith(
                                color: theme.themeId == "BLUE"
                                    ? Colors.red
                                    : Theme.of(context).errorColor),
                        prefix: Text(
                          account.fiatCurrency.currencyData.symbol,
                          style: Theme.of(context).dialogTheme.contentTextStyle,
                        )),
                    // Do not allow '.' when fractionSize is 0 and only allow fiat currencies fractionSize number of digits after decimal point
                    inputFormatters: [
                      WhitelistingTextInputFormatter(account
                                  .fiatCurrency.currencyData.fractionSize ==
                              0
                          ? RegExp(r'\d+')
                          : RegExp(
                              "^\\d+\\.?\\d{0,${account.fiatCurrency.currencyData.fractionSize ?? 2}}"))
                    ],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    focusNode: _fiatAmountFocusNode,
                    autofocus: true,
                    onEditingComplete: () => _fiatAmountFocusNode.unfocus(),
                    controller: _fiatAmountController,
                    validator: (_) {
                      if (widget.validatorFn != null) {
                        return widget.validatorFn(_convertedSatoshies(account));
                      }
                      return null;
                    },
                    style: Theme.of(context).dialogTheme.contentTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                          "${_fiatAmountController.text.isNotEmpty ? account.currency.format(_convertedSatoshies(account), includeDisplayName: false) : 0} ${account.currency.tickerSymbol}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontSize: 16.0)),
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
    List<Widget> actions = [
      FlatButton(
          onPressed: () => Navigator.pop(context),
          child:
              Text("CANCEL", style: Theme.of(context).primaryTextTheme.button))
    ];

    // Show done button only when the converted amount is bigger than 0
    if (_fiatAmountController.text.isNotEmpty &&
        _convertedSatoshies(account) > 0) {
      actions.add(FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              widget._onConvert(account.currency.format(
                  _convertedSatoshies(account),
                  includeDisplayName: false,
                  userInput: true));
              Navigator.pop(context);
            }
          },
          child:
              Text("DONE", style: Theme.of(context).primaryTextTheme.button)));
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
    return _fiatAmountController.text.isNotEmpty
        ? account.fiatCurrency
            .fiatToSat(double.parse(_fiatAmountController.text ?? 0))
        : 0;
  }

  Widget _buildExchangeRateLabel(FiatConversion fiatConversion) {
    // Empty string widget is returned so that the dialogs height is not changed when the exchange rate is shown
    var currency = CurrencyWrapper.fromFiat(fiatConversion);
    var formattedExchangeRate =
        currency.format(_exchangeRate, removeTrailingZeros: true);
    return _exchangeRate == null
        ? Text("", style: Theme.of(context).primaryTextTheme.subtitle2)
        : Text(
            "1 BTC = $formattedExchangeRate ${fiatConversion.currencyData.shortName}",
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle2
                .copyWith(color: _colorAnimation.value));
  }

  _selectFiatCurrency(AccountModel accountModel, shortName) {
    setState(() {
      int _oldFractionSize =
          accountModel.fiatCurrency.currencyData.fractionSize;
      _userProfileBloc.fiatConversionSink.add(shortName);
      // Remove decimal points to match the selected fiat currencies fractionSize
      if (_oldFractionSize >
          accountModel.fiatCurrency.currencyData.fractionSize) {
        _fiatAmountController.text = double.parse(_fiatAmountController.text)
            .toStringAsFixed(
                accountModel.fiatCurrency.currencyData.fractionSize);
      }
      _updateExchangeLabel(_exchangeRate);
    });
  }
}
