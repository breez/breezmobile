
import 'dart:async';

import 'package:fixnum/fixnum.dart';

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
  final String paymentRequest;
  final Int64 amount;  

  SendPaymentFailureReport(this.paymentRequest, {this.amount});  
}