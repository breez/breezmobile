import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/sats_zones/actions.dart';

class SatsZonePaymentsBloc with AsyncActionsHandler {
  SatsZonePaymentsBloc() {
    registerAsyncHandlers({
      PayBoost: _payBoost,
    });
    listenActions();
  }


  Future _payBoost(PayBoost action) async {
  }
}
