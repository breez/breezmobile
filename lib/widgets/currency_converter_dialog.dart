import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/breez_dropdown.dart';
import 'package:breez/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flushbar.dart';

class CurrencyConverterDialog extends StatefulWidget {
  final Function(String string) _onConvert;
  final String Function(Int64 amount) validatorFn;

  const CurrencyConverterDialog(
    this._onConvert,
    this.validatorFn,
  );

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
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
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
            context.pop();
            showFlushbar(
              context,
              message:
                  context.l10n.currency_converter_dialog_error_exchange_rate,
            );
          });
        }
      });
      TextTheme primaryTextTheme = context.primaryTextTheme;
      _colorAnimation = ColorTween(
        // change to white according to theme
        begin: primaryTextTheme.headline4.color,
        end: primaryTextTheme.button.color,
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
              orElse: () => null,
            )
            .exchangeRate;
        _updateExchangeLabel(exchangeRate);

        return AlertDialog(
          title: Theme(
            data: context.theme.copyWith(
              brightness: Brightness.light,
              canvasColor: theme.BreezColors.white[500],
            ),
            child: _dialogBody(context, account),
          ),
          titlePadding: EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 8.0),
          contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
          content: _dialogContent(context, account),
          actions: _buildActions(context, account),
        );
      },
    );
  }

  Widget _dialogBody(BuildContext context, AccountModel account) {
    ThemeData themeData = context.theme;
    DialogTheme dialogTheme = themeData.dialogTheme;
    double minFontSize = context.minFontSize;

    final items = account.preferredFiatConversionList.map((value) {
      return DropdownMenuItem<String>(
        value: value.currencyData.shortName,
        child: Material(
          child: Container(
            width: 36,
            child: AutoSizeText(
              value.currencyData.shortName,
              textAlign: TextAlign.left,
              style: dialogTheme.titleTextStyle,
              maxLines: 1,
              minFontSize: minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
          ),
        ),
      );
    });

    return Container(
      width: context.mediaQuerySize.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              child: AutoSizeText(
                context.l10n.currency_converter_dialog_title,
                style: dialogTheme.titleTextStyle,
                maxLines: 1,
                minFontSize: minFontSize,
                stepGranularity: 0.1,
                group: _autoSizeGroup,
              ),
              padding: const EdgeInsets.only(right: 0.0, bottom: 2.0),
            ),
          ),
          Theme(
            data: themeData.copyWith(
              canvasColor: themeData.backgroundColor,
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: BreezDropdownButton(
                  onChanged: (value) => _selectFiatCurrency(account, value),
                  value: account.fiatCurrency.currencyData.shortName,
                  iconEnabledColor: dialogTheme.titleTextStyle.color,
                  style: dialogTheme.titleTextStyle,
                  items: items.toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogContent(BuildContext context, AccountModel account) {
    ThemeData themeData = context.theme;
    DialogTheme dialogTheme = themeData.dialogTheme;
    Color errorColor =
        theme.themeId == "BLUE" ? Colors.red : themeData.errorColor;
    TextStyle errorStyle =
        themeData.primaryTextTheme.caption.copyWith(color: errorColor);

    final fractionSize = account.fiatCurrency.currencyData.fractionSize;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: theme.greyBorderSide,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: theme.greyBorderSide,
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: errorColor),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: errorColor),
              ),
              errorMaxLines: 2,
              errorStyle: errorStyle,
              prefix: Text(
                account.fiatCurrency.currencyData.symbol,
                style: dialogTheme.contentTextStyle,
              ),
            ),
            // Do not allow '.' when fractionSize is 0 and only allow fiat currencies fractionSize number of digits after decimal point
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                fractionSize == 0
                    ? RegExp(r'\d+')
                    : RegExp("^\\d+\\.?\\d{0,${fractionSize ?? 2}}"),
              ),
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
            style: dialogTheme.contentTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            children: [
              Text(
                _contentMessage(context, account),
                style: themeData.textTheme.headline5.copyWith(
                  fontSize: 16.0,
                ),
              ),
              _buildExchangeRateLabel(context, account.fiatCurrency),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context, AccountModel account) {
    var l10n = context.l10n;
    TextStyle btnTextStyle = context.primaryTextTheme.button;

    List<Widget> actions = [
      TextButton(
        onPressed: () => context.pop(),
        child: Text(
          l10n.currency_converter_dialog_action_cancel,
          style: btnTextStyle,
        ),
      ),
    ];

    // Show done button only when the converted amount is bigger than 0
    if (_fiatAmountController.text.isNotEmpty &&
        _convertedSatoshies(account) > 0) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              widget._onConvert(
                account.currency.format(
                  _convertedSatoshies(account),
                  includeDisplayName: false,
                  userInput: true,
                ),
              );
              context.pop();
            }
          },
          child: Text(
            l10n.currency_converter_dialog_action_done,
            style: btnTextStyle,
          ),
        ),
      );
    }
    return actions;
  }

  String _contentMessage(BuildContext context, AccountModel account) {
    final amount = _fiatAmountController.text.isNotEmpty
        ? account.currency.format(
            _convertedSatoshies(account),
            includeDisplayName: false,
          )
        : 0;
    final symbol = account.currency.tickerSymbol;
    return "$amount $symbol";
  }

  void _updateExchangeLabel(double exchangeRate) {
    if (_exchangeRate != exchangeRate) {
      // Blink exchange rate label when exchange rate changes (also switches between fiat currencies)
      if (_exchangeRate != null && !_controller.isAnimating) {
        _controller.forward();
      }
      _exchangeRate = exchangeRate;
    }
  }

  Int64 _convertedSatoshies(AccountModel account) {
    return _fiatAmountController.text.isNotEmpty
        ? account.fiatCurrency.fiatToSat(
            double.parse(_fiatAmountController.text ?? 0),
          )
        : Int64(0);
  }

  Widget _buildExchangeRateLabel(
    BuildContext context,
    FiatConversion fiatConversion,
  ) {
    TextStyle subtitle2 = context.primaryTextTheme.subtitle2;

    // Empty string widget is returned so that the dialogs height is not changed when the exchange rate is shown
    final currency = CurrencyWrapper.fromFiat(fiatConversion);
    return _exchangeRate == null
        ? Text("", style: subtitle2)
        : Text(
            context.l10n.currency_converter_dialog_rate(
              currency.format(_exchangeRate, removeTrailingZeros: true),
              fiatConversion.currencyData.shortName,
            ),
            style: subtitle2.copyWith(color: _colorAnimation.value),
          );
  }

  void _selectFiatCurrency(AccountModel accountModel, shortName) {
    setState(() {
      int oldFractionSize = accountModel.fiatCurrency.currencyData.fractionSize;
      _userProfileBloc.fiatConversionSink.add(shortName);
      int newFractionSize = accountModel.fiatCurrency.currencyData.fractionSize;
      // Remove decimal points to match the selected fiat currencies fractionSize
      if (oldFractionSize > newFractionSize) {
        _fiatAmountController.text = double.parse(
          _fiatAmountController.text,
        ).toStringAsFixed(newFractionSize);
      }
      _updateExchangeLabel(_exchangeRate);
    });
  }
}
