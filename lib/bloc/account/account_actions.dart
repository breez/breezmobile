import 'package:breez/bloc/async_action.dart';
import 'package:breez/services/breezlib/data/rpc.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'account_model.dart';

class SendPaymentFailureReport extends AsyncAction {
  final String traceReport;

  SendPaymentFailureReport(this.traceReport);
}

class ResetNetwork extends AsyncAction {}

class ResetChainService extends AsyncAction {}

class RestartDaemon extends AsyncAction {}

class FetchSwapFundStatus extends AsyncAction {}

class UnconfirmedChannelsStatusAction extends AsyncAction {
  final UnconfirmedChannelsStatus oldStatus;

  UnconfirmedChannelsStatusAction(this.oldStatus);
}

class SetNonBlockingUnconfirmedSwaps extends AsyncAction {}

class FetchPayments extends AsyncAction {}

class SendPayment extends AsyncAction {
  final PayRequest paymentRequest;
  final bool ignoreGlobalFeedback;

  SendPayment(this.paymentRequest, {this.ignoreGlobalFeedback = false});
}

class SendSpontaneousPayment extends AsyncAction {
  final String nodeID;
  final Int64 amount;
  final String description;

  SendSpontaneousPayment(this.nodeID, this.amount, this.description);
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

class ExportPayments extends AsyncAction {}

class SweepAllCoinsTxsAction extends AsyncAction {
  final String address;

  SweepAllCoinsTxsAction(this.address);
}

class PublishTransaction extends AsyncAction {
  final List<int> tx;

  PublishTransaction(this.tx);
}

class CheckClosedChannelMismatchAction extends AsyncAction {
  final LSPInformation lsp;
  final String channelPoint;

  CheckClosedChannelMismatchAction(this.lsp, this.channelPoint);
}

class ResetClosedChannelChainInfoAction extends AsyncAction {
  final String channelPoint;
  final Int64 blockHeight;

  ResetClosedChannelChainInfoAction(this.channelPoint, this.blockHeight);
}
