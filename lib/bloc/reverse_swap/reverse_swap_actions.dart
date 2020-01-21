import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:fixnum/fixnum.dart';

class NewReverseSwap extends AsyncAction {
  final Int64 amount;
  final String address;
  final Int64 feeSats;

  NewReverseSwap(this.amount, this.address, this.feeSats);
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

class FetchInProgressSwap extends AsyncAction {}

class GetReverseSwapPolicy extends AsyncAction {}
