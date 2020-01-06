import 'package:breez/bloc/async_action.dart';

import 'account_model.dart';

class SendPaymentFailureReport extends AsyncAction {
  final String traceReport;

  SendPaymentFailureReport(this.traceReport);
}

class ResetNetwork extends AsyncAction {}

class ResetChainService extends AsyncAction {}

class RestartDaemon extends AsyncAction {}

class GetWalletDBFilePath extends AsyncAction {}

class FetchSwapFundStatus extends AsyncAction{}

class FetchPayments extends AsyncAction {}

class SendPayment extends AsyncAction {
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

class SendCoins extends AsyncAction {
  final int feeRate;
  final String destAddress;

  SendCoins(this.feeRate, this.destAddress);
}

class ExportPayments extends AsyncAction {}
