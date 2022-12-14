import 'dart:async';
import 'dart:convert' as JSON;

import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_bloc.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_model.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'make_invoice_request.dart';

class WeblnHandlers {
  final BuildContext context;
  final AccountBloc accountBloc;
  final InvoiceBloc invoiceBloc;
  StreamSubscription<CompletedPayment> _sentPaymentResultSubscription;
  StreamSubscription<PaymentRequestModel> _readyInvoicesSubscription;
  StreamSubscription<AccountModel> _accountModelSubscription;
  Completer<String> _currentInovoiceRequestCompleter;
  AccountModel _account;

  WeblnHandlers(this.context, this.accountBloc, this.invoiceBloc) {
    _readyInvoicesSubscription = invoiceBloc.readyInvoicesStream
        .asBroadcastStream()
        .where((p) => p != null)
        .listen((bolt11) {
      _currentInovoiceRequestCompleter?.complete(bolt11.rawPayReq);
      _currentInovoiceRequestCompleter = null;
    }, onError: (_) {
      _currentInovoiceRequestCompleter?.completeError("Failed");
      _currentInovoiceRequestCompleter = null;
    });

    _accountModelSubscription =
        accountBloc.accountStream.listen((acc) => _account = acc);
  }

  Future<String> get initWeblnScript =>
      rootBundle.loadString('src/scripts/initializeWebLN.js');

  Future<String> handleMessage(postMessage) async {
    Map<String,
            Future<Map<String, dynamic>> Function(Map<String, dynamic> data)>
        _handlersMapping = {
      "sendPayment": _sendPayment,
      "makeInvoice": _makeInvoice,
      "enable": (_) => Future.value({}),
      "signMessage": (_) => Future.error("Not Implemented"),
      "verifyMessage": (_) => Future.error("Not Implemented"),
      "getInfo": (_) => Future.error("Not Implemented")
    };

    String action = postMessage["action"];
    var requestId = postMessage["requestId"];
    var handler = _handlersMapping[action];
    if (handler != null) {
      try {
        var result = await handler(postMessage);
        if (requestId != null) {
          var resultData = result == null ? null : JSON.jsonEncode(result);
          return "resolveRequest($requestId, $resultData)";
        }
      } catch (e) {
        return "rejectRequest($requestId, '${e.toString()}')";
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> _sendPayment(postMessage) {
    String bolt11 = postMessage["payReq"];
    invoiceBloc.newLightningLinkSink.add(bolt11);
    if (bolt11.toLowerCase().startsWith("lightning:")) {
      bolt11 = bolt11.toLowerCase().substring(10);
    }
    return _trackPayment(bolt11).then((_) => Future.value({}));
  }

  Future<Map<String, dynamic>> _makeInvoice(postMessage) async {
    dynamic invoiceArgs = postMessage["invoiceArgs"];
    if (invoiceArgs == null) {
      return Future.error("no invoice arguments");
    }
    String memo;
    int amount = 0;
    if (invoiceArgs is Map<String, dynamic> ) {
      memo = invoiceArgs["defaultMemo"];
      amount = invoiceArgs["amount"];
    }
    if (invoiceArgs is int) {
      amount = invoiceArgs;
    }
    if (invoiceArgs is String) {
      amount = int.tryParse(invoiceArgs) ?? 0;
    }

    if (amount == null) {
      return Future.error("Zero-amount invoice is not supported.");
    }

    bool accept = await showDialog<bool>(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return MakeInvoiceRequest(
              amount: amount, description: memo, account: _account);
        });

    if (accept == true) {
      invoiceBloc.newInvoiceRequestSink
          .add(InvoiceRequestModel(null, memo, null, Int64(amount)));
      return _trackInvoice().then((bolt11) => {"paymentRequest": bolt11});
    }
    return Future.error("Request denied");
  }

  void dispose() {
    _sentPaymentResultSubscription?.cancel();
    _readyInvoicesSubscription?.cancel();
    _accountModelSubscription?.cancel();
  }

  Future<String> _trackInvoice() {
    _currentInovoiceRequestCompleter = Completer<String>();
    return _currentInovoiceRequestCompleter.future;
  }

  Future _trackPayment(String bolt11) {
    Completer paymentCompleter = Completer();
    _sentPaymentResultSubscription?.cancel();
    _sentPaymentResultSubscription =
        accountBloc.completedPaymentsStream.listen((payment) {
      if (payment.paymentRequest.paymentRequest == bolt11) {
        if (payment.cancelled) {
          paymentCompleter.completeError("canceled");
        } else {
          paymentCompleter.complete();
        }
      }
    }, onError: (_) {
      paymentCompleter.completeError("Failed");
    });

    return paymentCompleter.future;
  }
}
