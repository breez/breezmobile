import 'package:breez/bloc/async_action.dart';

class ResetPaymentFee extends AsyncAction {}

class OverridePaymentFee extends AsyncAction {
  final bool enabled;

  OverridePaymentFee(this.enabled);
}

class UpdatePaymentBaseFee extends AsyncAction {
  final int baseFee;

  UpdatePaymentBaseFee(this.baseFee);
}

class UpdatePaymentProportionalFee extends AsyncAction {
  final double proportionalFee;

  UpdatePaymentProportionalFee(this.proportionalFee);
}

class CalculateFee extends AsyncAction {
  final int amount;

  CalculateFee(this.amount);
}
