import 'package:breez/bloc/async_action.dart';

import 'satscard_model.dart';

class DisableListening extends AsyncAction {}

class EnableListening extends AsyncAction {}

class GetAddressBalance extends AsyncAction {
  final String address;

  GetAddressBalance(this.address);
}

class InitializeSlot extends AsyncAction {
  final InitializeSlotModel request;

  InitializeSlot(this.request);
}

class SweepSatscard extends AsyncAction {
  final SweepSatscardModel request;

  SweepSatscard(this.request);
}
