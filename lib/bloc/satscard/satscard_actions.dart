import 'package:breez/bloc/async_action.dart';

import 'satscard_model.dart';

class InitializeSlot extends AsyncAction {
  final InitializeSlotModel request;

  InitializeSlot(this.request);
}

class SweepSatscard extends AsyncAction {
  final SweepSatscardModel request;

  SweepSatscard(this.request);
}
