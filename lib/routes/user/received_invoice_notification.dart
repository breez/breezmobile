import 'dart:async';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/widgets/payment_request_dialog.dart' as paymentRequest;
import 'package:breez/widgets/flushbar.dart';

String _currentlyHandledRawPayReq = "";

class InvoiceNotificationsHandler {
  final BuildContext _context;
  final AccountBloc _accountBloc;
  final Stream<PaymentRequestModel> _receivedInvoicesStream;
  StreamSubscription<String> _sentPaymentResultSubscription;

  InvoiceNotificationsHandler(this._context, this._accountBloc, this._receivedInvoicesStream) {
    _receivedInvoicesStream.listen((PaymentRequestModel message) {
      if (_currentlyHandledRawPayReq != message.rawPayReq) {
        _currentlyHandledRawPayReq = message.rawPayReq;
        Navigator.popUntil(_context, ModalRoute.withName(Navigator.defaultRouteName));
        showDialog(context: _context, builder: (_) => paymentRequest.PaymentRequestDialog(_context, _accountBloc, message)).then((result) {
          _currentlyHandledRawPayReq = "";
        });
      }
    }, onError: (error) {
      Navigator.popUntil(_context, ModalRoute.withName(Navigator.defaultRouteName));
      Future.delayed(Duration(milliseconds: 300), () {
        showFlushbar(_context, message: "Failed to send payment request: ${error.toString()}");
      });
    });
    _sentPaymentResultSubscription = _accountBloc.fulfilledPayments.listen((fulfilledPayment) {
      showFlushbar(_context, message: "Payment was successfuly sent!");
    }, onError: (error) {
      showFlushbar(_context, message: "Failed to send payment: ${error.toString().split("\n").first}");
    });
  }
}
