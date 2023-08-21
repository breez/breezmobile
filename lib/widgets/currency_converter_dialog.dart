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
import 'package:breez/widgets/currency_amount_field_formatter.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

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

  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _fiatAmountController.addListener(() => setState(() {}));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
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
      final themeData = Theme.of(context);
      final texts = context.texts();

      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      FetchRates fetchRatesAction = FetchRates();
      _accountBloc.userActionsSink.add(fetchRatesAction);

      _accountBloc.accountStream.first.then((account) {
        _fiatAmountController.text = account.fiatCurrency.currencyData.symbol;
      });

      fetchRatesAction.future.catchError((err) {
        if (mounted) {
          setState(() {
            Navigator.pop(context);
            showFlushbar(
              context,
              message: texts.currency_converter_dialog_error_exchange_rate,
            );
          });
        }
      });

      _colorAnimation = ColorTween(
        // change to white according to theme
        begin: themeData.primaryTextTheme.headlineMedium.color,
        end: themeData.primaryTextTheme.labelLarge.color,
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
    final themeData = Theme.of(context);

    return StreamBuilder<AccountModel>(
      stream: _accountBloc.accountStream,
      builder: (context, snapshot) {
        AccountModel account = snapshot.data;
        if (!snapshot.hasData) {
          return Container();
        }

        if (account.preferredFiatConversionList.isEmpty ||
            account.fiatCurrency == null) {
          return const Loader();
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
            data: themeData.copyWith(
              brightness: Brightness.light,
              canvasColor: theme.BreezColors.white[500],
            ),
            child: _dialogBody(account),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 8.0),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
          content: _dialogContent(account),
          actions: _buildActions(account),
        );
      },
    );
  }

  Widget _dialogBody(AccountModel account) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    final items = account.preferredFiatConversionList.map((value) {
      return DropdownMenuItem<String>(
        value: value.currencyData.shortName,
        child: SizedBox(
          width: 36,
          child: AutoSizeText(
            value.currencyData.shortName,
            textAlign: TextAlign.left,
            style: themeData.dialogTheme.titleTextStyle,
            maxLines: 1,
            minFontSize: MinFontSize(context).minFontSize,
            stepGranularity: 0.1,
            group: _autoSizeGroup,
          ),
        ),
      );
    });

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 0.0, bottom: 2.0),
              child: AutoSizeText(
                texts.currency_converter_dialog_title,
                style: themeData.dialogTheme.titleTextStyle,
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
                group: _autoSizeGroup,
              ),
            ),
          ),
          Theme(
            data: themeData.copyWith(
              canvasColor: themeData.colorScheme.background,
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  onChanged: (value) => _selectFiatCurrency(value),
                  value: account.fiatCurrency.currencyData.shortName,
                  iconEnabledColor: themeData.dialogTheme.titleTextStyle.color,
                  style: themeData.dialogTheme.titleTextStyle,
                  items: items.toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogContent(AccountModel account) {
    final themeData = Theme.of(context);

    final isBlue = theme.themeId == "BLUE";

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
                borderSide: BorderSide(
                  color: isBlue ? Colors.red : themeData.colorScheme.error,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isBlue ? Colors.red : themeData.colorScheme.error,
                ),
              ),
              errorMaxLines: 2,
              errorStyle: themeData.primaryTextTheme.bodySmall.copyWith(
                color: isBlue ? Colors.red : themeData.colorScheme.error,
              ),
            ),
            // Do not allow '.' when fractionSize is 0 and only allow fiat currencies fractionSize number of digits after decimal point
            inputFormatters: [
              CurrencyAmountFieldFormatter(account.fiatCurrency),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            style: themeData.dialogTheme.contentTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            children: [
              Text(
                _contentMessage(account),
                style: themeData.textTheme.headlineSmall.copyWith(
                  fontSize: 16.0,
                ),
              ),
              _buildExchangeRateLabel(account.fiatCurrency),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(AccountModel account) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.currency_converter_dialog_action_cancel,
          style: themeData.primaryTextTheme.labelLarge,
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
              Navigator.pop(context);
            }
          },
          child: Text(
            texts.currency_converter_dialog_action_done,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      );
    }
    return actions;
  }

  String _contentMessage(AccountModel account) {
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
    final texts = _fiatAmountController.text.replaceAll(RegExp("[^0-9.]"), "");
    return texts.isNotEmpty
        ? account.fiatCurrency.fiatToSat(
            double.parse(texts ?? 0),
          )
        : Int64(0);
  }

  Widget _buildExchangeRateLabel(
    FiatConversion fiatConversion,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    // Empty string widget is returned so that the dialogs height is not changed when the exchange rate is shown
    final currency = CurrencyWrapper.fromFiat(fiatConversion);
    return _exchangeRate == null
        ? Text(
            "",
            style: themeData.primaryTextTheme.titleSmall,
          )
        : Text(
            texts.currency_converter_dialog_rate(
              currency.format(
                _exchangeRate,
                removeTrailingZeros: true,
              ),
              fiatConversion.currencyData.shortName,
            ),
            style: themeData.primaryTextTheme.titleSmall.copyWith(
              color: _colorAnimation.value,
            ),
          );
  }

  void _selectFiatCurrency(String shortName) {
    _accountBloc.accountStream.skip(1).first.then((accountModel) {
      final currencyData = accountModel.fiatCurrency.currencyData;
      final symbol = currencyData.symbol;
      final rightSide = currencyData.rightSideSymbol;
      final raw = _fiatAmountController.text.replaceAll(RegExp("[^0-9.]"), "");
      var formatted = rightSide ? "$raw $symbol" : "$symbol $raw";
      if (raw.contains(".")) {
        final split = raw.split(".");
        final size = currencyData.fractionSize;
        if (split.last.length > size) {
          formatted = "${split.first}.${split.last.substring(0, size)}";
          formatted = rightSide ? "$formatted $symbol" : "$symbol $formatted";
        }
      }
      _fiatAmountController.text = formatted;
      _updateExchangeLabel(_exchangeRate);
    });
    _userProfileBloc.fiatConversionSink.add(shortName);
  }
}
