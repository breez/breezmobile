import 'package:breez/bloc/async_action.dart';

import 'lnurl_model.dart';

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

  Login(this.response);
}
