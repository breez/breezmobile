import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/btc_address.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class WithdrawFundsPage extends StatefulWidget {
  final Future Function(Int64 amount, String destAddress, bool isMax) onNext;
  final String initialAddress;
  final String initialAmount;
  final bool initialIsMax;
  final WithdrawFundsPolicy policy;
  final String title;
  final String optionalMessage;

  const WithdrawFundsPage({
    this.onNext,
    this.initialAddress,
    this.initialAmount,
    this.initialIsMax,
    this.policy,
    this.title,
    this.optionalMessage,
  });

  @override
  State<StatefulWidget> createState() {
    return WithdrawFundsPageState();
  }
}

class WithdrawFundsPageState extends State<WithdrawFundsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  String _scannerErrorMessage = "";
  bool _isMax = false;
  BreezBridge _breezLib;
  String _addressValidated;
  int selectedFeeIndex = 1;
  bool fetching = false;

  @override
  void initState() {
    super.initState();
    _breezLib = ServiceInjector().breezBridge;
    if (widget.initialAddress != null) {
      _addressController.text = widget.initialAddress;
    }
    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount;
    }
    if (widget.initialIsMax != null) {
      _isMax = widget.initialIsMax;
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return Scaffold(
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(widget.title),
      ),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return StaticLoader();

          final acc = snapshot.data;
          Widget optionalMessage = widget.optionalMessage == null
              ? const SizedBox()
              : WarningBox(
                  boxPadding: const EdgeInsets.only(bottom: 24),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Text(
                    widget.optionalMessage,
                    style: themeData.textTheme.titleLarge,
                  ),
                );
          List<Widget> amountWidget = [];
          if (widget.policy.minValue != widget.policy.maxValue) {
            amountWidget.add(AmountFormField(
              readOnly: fetching || _isMax,
              context: context,
              texts: texts,
              accountModel: acc,
              focusNode: _amountFocusNode,
              controller: _amountController,
              validatorFn: (amount) {
                String err = acc.validateOutgoingPayment(amount);
                if (err == null) {
                  if (amount < widget.policy.minValue) {
                    err = texts.withdraw_funds_error_min_value(
                      acc.currency.format(widget.policy.minValue),
                    );
                  }
                  if (amount > widget.policy.maxValue) {
                    err = texts.withdraw_funds_error_max_value(
                      acc.currency.format(widget.policy.maxValue + 1),
                    );
                  }
                }
                return err;
              },
              style: theme.FieldTextStyle.textStyle,
            ));
            amountWidget.add(ListTile(
              contentPadding: EdgeInsets.zero,
              title: AutoSizeText(
                texts.withdraw_funds_use_all_funds,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
              trailing: Switch(
                value: _isMax,
                activeColor: Colors.white,
                onChanged: (bool value) async {
                  setState(() {
                    _isMax = value;
                    if (_isMax) {
                      _amountController.text = acc.currency.format(
                        widget.policy.available,
                        includeDisplayName: false,
                        userInput: true,
                      );
                    } else {
                      _amountController.text = "";
                    }
                  });
                },
              ),
            ));
          }
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    optionalMessage,
                    TextFormField(
                      readOnly: fetching,
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: texts.withdraw_funds_btc_address,
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.only(top: 21.0),
                          alignment: Alignment.bottomRight,
                          icon: Image(
                            image: const AssetImage("src/icon/qr_scan.png"),
                            color: theme.BreezColors.white[500],
                            fit: BoxFit.contain,
                            width: 24.0,
                            height: 24.0,
                          ),
                          tooltip: texts.withdraw_funds_scan_barcode,
                          onPressed: () => _scanBarcode(context, acc),
                        ),
                      ),
                      style: theme.FieldTextStyle.textStyle,
                      validator: (value) {
                        if (_addressValidated == null) {
                          return texts.withdraw_funds_error_invalid_address;
                        }
                        return null;
                      },
                    ),
                    _scannerErrorMessage.isNotEmpty
                        ? Text(
                            _scannerErrorMessage,
                            style: theme.validatorStyle,
                          )
                        : const SizedBox(),
                    ...amountWidget,
                    Container(
                      padding: const EdgeInsets.only(top: 36.0),
                      child: _buildAvailableBTC(texts, acc),
                    ),
                    const SizedBox(height: 40.0),
                    !fetching
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Loader(
                                strokeWidth: 2.0,
                                color: themeData.colorScheme.onSurface
                                    .withOpacity(0.5),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _NextButton(
        accountBloc: accountBloc,
        fetching: fetching,
        onPressed: (acc) => _onNext(acc, reverseSwapBloc, _isMax),
      ),
    );
  }

  Widget _buildAvailableBTC(BreezTranslations texts, AccountModel acc) {
    return Row(
      children: [
        Text(
          texts.withdraw_funds_balance,
          style: theme.textStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            acc.currency.format(widget.policy.balance),
            style: theme.textStyle,
          ),
        )
      ],
    );
  }

  void _onNext(
    AccountModel acc,
    ReverseSwapBloc reverseSwapBloc,
    bool isNext,
  ) {
    if (fetching) {
      return;
    }
    _asyncValidate().then((validated) {
      if (validated) {
        _formKey.currentState.save();
        setState(() {
          fetching = true;
        });
        FocusScope.of(context).requestFocus(FocusNode());
        return widget.onNext(
          acc.currency.parse(_amountController.text),
          _addressValidated,
          _isMax,
        );
      }
    }).catchError((error) {
      promptError(
        context,
        null,
        Text(
          error.toString(),
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
      );
    }).whenComplete(() {
      setState(() {
        fetching = false;
      });
    });
  }

  Future _scanBarcode(BuildContext context, AccountModel account) async {
    final texts = context.texts();
    FocusScope.of(context).requestFocus(FocusNode());
    String barcode = await Navigator.pushNamed<String>(context, "/qr_scan");
    if (barcode.isEmpty) {
      showFlushbar(
        context,
        message: texts.withdraw_funds_error_qr_code_not_detected,
      );
      return;
    }
    BTCAddressInfo btcInvoice = parseBTCAddress(barcode);
    String amount;
    if (btcInvoice.satAmount != null) {
      amount = account.currency.format(
        btcInvoice.satAmount,
        userInput: true,
        includeDisplayName: false,
        removeTrailingZeros: true,
      );
    }
    setState(() {
      _addressController.text = btcInvoice.address;
      _amountController.text = amount ?? _amountController.text;
      _scannerErrorMessage = "";
    });
  }

  Future<bool> _asyncValidate() {
    return _breezLib.validateAddress(_addressController.text).then((data) {
      _addressValidated = data;
      var v = _formKey.currentState.validate();
      return v;
    }).catchError((err) {
      _addressValidated = null;
      return _formKey.currentState.validate();
    });
  }
}

class WithdrawFundsPolicy {
  final Int64 minValue;
  final Int64 maxValue;
  final Int64 balance;
  final Int64 available;

  const WithdrawFundsPolicy(
    this.minValue,
    this.maxValue,
    this.balance,
    this.available,
  );
}

class _NextButton extends StatelessWidget {
  final AccountBloc accountBloc;
  final bool fetching;
  final Function(AccountModel acc) onPressed;

  const _NextButton({
    Key key,
    this.accountBloc,
    this.fetching,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, snapshot) {
        final acc = snapshot.data;
        return Padding(
          padding: const EdgeInsets.only(bottom: 36.0, top: 8.0),
          child: fetching
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 48.0,
                      width: 168.0,
                      child: SubmitButton(
                        texts.withdraw_funds_action_next,
                        acc == null ? null : () => onPressed(acc),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
