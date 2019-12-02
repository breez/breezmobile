import 'package:breez/bloc/async_action.dart';

class Fetch extends AsyncAction {
  final String lnurl;

  Fetch(this.lnurl);
}

class Withdraw extends AsyncAction {
  final String bolt11Invoice;

  Withdraw(this.bolt11Invoice);
}
