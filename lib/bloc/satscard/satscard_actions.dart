import 'package:breez/bloc/async_action.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';

import 'satscard_model.dart';

class CreateSlotSweepTransactions extends AsyncAction {
  final AddressInfo slotInfo;
  final String recipient;

  CreateSlotSweepTransactions(this.slotInfo, this.recipient);
}

class DisableListening extends AsyncAction {}

class EnableListening extends AsyncAction {}

class GetAddressInfo extends AsyncAction {
  final String address;

  GetAddressInfo(this.address);
}

class GetFeeRates extends AsyncAction {}

class InitializeSlot extends AsyncAction {
  final InitializeSlotModel request;

  InitializeSlot(this.request);
}

class SweepSatscard extends AsyncAction {
  final SweepSatscardModel request;

  SweepSatscard(this.request);
}
