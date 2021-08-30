import 'package:breez/bloc/async_action.dart';

import 'model.dart';

class AddSatsZone extends AsyncAction {
  final SatsZone satsZone;

  AddSatsZone(this.satsZone);
}

class FetchSatsZone extends AsyncAction {
  final int id;

  FetchSatsZone(this.id);
}

class UpdateSatsZone extends AsyncAction {
  final SatsZone satsZone;

  UpdateSatsZone(this.satsZone);
}

class DeleteSatsZone extends AsyncAction {
  final int id;

  DeleteSatsZone(this.id);
}

class FilterSatsZones extends AsyncAction {
  final String filter;

  FilterSatsZones(this.filter);
}

class PayBoost extends AsyncAction {
  final int sats;
  final String nodeID;

  PayBoost(this.sats, {this.nodeID});
}

class AdjustAmount extends AsyncAction {
  final int sats;

  AdjustAmount(this.sats);
}

class PayZoneBoost extends AsyncAction {
  final int sats;

  PayZoneBoost(this.sats);
}
