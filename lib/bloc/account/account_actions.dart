
import 'dart:async';

import 'package:fixnum/fixnum.dart';

import 'account_model.dart';

class AsyncAction {
  Completer _completer = new Completer(); 
  Future get future => _completer.future;

  void resolve(Object value){
    _completer.complete(value);
  }
  void resolveError(error) {
    _completer.completeError(error);
  }
}

class SendPaymentFailureReport extends AsyncAction {
  final String traceReport;  

  SendPaymentFailureReport(this.traceReport);  
}

class ResetNetwork extends AsyncAction {}

class RestartDaemon extends AsyncAction {}

class FetchSwapFundStatus extends AsyncAction{}

class SendPayment extends AsyncAction{
  final PayRequest paymentRequest;

  SendPayment(this.paymentRequest);
}

class CancelPaymentRequest extends AsyncAction {
  final PayRequest paymentRequest;

  CancelPaymentRequest(this.paymentRequest);
}