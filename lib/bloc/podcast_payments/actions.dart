import 'package:breez/bloc/async_action.dart';

class PayBoost extends AsyncAction {
  final int sats;
  final String boostMessage;
  final String senderName;
  final double time;

  PayBoost(
    this.sats, {
    this.boostMessage,
    this.senderName,
    this.time,
  });
}

class AdjustAmount extends AsyncAction {
  final int sats;

  AdjustAmount(this.sats);
}
