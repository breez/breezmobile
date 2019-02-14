import 'dart:async';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/widgets/payment_request_dialog.dart' as paymentRequest;
import 'package:breez/widgets/flushbar.dart';

class InvoiceNotificationsHandler {
  final BuildContext _context;
  final AccountBloc _accountBloc;
  final Stream<PaymentRequestModel> _receivedInvoicesStream;
  StreamSubscription<String> _sentPaymentResultSubscription;

  InvoiceNotificationsHandler(
      this._context, this._accountBloc, this._receivedInvoicesStream) {
    _accountBloc.accountStream.where((acc) => !acc.active).first.then((acc) {
      bool loaderVisible = false;
      bool handlingRequest = false;

      // show loader for not decoded requests
      _receivedInvoicesStream
          .where(
              (payreq) => !payreq.loaded && !loaderVisible && !handlingRequest)
          .listen((payreq) {
        loaderVisible = true;
        Navigator.of(_context).push(createLoaderRoute(_context));
      });

      // show payment request dialog for decoded requests
      _receivedInvoicesStream
          .where((payreq) => payreq.loaded && !handlingRequest)
          .listen((payreq) {
        // payment request decoded pop to home and show dialog
        Navigator.popUntil(
            _context, ModalRoute.withName(Navigator.defaultRouteName));
        loaderVisible = false;
        handlingRequest = true;

        showDialog(
                context: _context,
                barrierDismissible: false,
                builder: (_) => paymentRequest.PaymentRequestDialog(
                    _context, _accountBloc, payreq))
            .whenComplete(() => handlingRequest = false);
      }).onError((error) {
        handlingRequest = false;
        Navigator.popUntil(
            _context, ModalRoute.withName(Navigator.defaultRouteName));
        if (error != null)
          Future.delayed(Duration(milliseconds: 300), () {
            showFlushbar(_context,
                message: "Failed to send payment request: ${error.toString()}");
          });
      });
    });

    _sentPaymentResultSubscription =
        _accountBloc.fulfilledPayments.listen((fulfilledPayment) {
      showFlushbar(_context, message: "Payment was successfuly sent!");
    }, onError: (error) {
      showFlushbar(_context,
          message:
              "Failed to send payment: ${error.toString().split("\n").first}");
    });
  }
}
