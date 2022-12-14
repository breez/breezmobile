import 'dart:async';

import 'package:clovrlabs_wallet/logger.dart';
import 'package:clovrlabs_wallet/services/breezlib/breez_bridge.dart';
import 'package:clovrlabs_wallet/services/breezlib/data/rpc.pbserver.dart';
import 'package:clovrlabs_wallet/services/injector.dart';
import 'package:clovrlabs_wallet/utils/lnurl.dart';
import 'package:clovrlabs_wallet/utils/locale.dart';
import 'package:clovrlabs_wallet/utils/retry.dart';
import 'package:rxdart/rxdart.dart';
import 'package:clovrlabs_wallet/bloc/async_actions_handler.dart';
import 'package:clovrlabs_wallet/bloc/lnurl/lnurl_actions.dart';
import 'package:clovrlabs_wallet/bloc/lnurl/lnurl_model.dart';

enum fetchLNUrlState { started, completed }

class LNUrlBloc with AsyncActionsHandler {
  BreezBridge _breezLib;

  StreamController _lnUrlStreamController;

  StreamController<String> _lnurlInputController =
      StreamController<String>.broadcast();
  Sink<String> get lnurlInputSink => _lnurlInputController.sink;

  LNUrlBloc() {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;

    registerAsyncHandlers({
      Fetch: _fetch,
      Withdraw: _withdraw,
      OpenChannel: _openChannel,
      Login: _login,
      FetchInvoice: _fetchInvoice,
    });
    listenActions();
  }

  listenLNUrl() {
    log.info('listenLNUrl');
    if (_lnUrlStreamController == null) {
      _lnUrlStreamController = StreamController.broadcast();
      final injector = ServiceInjector();
      Rx.merge([
        injector.lightningLinks.linksNotifications,
        _lnurlInputController.stream,
        injector.device.distinctClipboardStream.where((l) {
          var result = true;
          if (isLightningAddress(l)) {
            result = isLightningAddressURI(l);
          }
          return result;
        })
      ])
          .where((l) => l != null && (isLNURL(l) || isLightningAddress(l)))
          .asyncMap((l) {
        var v = parseLightningAddress(l);
        v ??= l;
        _lnUrlStreamController.add(fetchLNUrlState.started);
        return _breezLib.fetchLNUrl(v).catchError((error) {
          throw error.toString();
        });
      }).map((response) {
        _lnUrlStreamController.add(fetchLNUrlState.completed);
        if (response.runtimeType == LNUrlResponse) {
          if (response.hasWithdraw()) {
            final withdrawResponse = WithdrawFetchResponse(response.withdraw);
              _lnUrlStreamController.add(withdrawResponse);
          } else if (response.hasChannel()) {
            _lnUrlStreamController.add(ChannelFetchResponse(response.channel));
          } else if (response.hasAuth()) {
            _lnUrlStreamController.add(AuthFetchResponse(response.auth));
          } else if (response.hasPayResponse1()) {
            _lnUrlStreamController.add(PayFetchResponse(response.payResponse1));
          } else {
            final texts = getSystemAppLocalizations();
            _lnUrlStreamController.addError(texts.lnurl_error_unsupported);
          }
        }
      }).handleError((error) {
        _lnUrlStreamController.add(fetchLNUrlState.completed);
        _lnUrlStreamController.addError(error.toString());
      }).listen((_) {});
    }
    return _lnUrlStreamController.stream;
  }

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
    if (res.hasAuth()) {
      action.resolve(AuthFetchResponse(res.auth));
      return;
    }
    if (res.hasPayResponse1()) {
      action.resolve(PayFetchResponse(res.payResponse1));
      return;
    }
    throw "Unsupported LNUrl action";
  }

  Future _withdraw(Withdraw action) async {
    action.resolve(await _breezLib.withdrawLNUrl(action.bolt11Invoice));
  }

  Future _login(Login action) async {
    action.response.response.jwt = action.jwt;
    action.resolve(await _breezLib.loginLNUrl(action.response));
  }

  Future _fetchInvoice(FetchInvoice action) async {
    action.resolve(await _breezLib.fetchLNUrlPayInvoice(action.response));
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
    _lnUrlStreamController.close();
    _lnurlInputController.close();
    return super.dispose();
  }
}
