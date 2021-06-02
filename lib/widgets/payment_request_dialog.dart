import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/widgets/payment_confirmation_dialog.dart';
import 'package:breez/widgets/payment_request_info_dialog.dart';
import 'package:breez/widgets/processsing_payment_dialog.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PaymentRequestState {
  PAYMENT_REQUEST,
  WAITING_FOR_CONFIRMATION,
  PROCESSING_PAYMENT,
  USER_CANCELLED,
  PAYMENT_COMPLETED
}

class PaymentRequestDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  PaymentRequestDialog(this.context, this.accountBloc, this.invoice,
      this.firstPaymentItemKey, this.scrollController);

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestDialogState();
  }
}

class PaymentRequestDialogState extends State<PaymentRequestDialog> {
  PaymentRequestState _state;
  String _amountToPayStr;
  Int64 _amountToPay;
  ModalRoute _currentRoute;
  SendPayment _sendPayment;

  @override
  void initState() {
    super.initState();
    _state = PaymentRequestState.PAYMENT_REQUEST;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentRoute == null) {
      _currentRoute = ModalRoute.of(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: withBreezTheme(context, showPaymentRequestDialog()),
    );
  }

  // Do not pop dialog if there's a payment being processed
  Future<bool> _onWillPop() async {
    if (this._state == PaymentRequestState.PROCESSING_PAYMENT) {
      return false;
    }
    widget.accountBloc.userActionsSink.add(CancelPaymentRequest(
        PayRequest(widget.invoice.rawPayReq, _amountToPay)));
    return true;
  }

  Widget showPaymentRequestDialog() {
    const double minHeight = 220;
    if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return ProcessingPaymentDialog(
          widget.context,
          (){
            widget.accountBloc.userActionsSink.add(this._sendPayment);
            return this._sendPayment.future;
          },
          widget.accountBloc,
          widget.firstPaymentItemKey,
          _onStateChange, minHeight);
    } else if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      return PaymentConfirmationDialog(
          widget.accountBloc,
          widget.invoice,
          _amountToPay,
          _amountToPayStr,
          () => _onStateChange(PaymentRequestState.USER_CANCELLED),
          (sendPayment) {
            setState(() {
              _sendPayment = sendPayment;
               _onStateChange(PaymentRequestState.PROCESSING_PAYMENT);
            });
          },
          minHeight);
    } else {
      return PaymentRequestInfoDialog(
          widget.context,
          widget.accountBloc,
          widget.invoice,
          () => _onStateChange(PaymentRequestState.USER_CANCELLED),
          () => _onStateChange(PaymentRequestState.WAITING_FOR_CONFIRMATION),
          (sendPayment) {
            _sendPayment = sendPayment;
            _onStateChange(PaymentRequestState.PROCESSING_PAYMENT);
          },
          (map) => _setAmountToPay(map), minHeight);
    }
  }

  void _onStateChange(PaymentRequestState state) {
    if (state == PaymentRequestState.PAYMENT_COMPLETED) {
      Navigator.of(context).removeRoute(_currentRoute);
      return;
    }
    if (state == PaymentRequestState.USER_CANCELLED) {
      Navigator.of(context).removeRoute(_currentRoute);
      widget.accountBloc.userActionsSink.add(CancelPaymentRequest(
          PayRequest(widget.invoice.rawPayReq, _amountToPay)));
      return;
    }
    setState(() {
      _state = state;
    });
  }

  void _setAmountToPay(Map<String, dynamic> map) {
    _amountToPay = map["_amountToPay"];
    _amountToPayStr = map["_amountToPayStr"];
  }
}
