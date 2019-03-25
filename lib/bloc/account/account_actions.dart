
import 'package:fixnum/fixnum.dart';

class SendPaymentFailureReport  {
  final String paymentRequest;
  final Int64 amount;

  SendPaymentFailureReport(this.paymentRequest, {this.amount});
}