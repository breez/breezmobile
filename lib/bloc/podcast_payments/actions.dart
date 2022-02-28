import 'package:breez/bloc/async_action.dart';

class PayBoost extends AsyncAction {
  final int sats;
  final String boostMessage;
  final String senderName;

  PayBoost(
    this.sats, {
    this.boostMessage,
    this.senderName,
  });
}

class AdjustAmount extends AsyncAction {
  final int sats;

  AdjustAmount(this.sats);
}
