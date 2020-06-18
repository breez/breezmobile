import 'dart:async';

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pbserver.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/utils/retry.dart';
import 'package:rxdart/rxdart.dart';

import '../async_actions_handler.dart';
import 'lnurl_actions.dart';
import 'lnurl_model.dart';

class LNUrlBloc with AsyncActionsHandler {
  final StreamController<String> lnurlRequestsStreamController =
      StreamController<String>.broadcast();
  Sink<String> get lnurlRequestSink => lnurlRequestsStreamController.sink;

  BreezBridge _breezLib;

  LNUrlBloc() {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;

    registerAsyncHandlers({
      Fetch: _fetch,
      Withdraw: _withdraw,
      OpenChannel: _openChannel,
    });
    listenActions();
  }

  Stream get lnurlStream => Observable.merge([
        ServiceInjector().nfc.receivedLnLinks(),
        ServiceInjector().lightningLinks.linksNotifications,
        lnurlRequestsStreamController.stream,
      ])
          .where((l) => l.toLowerCase().startsWith("lightning:lnurl"))
          .asyncMap((l) => _breezLib.fetchLNUrl(l))
          .map((response) {
        if (response.hasWithdraw()) {
          return WithdrawFetchResponse(response.withdraw);
        }
        if (response.hasChannel()) {
          return ChannelFetchResponse(response.channel);
        }

        return Future.error("Unsupported lnurl");
      });

  Future _fetch(Fetch action) async {
    LNUrlResponse res = await _breezLib.fetchLNUrl(action.lnurl);
    if (res.hasWithdraw()) {
      action.resolve(WithdrawFetchResponse(res.withdraw));
      return;
    }
    if (res.hasChannel()) {
      action.resolve(ChannelFetchResponse(res.channel));
      return;
    }
    throw "Unsupported LNUrl action";
  }

  Future _withdraw(Withdraw action) async {
    action.resolve(await _breezLib.withdrawLNUrl(action.bolt11Invoice));
  }

  Future _openChannel(OpenChannel action) async {
    var openResult = retry(
        () => _breezLib.connectDirectToLnurl(
            action.uri, action.k1, action.callback),
        tryLimit: 3,
        interval: Duration(seconds: 5));
    action.resolve(await openResult);
  }

  @override
  Future dispose() {
    lnurlRequestsStreamController.close();
    return super.dispose();
  }
}
