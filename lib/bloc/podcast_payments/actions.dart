import 'package:breez/bloc/async_action.dart';

class PayBoost extends AsyncAction {
  final int sats;

  PayBoost(this.sats);
}

class AdjustAmount extends AsyncAction {
  final int sats;

  AdjustAmount(this.sats);
}
