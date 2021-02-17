import 'package:breez/bloc/async_action.dart';

class PayBoost extends AsyncAction {
  PayBoost();
}

class AdjustAmount extends AsyncAction {
  final int sats;
  AdjustAmount(this.sats);
}
