import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' as JSON;

class WeblnHandlers {
  final AccountBloc accountBloc;
  final InvoiceBloc invoiceBloc;
  final Future Function(String handlerName) onBeforeCallHandler;
  StreamSubscription<CompletedPayment> _sentPaymentResultSubscription; 

  WeblnHandlers(this.accountBloc, this.invoiceBloc, this.onBeforeCallHandler);   

  Future<String> get initWeblnScript => rootBundle.loadString('src/scripts/initializeWebLN.js');

  Future<String> handleMessage(postMessage) async {
    Map<String, Future<Map<String, dynamic>> Function(Map<String, dynamic> data)> _handlersMapping = {
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
      await onBeforeCallHandler(action);
      try {
        var result = await handler(postMessage);
        if (requestId != null) {
          var resultData = result == null ? null : JSON.jsonEncode(result);
          return "resolveRequest($requestId, $resultData)";
        }
      } catch (e) {
        return "rejectRequest($requestId, ${e.toString()})";
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> _sendPayment(postMessage) {
    String bolt11 = postMessage["payReq"];
    invoiceBloc.newLightningLinkSink.add(bolt11);
    return _trackPayment(bolt11).then((_) => Future.value({}));
  }

  Future<Map<String, dynamic>> _makeInvoice(postMessage) {
    return Future.error("Not Implemented");
  }

  void dispose(){
    _sentPaymentResultSubscription?.cancel();
  }

  Future _trackPayment(String bolt11) {    
    Completer paymentCompleter = new Completer();
    _sentPaymentResultSubscription?.cancel();        
    _sentPaymentResultSubscription = accountBloc.completedPaymentsStream.listen((payment) {
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