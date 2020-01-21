import 'package:breez/services/breezlib/data/rpc.pb.dart';
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

class ReverseSwapPolicy {
  final ReverseSwapInfo _info;

  ReverseSwapPolicy(this._info);

  Int64 get minValue => _info.min;

  Int64 get maxValue => _info.max;
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
  final String claimTxId;

  InProgressReverseSwaps(this._statuses, this.claimTxId);

  int get lockupTxETA {
    if (_statuses.paymentsStatus.length == 0) {
      return -1;
    }
    return _statuses.paymentsStatus[0].eta;
  }

  bool get isEmpty => _statuses == null && claimTxId == null;
}
