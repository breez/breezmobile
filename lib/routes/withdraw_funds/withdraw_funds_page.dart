import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/logger.dart';
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
import 'package:breez/widgets/static_loader.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class WithdrawFundsPage extends StatefulWidget {
  final Future Function(Int64 amount, String destAddress, bool isMax) onNext;
  final String initialAddress;
  final String initialAmount;
  final bool initialIsMax;
  final WithdrawFundsPolicy policy;
  final String title;
  final String optionalMessage;

  const WithdrawFundsPage(
      {this.onNext,
      this.initialAddress,
      this.initialAmount,
      this.initialIsMax,
      this.policy,
      this.title,
      this.optionalMessage});

  @override
  State<StatefulWidget> createState() {
    return WithdrawFundsPageState();
  }
}

class WithdrawFundsPageState extends State<WithdrawFundsPage> {
  final _formKey = GlobalKey<FormState>();
  String _scannerErrorMessage = "";
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isMax = false;

  BreezBridge _breezLib;
  String _addressValidated;
  final FocusNode _amountFocusNode = FocusNode();
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
    ReverseSwapBloc reverseSwapBloc =
        AppBlocsProvider.of<ReverseSwapBloc>(context);
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    Widget buttonChild = Text(
      "NEXT",
      style: Theme.of(context).textTheme.button,
    );
    if (fetching) {
      buttonChild = Container(
        width: 18.0,
        height: 18.0,
        child: Loader(strokeWidth: 2.0),
      );
    }
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(onPressed: () {
            Navigator.of(context).pop();
          }),
          title: Text(widget.title,
              style: Theme.of(context).appBarTheme.textTheme.headline6),
          elevation: 0.0),
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }
          AccountModel acc = snapshot.data;
          Widget optionalMessage = widget.optionalMessage == null
              ? SizedBox()
              : WarningBox(
                  boxPadding: EdgeInsets.only(bottom: 24),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(widget.optionalMessage,
                      style: Theme.of(context).textTheme.headline6),
                );
          List<Widget> amountWidget = [];
          if (widget.policy.minValue != widget.policy.maxValue) {
            var amountFormField = AmountFormField(
                readOnly: fetching || _isMax,
                context: context,
                accountModel: acc,
                focusNode: _amountFocusNode,
                controller: _amountController,
                validatorFn: (amount) {
                  String err = acc.validateOutgoingPayment(amount);
                  if (err == null) {
                    if (amount < widget.policy.minValue) {
                      err =
                          "Must be at least ${acc.currency.format(widget.policy.minValue)}";
                    }
                    if (amount > widget.policy.maxValue) {
                      err =
                          "Must be less than ${acc.currency.format(widget.policy.maxValue + 1)}";
                    }
                  }
                  return err;
                },
                style: theme.FieldTextStyle.textStyle);
            amountWidget.add(amountFormField);
            amountWidget.add(ListTile(
              contentPadding: EdgeInsets.zero,
              title: Container(
                child: AutoSizeText(
                  "Use All Funds",
                  style: TextStyle(color: Colors.white),
                  maxLines: 1,
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                ),
              ),
              trailing: Switch(
                value: _isMax,
                activeColor: Colors.white,
                onChanged: (bool value) async {
                  setState(() {
                    _isMax = value;
                    if (_isMax) {
                      _amountController.text =
                          widget.policy.available.toString();
                    } else {
                      _amountController.text = "";
                    }
                  });
                },
              ),
            ));
          }
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  optionalMessage,
                  TextFormField(
                    readOnly: fetching,
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "BTC Address",
                      suffixIcon: IconButton(
                        padding: EdgeInsets.only(top: 21.0),
                        alignment: Alignment.bottomRight,
                        icon: Image(
                          image: AssetImage("src/icon/qr_scan.png"),
                          color: theme.BreezColors.white[500],
                          fit: BoxFit.contain,
                          width: 24.0,
                          height: 24.0,
                        ),
                        tooltip: 'Scan Barcode',
                        onPressed: () => _scanBarcode(acc),
                      ),
                    ),
                    style: theme.FieldTextStyle.textStyle,
                    validator: (value) {
                      if (_addressValidated == null) {
                        return "Please enter a valid BTC Address";
                      }
                      return null;
                    },
                  ),
                  _scannerErrorMessage.length > 0
                      ? Text(
                          _scannerErrorMessage,
                          style: theme.validatorStyle,
                        )
                      : SizedBox(),
                  ...amountWidget,
                  Container(
                    padding: EdgeInsets.only(top: 36.0),
                    child: _buildAvailableBTC(acc),
                  ),
                  SizedBox(height: 40.0),
                  !fetching
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                              Container(
                                width: 18.0,
                                height: 18.0,
                                child: Loader(
                                    strokeWidth: 2.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6)),
                              )
                            ])
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: fetching
          ? null
          : StreamBuilder<AccountModel>(
              stream: accountBloc.accountStream,
              builder: (context, snapshot) {
                AccountModel acc = snapshot.data;
                return Padding(
                    padding: EdgeInsets.only(bottom: 40.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 48.0,
                            width: 168.0,
                            child: RaisedButton(
                              child: buttonChild,
                              color: Theme.of(context).buttonColor,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(42.0)),
                              onPressed: acc == null
                                  ? null
                                  : () {
                                      log.info("-- yas -- _isMax --");
                                      log.info(_isMax);
                                      _onNext(acc, reverseSwapBloc, _isMax);
                                    },
                            ),
                          ),
                        ]));
              }),
    );
  }

  Widget _buildAvailableBTC(AccountModel acc) {
    return Row(
      children: <Widget>[
        Text("Available:", style: theme.textStyle),
        Padding(
          padding: EdgeInsets.only(left: 3.0),
          child: Text(acc.currency.format(widget.policy.balance),
              style: theme.textStyle),
        )
      ],
    );
  }

  void _onNext(
      AccountModel acc, ReverseSwapBloc reverseSwapBloc, bool _isNext) {
    log.info("-- yas -- _onNext1-begin --");

    if (fetching) {
      log.info("-- yas -- _onNext1-fetching --");

      return;
    }
    _asyncValidate().then((validated) {
      log.info("-- yas -- _onNext1-validated --");

      if (validated) {
        log.info("-- yas -- _onNext1-validated-true --");

        _formKey.currentState.save();
        setState(() {
          fetching = true;
        });
        FocusScope.of(context).requestFocus(FocusNode());
        log.info("-- yas -- _onNext1 --");
        return widget.onNext(acc.currency.parse(_amountController.text),
            _addressValidated, _isMax);
      }
    }).catchError((error) {
      promptError(
          context,
          null,
          Text(error.toString(),
              style: Theme.of(context).dialogTheme.contentTextStyle));
    }).whenComplete(() {
      setState(() {
        fetching = false;
      });
    });
  }

  Future _scanBarcode(AccountModel account) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String barcode = await Navigator.pushNamed<String>(context, "/qr_scan");
    if (barcode.isEmpty) {
      showFlushbar(context, message: "QR code wasn't detected.");
      return;
    }
    BTCAddressInfo btcInvoice = parseBTCAddress(barcode);
    String amount;
    if (btcInvoice.satAmount != null) {
      amount = account.currency.format(btcInvoice.satAmount,
          userInput: true,
          includeDisplayName: false,
          removeTrailingZeros: true);
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
      log.info("-- yas -- _asyncValidate-ok --");
      log.info(data);
      var v = _formKey.currentState.validate();
      log.info("-- yas -- _asyncValidate-ok2 --");
      log.info(v);
      return v;
    }).catchError((err) {
      _addressValidated = null;
      log.info("-- yas -- _asyncValidate-notok --");
      return _formKey.currentState.validate();
    });
  }
}

class WithdrawFundsPolicy {
  final Int64 minValue;
  final Int64 maxValue;
  final Int64 balance;
  final Int64 available;

  WithdrawFundsPolicy(
      this.minValue, this.maxValue, this.balance, this.available);
}
