import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/collapsible_list_item.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/payment_address_form_field.dart';
import 'package:breez/widgets/send_onchain/send_onchain_available_btc.dart';
import 'package:breez/widgets/send_onchain/send_onchain_fee_confirmation.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendOnchain extends StatefulWidget {
  final AccountModel account;
  final Future<String> Function(String address, Int64 fee) onBroadcast;
  final Int64 amount;
  final String prefixMessage;
  final String originalTransaction;
  final String refundAddress;

  SendOnchain(
    this.account,
    this.amount,
    this.onBroadcast, {
    this.prefixMessage,
    this.originalTransaction,
    this.refundAddress,
  });

  @override
  State<StatefulWidget> createState() {
    return SendOnchainState();
  }
}

class SendOnchainState extends State<SendOnchain> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  final _addressController = TextEditingController();
  String _scannerErrorMessage = "";
  bool _addressValidated = false;

  Int64 selectedFee;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final dialogTheme = themeData.dialogTheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ],
        title: Text(
          texts.get_refund_transaction,
          style: themeData.appBarTheme.textTheme.headline6,
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildSendOnChainForm(),
          SendOnchainFeeConfirmation(
            address: _addressController.text,
            refundAddress: widget.refundAddress,
            amount: widget.amount,
            onFeeSelection: (fee) => selectedFee = fee,
            onPrevious: () => _pageController.previousPage(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            ),
          )
        ],
      ),
      bottomNavigationBar: FutureBuilder(
        future: Future.value(true),
        builder: (BuildContext context, AsyncSnapshot<void> snap) {
          if (!snap.hasData) {
            return Container();
          }
          return (_pageController?.page == 0)
              ? SingleButtonBottomBar(
                  text: texts.get_refund_action_continue,
                  onPressed: () {
                    validateAddress().then((validated) {
                      if (validated) {
                        _formKey.currentState.save();
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      }
                    });
                  },
                )
              : SingleButtonBottomBar(
                  text: texts.send_on_chain_broadcast,
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                    /*
                    // Broadcast the refund
                    widget.onBroadcast(currentAddress, selectedFee).then(
                      (msg) {
                        Navigator.of(context).pop();
                        if (msg != null) {
                          showFlushbar(context, message: msg);
                        }
                      },
                    );
                     */
                  },
                );
        },
      ),
    );
  }

  SingleChildScrollView _buildSendOnChainForm() {
    final texts = AppLocalizations.of(context);
    final dialogTheme = Theme.of(context).dialogTheme;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentAddressFormField(
                controller: _addressController,
                label: texts.send_on_chain_btc_address,
                iconColor: dialogTheme.contentTextStyle.color,
                tooltip: texts.send_on_chain_scan_barcode,
                textStyle: dialogTheme.contentTextStyle,
                onChanged: (value) => validateAddress(),
                validator: (value) {
                  if (value.isEmpty || !_addressValidated) {
                    return texts.send_on_chain_invalid_btc_address;
                  }
                  return null;
                },
                onPressed: _scanBarcode,
              ),
              if (_scannerErrorMessage.length > 0) ...[
                Text(_scannerErrorMessage, style: theme.validatorStyle)
              ],
              SizedBox(height: 12.0),
              SendOnchainAvailableBTC(
                widget.amount,
                widget.account,
              ),
              if (widget.originalTransaction != null) ...[
                CollapsibleListItem(
                  title: texts.send_on_chain_original_transaction,
                  sharedValue: widget.originalTransaction,
                  userStyle: dialogTheme.contentTextStyle.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future _scanBarcode() async {
    final texts = AppLocalizations.of(context);
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
    validateAddress();
  }

  Future<bool> validateAddress() async {
    final breezLib = ServiceInjector().breezBridge;

    return breezLib
        .validateAddress(_addressController.text)
        .then((validatedAddress) {
      setState(() {
        _addressValidated = true;
        _addressController.text = validatedAddress;
      });
      return _formKey.currentState.validate();
    }).catchError((err) {
      setState(() {
        _addressValidated = false;
      });
      return _formKey.currentState.validate();
    });
  }
}
