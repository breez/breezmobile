import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:fixnum/fixnum.dart';

class WithdrawFetchResponse {
  final LNUrlWithdraw response;

  WithdrawFetchResponse(this.response);

  String get defaultDescription => response.defaultDescription;
  Int64 get minAmount => response.minAmount;
  Int64 get maxAmount => response.maxAmount;
  bool get isFixedAmount => response.minAmount == response.maxAmount;
}

class ChannelFetchResponse {
  final LNURLChannel response;

  ChannelFetchResponse(this.response);

  String get uri => response.uri;
  String get callback => response.callback;
  String get k1 => response.k1;
}

class AuthFetchResponse {
  final LNURLAuth response;

  AuthFetchResponse(this.response);

  String get host => response.host;
  String get tag => response.tag;
  String get callback => response.callback;
  String get k1 => response.k1;
}

class PayFetchResponse {
  final LNURLPayResponse1 response;

  PayFetchResponse(this.response);

  String get host => response.host;
  String get lightningAddress => response.lightningAddress;
  String get callback => response.callback;
  Int64 get minAmount => response.minAmount;
  Int64 get maxAmount => response.maxAmount;
  Int64 get commentAllowed => response.commentAllowed;
  Int64 get amount => response.amount;
  List<LNUrlPayMetadata> get metadata => response.metadata;
  String get tag => response.tag;
  String get comment => response.comment;
  bool get isFixedAmount => response.minAmount == response.maxAmount;

  set amount(Int64 v) => response.amount = v;
  set comment(String s) => response.comment = s;
}
