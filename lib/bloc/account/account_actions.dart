
import 'dart:async';
import 'package:breez/bloc/account/fiat_conversion.dart';

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

class ChangeSyncUIState extends AsyncAction {
  final SyncUIState nextState;

  ChangeSyncUIState(this.nextState);
}

class FetchRates extends AsyncAction {}

class UpdateSecurityModel extends AsyncAction {
  final String pinCode;
  final bool secureBackupWithPin;

  UpdateSecurityModel({this.pinCode, this.secureBackupWithPin});
}
