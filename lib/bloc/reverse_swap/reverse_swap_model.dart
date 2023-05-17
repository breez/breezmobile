import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:fixnum/fixnum.dart';

class ReverseSwapDetails {
  final String hash;
  final ReverseSwap _response;

  ReverseSwapDetails(this.hash, this._response);

  String get paymentRequest => _response.invoice;

  Int64 get amount => _response.lnAmount;

  Int64 get onChainAmount => _response.onchainAmount;

  String get claimAddress => _response.claimAddress;
}

class ReverseSwapRequest {
  ReverseSwapRequest(
      this.claimAddress, this.amount, this.isMax, this.available, this.policy);

  final String claimAddress;

  final Int64 amount;

  final bool isMax;

  final Int64 available;

  final ReverseSwapPolicy policy;
}

class ReverseSwapPolicy {
  final ReverseSwapInfo _info;
  final Int64 maxAmount;

  ReverseSwapPolicy(this._info, this.maxAmount);

  Int64 get minValue => _info.min;

  Int64 get maxValue => _info.max;

  double get percentage => _info.fees.percentage;

  Int64 get lockup => _info.fees.lockup;

  Int64 get claim => _info.fees.claim;

  String get feesHash => _info.feesHash;
}

class ReverseSwapClaimFeeEstimates {
  final ClaimFeeEstimates claimFeeEstimates;

  ReverseSwapClaimFeeEstimates(this.claimFeeEstimates);

  Map<int, Int64> get fees {
    return claimFeeEstimates.fees;
  }
}

class InProgressReverseSwaps {
  final ReverseSwapPaymentStatuses _statuses;

  InProgressReverseSwaps(this._statuses);

  int get lockupTxETA => (_statuses?.paymentsStatus?.isNotEmpty == true)
      ? _statuses.paymentsStatus[0].eta
      : -1;

  String get lockTxID => (_statuses?.paymentsStatus?.isNotEmpty == true)
      ? _statuses.paymentsStatus[0].txID
      : "";

  bool get isNotEmpty => _statuses != null;
}
