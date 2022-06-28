import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:fixnum/fixnum.dart';

class Fetch extends AsyncAction {
  final String lnurl;

  Fetch(this.lnurl);
}

class Withdraw extends AsyncAction {
  final String bolt11Invoice;

  Withdraw(this.bolt11Invoice);
}

class OpenChannel extends AsyncAction {
  final String uri;
  final String callback;
  final String k1;

  OpenChannel(this.uri, this.callback, this.k1);
}

class Login extends AsyncAction {
  final AuthFetchResponse response;
  final bool jwt;

  Login(this.response, {this.jwt = false});
}

class FetchInvoice extends AsyncAction {
  final PayFetchResponse response;

  FetchInvoice(this.response);
}

class RegisterNfcSaleRequest extends AsyncAction {
  final String payeeName;
  final String description;
  final String logo;
  final Int64 amount;
  final Int64 expiry;

  RegisterNfcSaleRequest(
    this.payeeName,
    this.description,
    this.logo,
    this.amount,
    this.expiry,
  );
}

class ClearNfcSaleRequest extends AsyncAction {}
