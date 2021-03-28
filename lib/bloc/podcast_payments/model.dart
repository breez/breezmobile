import 'package:fixnum/fixnum.dart';

enum PaymentEventType { BoostStarted, StreamCompleted }

class PaymentEvent {
  final PaymentEventType type;
  final int sats;

  PaymentEvent(this.type, this.sats);
}
