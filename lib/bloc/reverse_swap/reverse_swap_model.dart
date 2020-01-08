import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:fixnum/fixnum.dart';

class ReverseSwapInfo {
  final String hash;
  final ReverseSwap _response;

  ReverseSwapInfo(this.hash, this._response);

  String get paymentRequest => _response.invoice;

  Int64 get amount => _response.lnAmount;

  Int64 get onChainAmount => _response.onchainAmount;
}