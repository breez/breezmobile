import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/widgets/payment_confirmation_dialog.dart';
import 'package:breez/widgets/payment_request_info_dialog.dart';
import 'package:breez/widgets/processsing_payment_dialog.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PaymentRequestState { PAYMENT_REQUEST, WAITING_FOR_CONFIRMATION, PROCESSING_PAYMENT }

class PaymentRequestDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  PaymentRequestDialog(this.context, this.accountBloc, this.invoice, this.firstPaymentItemKey, this.scrollController);

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestDialogState();
  }
}

class PaymentRequestDialogState extends State<PaymentRequestDialog> {
  StreamSubscription<AccountModel> _paymentInProgressSubscription;
  bool _inProgress = false;

  PaymentRequestState _state;
  double _initialDialogSize;
  String _amountToPayStr;
  Int64 _amountToPay;

  @override
  void initState() {
    super.initState();
    _state = PaymentRequestState.PAYMENT_REQUEST;
    _paymentInProgressSubscription = widget.accountBloc.accountStream.listen((acc) {
      _inProgress = acc.paymentRequestInProgress != null && acc.paymentRequestInProgress.isNotEmpty;
    });
  }

  @override
  dispose() {
    _paymentInProgressSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop, child: showPaymentRequestDialog());
  }

  // Do not pop dialog if there's a payment being processed
  Future<bool> _onWillPop() async {
    if (_inProgress) {
      return false;
    }
    return true;
  }

  Widget showPaymentRequestDialog() {
    if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return ProcessingPaymentDialog(widget.context, widget.accountBloc, widget.firstPaymentItemKey, widget.scrollController, _initialDialogSize);
    } else if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      return PaymentConfirmationDialog(widget.accountBloc, widget.invoice, _initialDialogSize, _amountToPay, _amountToPayStr, (state) => _onStateChange(state));
    } else {
      return PaymentRequestInfoDialog(widget.context, widget.accountBloc, widget.invoice, (state) => _onStateChange(state), (height) => _setDialogHeight(height), (map) => _setAmountToPay(map));
    }
  }

  void _onStateChange(PaymentRequestState state) {
    setState(() {
      _state = state;
    });
  }

  void _setDialogHeight(double height) {
    _initialDialogSize = height;
  }

  void _setAmountToPay(Map<String, dynamic> map) {
    _amountToPay = map["_amountToPay"];
    _amountToPayStr = map["_amountToPayStr"];
  }
}
