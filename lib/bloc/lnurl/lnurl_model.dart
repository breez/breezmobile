
import 'package:breez/services/breezlib/data/rpc.pbserver.dart';
import 'package:fixnum/fixnum.dart';

class WithdrawFetchResponse {
  final LNUrlWithdraw response;

  WithdrawFetchResponse(this.response);

  String get defaultDescription => response.defaultDescription;
  Int64 get minAmount => response.minAmount;
  Int64 get maxAmount => response.maxAmount;
}