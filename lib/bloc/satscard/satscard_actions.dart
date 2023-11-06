import 'package:breez/bloc/async_action.dart';

import 'satscard_model.dart';

class InitializeSatscard extends AsyncAction {
  final InitializeSatscardModel request;

  InitializeSatscard(this.request);
}

class SweepSatscard extends AsyncAction {
  final SweepSatscardModel request;

  SweepSatscard(this.request);
}
