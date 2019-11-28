
import 'dart:async';

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pbserver.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/subjects.dart';

import '../async_actions_handler.dart';
import 'lnurl_actions.dart';
import 'lnurl_model.dart';

class LNUrlBloc with AsyncActionsHandler {
  final StreamController<WithdrawFetchResponse> _lnurlWithdrawStreamController = StreamController<WithdrawFetchResponse>.broadcast();
  Stream<WithdrawFetchResponse> get lnurlWithdrawStream => _lnurlWithdrawStreamController.stream;
  BreezBridge _breezLib;

  LNUrlBloc(){
    ServiceInjector injector = new ServiceInjector();
    _breezLib = injector.breezBridge;    
    
    registerAsyncHandlers({
      Fetch: _fetch,
      Withdraw: _withdraw,    
    });
    listenActions();

    injector.lightningLinks.linksNotifications
      .where((l) => l.toLowerCase().startsWith("lightning:lnurl"))
      .asyncMap((l) => _breezLib.fetchLNUrl(l))
      .where((response) => response.hasWithdraw())
      .map((response) => WithdrawFetchResponse(response.withdraw))
      .pipe(_lnurlWithdrawStreamController);      
  }

  Future _fetch(Fetch action) async {
    LNUrlResponse res = await _breezLib.fetchLNUrl(action.lnurl);
    if (res.hasWithdraw()) {
      action.resolve(WithdrawFetchResponse(res.withdraw));
    }
    throw "Unsupported LNUrl action";
  }

  Future _withdraw(Withdraw action) async {
    action.resolve(await _breezLib.withdrawLNUrl(action.bolt11Invoice));
  }

  Future dispose() async {
    super.dispose();
    _lnurlWithdrawStreamController.close();
  }
}