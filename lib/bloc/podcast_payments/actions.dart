import 'package:breez/bloc/async_action.dart';

class PayBoost extends AsyncAction {
  final int sats;
  final String boostMessage;

  PayBoost(this.sats, {this.boostMessage});
}

class AdjustAmount extends AsyncAction {
  final int sats;

  AdjustAmount(this.sats);
}
