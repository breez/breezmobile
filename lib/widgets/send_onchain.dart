import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/collapsible_list_item.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez_translations/breez_translations_locales.dart';

import 'flushbar.dart';

class SendOnchain extends StatefulWidget {
  final AccountModel _account;
  final Future<String> Function(String address, Int64 fee) _onBroadcast;
  final Int64 _amount;
  final String _title;
  final String prefixMessage;
  final String originalTransaction;

  const SendOnchain(
    this._account,
    this._amount,
    this._title,
    this._onBroadcast, {
    this.prefixMessage,
    this.originalTransaction,
  });

  @override
  State<StatefulWidget> createState() {
    return SendOnchainState();
  }
}

class SendOnchainState extends State<SendOnchain> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _feeController = TextEditingController();
  final _breezLib = ServiceInjector().breezBridge;
  final _feeFocusNode = FocusNode();

  String _scannerErrorMessage = "";
  String _addressValidated;
  KeyboardDoneAction _doneAction;
  bool feeUpdated = false;

  @override
  void initState() {
    super.initState();
    _doneAction = KeyboardDoneAction([_feeFocusNode]);
  }

  @override
  void didChangeDependencies() {
    _updateFee();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    _updateFee();
    super.didUpdateWidget(oldWidget);
  }

  void _updateFee() {
    final account = widget._account;
    if (!feeUpdated &&
        _feeController.text.isEmpty &&
        account.onChainFeeRate != null) {
      _feeController.text = account.onChainFeeRate.toString();
      feeUpdated = true;
    }
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final dialogTheme = themeData.dialogTheme;

    return Theme(
      data: themeData.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: theme.greyBorderSide,
          ),
        ),
        hintColor: dialogTheme.contentTextStyle.color,
        colorScheme: ColorScheme.dark(
          primary: themeData.textTheme.labelLarge.color,
          error: theme.themeId == "BLUE"
              ? Colors.red
              : themeData.colorScheme.error,
        ),
        primaryColor: themeData.textTheme.labelLarge.color,
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: Scaffold(
        backgroundColor: themeData.colorScheme.background,
        appBar: AppBar(
          systemOverlayStyle: theme.themeId == "BLUE"
              ? SystemUiOverlayStyle.dark
              : themeData.appBarTheme.systemOverlayStyle,
          automaticallyImplyLeading: false,
          title: Text(
            widget._title,
            style: dialogTheme.titleTextStyle,
            textAlign: TextAlign.left,
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: themeData.appBarTheme.actionsIconTheme.color,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: themeData.colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _asyncValidate().then((validated) {
                    if (validated) {
                      _formKey.currentState.save();
                      widget
                          ._onBroadcast(_addressValidated, _getFee())
                          .then((msg) {
                        Navigator.of(context).pop();
                        if (msg != null) {
                          showFlushbar(context, message: msg);
                        }
                      });
                    }
                  }),
                  child: Text(
                    texts.send_on_chain_broadcast,
                    style: themeData.primaryTextTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.prefixMessage != null
                        ? Text(
                            widget.prefixMessage,
                            style: TextStyle(
                              color: dialogTheme.contentTextStyle.color,
                              fontSize: 16.0,
                              height: 1.2,
                            ),
                          )
                        : const SizedBox(),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: texts.send_on_chain_btc_address,
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.only(top: 21.0),
                          alignment: Alignment.bottomRight,
                          icon: Image(
                            image: const AssetImage("src/icon/qr_scan.png"),
                            color: dialogTheme.contentTextStyle.color,
                            fit: BoxFit.contain,
                            width: 24.0,
                            height: 24.0,
                          ),
                          tooltip: texts.send_on_chain_scan_barcode,
                          onPressed: _scanBarcode,
                        ),
                      ),
                      style: dialogTheme.contentTextStyle,
                      validator: (value) {
                        if (_addressValidated == null) {
                          return texts.send_on_chain_invalid_btc_address;
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
                    TextFormField(
                      focusNode: _feeFocusNode,
                      controller: _feeController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: texts.send_on_chain_sat_per_byte_fee_rate,
                      ),
                      style: dialogTheme.contentTextStyle,
                      validator: (value) {
                        if (_feeController.text.isEmpty) {
                          return texts.send_on_chain_invalid_fee_rate;
                        }
                        return null;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: _buildAvailableBTC(context, widget._account),
                    ),
                    widget.originalTransaction != null
                        ? CollapsibleListItem(
                            title: texts.send_on_chain_original_transaction,
                            sharedValue: widget.originalTransaction,
                            userStyle: dialogTheme.contentTextStyle.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAvailableBTC(BuildContext context, AccountModel acc) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Row(
      children: [
        Text(
          texts.send_on_chain_amount,
          style: themeData.dialogTheme.contentTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            acc.currency.format(widget._amount),
            style: themeData.dialogTheme.contentTextStyle,
          ),
        ),
      ],
    );
  }

  Int64 _getFee() {
    return _feeController.text.isNotEmpty
        ? Int64.parseInt(_feeController.text)
        : Int64(0);
  }

  Future _scanBarcode() async {
    final texts = context.texts();
    FocusScope.of(context).requestFocus(FocusNode());
    String barcode = await Navigator.pushNamed<String>(context, "/qr_scan");
    if (barcode == null) {
      return;
    }
    if (barcode.isEmpty) {
      showFlushbar(
        context,
        message: texts.send_on_chain_qr_code_not_detected,
      );
      return;
    }
    setState(() {
      _addressController.text = barcode;
      _scannerErrorMessage = "";
    });
  }

  Future<bool> _asyncValidate() {
    return _breezLib.validateAddress(_addressController.text).then((data) {
      _addressValidated = data;
      return _formKey.currentState.validate();
    }).catchError((err) {
      _addressValidated = null;
      return _formKey.currentState.validate();
    });
  }
}
