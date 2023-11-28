import 'package:breez/bloc/async_action.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:cktap_protocol/satscard.dart';

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
  final Satscard satscard;
  final String spendCode;
  final String chainCode;

  InitializeSlot(this.satscard, this.spendCode, this.chainCode);
}

class UnsealSlot extends AsyncAction {
  final Satscard satscard;
  final String spendCode;

  UnsealSlot(this.satscard, this.spendCode);
}
