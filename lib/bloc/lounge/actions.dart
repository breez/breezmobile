import 'package:breez/bloc/async_action.dart';

import 'model.dart';

class AddLounge extends AsyncAction {
  final String title;
  final String loungeID;

  AddLounge(this.title, {this.loungeID});
}

class FetchLounge extends AsyncAction {
  final int id;

  FetchLounge(this.id);
}

class UpdateLounge extends AsyncAction {
  final Lounge lounge;

  UpdateLounge(this.lounge);
}

class DeleteLounge extends AsyncAction {
  final int id;

  DeleteLounge(this.id);
}

class FilterLounges extends AsyncAction {
  final String filter;

  FilterLounges(this.filter);
}

class PayBoost extends AsyncAction {
  final int sats;
  final String title;
  final String loungeID;
  final String nodeID;

  PayBoost(this.sats, this.title, this.loungeID, this.nodeID);
}

class AdjustAmount extends AsyncAction {
  final int sats;

  AdjustAmount(this.sats);
}
