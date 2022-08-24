import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:fixnum/fixnum.dart';

class NewReverseSwap extends AsyncAction {
  final Int64 amount;
  final String address;
  final String feesHash;
  final Int64 claimFees;
  final Int64 received;

  NewReverseSwap(
      this.amount, this.address, this.feesHash, this.claimFees, this.received);
}

class PayReverseSwap extends AsyncAction {
  final ReverseSwapDetails swap;
  final Int64 claimFee;

  PayReverseSwap(this.swap, this.claimFee);
}

class GetClaimFeeEstimates extends AsyncAction {
  final String claimAddress;

  GetClaimFeeEstimates(this.claimAddress);
}

class GetRefundFee extends AsyncAction {
  final String address;
  final String refundAddress;
  final int targetConf;
  final Int64 feeRate;

  GetRefundFee(this.address, this.refundAddress, this.targetConf, this.feeRate);
}

class FetchInProgressSwap extends AsyncAction {}

class GetReverseSwapPolicy extends AsyncAction {}
