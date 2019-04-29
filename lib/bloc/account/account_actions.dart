
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
  final String traceReport;  

  SendPaymentFailureReport(this.traceReport);  
}

class ResetNetwork extends AsyncAction {}

class RestartDaemon extends AsyncAction {}

class FetchSwapFundStatus extends AsyncAction{}