import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_model.dart';
import 'package:breez/bloc/lnurl/nfc_withdraw_invoice_status.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pbserver.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/utils/lnurl.dart';
import 'package:breez/utils/retry.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:rxdart/rxdart.dart';

enum FetchLNUrlState { started, completed }

class LNUrlBloc with AsyncActionsHandler {
  BreezBridge _breezLib;

  StreamController _lnUrlStreamController;

  final StreamController<String> _lnurlInputController =
      StreamController<String>.broadcast();
  Sink<String> get lnurlInputSink => _lnurlInputController.sink;

  final StreamController<NfcWithdrawInvoiceStatus> _nfcWithdrawController =
      StreamController<NfcWithdrawInvoiceStatus>.broadcast();
  Stream<NfcWithdrawInvoiceStatus> get nfcWithdrawStream =>
      _nfcWithdrawController.stream;
  RegisterNfcSaleRequest _nfcSaleRequest;

  LNUrlBloc() {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;

    registerAsyncHandlers({
      Fetch: _fetch,
      Withdraw: _withdraw,
      OpenChannel: _openChannel,
      Login: _login,
      FetchInvoice: _fetchInvoice,
      RegisterNfcSaleRequest: _registerNfcSaleRequest,
      ClearNfcSaleRequest: _clearNfcSaleRequest,
    });
    listenActions();
  }

  listenLNUrl() {
    log.info('listenLNUrl');
    if (_lnUrlStreamController == null) {
      _lnUrlStreamController = StreamController.broadcast();
      final injector = ServiceInjector();
      Rx.merge([
        injector.nfc.receivedLnLinks(),
        injector.lightningLinks.linksNotifications,
        _lnurlInputController.stream,
        injector.device.clipboardStream
            .distinct()
            .skip(1) // Skip previous session clipboard
            .where((l) {
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
        _lnUrlStreamController.add(FetchLNUrlState.started);
        return _breezLib.fetchLNUrl(v).catchError((error) {
          throw error.toString();
        });
      }).map((response) {
        _lnUrlStreamController.add(FetchLNUrlState.completed);
        if (response.runtimeType == LNUrlResponse) {
          if (response.hasWithdraw()) {
            final withdrawResponse = WithdrawFetchResponse(response.withdraw);
            final nfcSaleRequest = _nfcSaleRequest;
            if (nfcSaleRequest != null) {
              _withdrawNfc(nfcSaleRequest, withdrawResponse);
            } else {
              _lnUrlStreamController.add(withdrawResponse);
            }
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
        _lnUrlStreamController.add(FetchLNUrlState.completed);
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
        interval: const Duration(seconds: 5));
    action.resolve(await openResult);
  }

  Future _registerNfcSaleRequest(RegisterNfcSaleRequest action) async {
    _nfcSaleRequest = action;
  }

  Future _clearNfcSaleRequest(ClearNfcSaleRequest action) async {
    _nfcSaleRequest = null;
  }

  Future<void> _withdrawNfc(
    RegisterNfcSaleRequest action,
    WithdrawFetchResponse response,
  ) async {
    if (response.minAmount > action.amount ||
        response.maxAmount < action.amount) {
      log.info("NFC Payment Request rangeError, requested ${action.amount} but the range is ${response.minAmount} - ${response.maxAmount}");
      _nfcWithdrawController.add(NfcWithdrawInvoiceStatus.rangeError(
        response.minAmount,
        response.maxAmount,
      ));
    } else {
      log.info("Starting NFC Sale");
      _nfcWithdrawController.add(NfcWithdrawInvoiceStatus.started());
      try {
        await _breezLib.withdrawLNUrl(action.paymentRequest.rawPayReq);
        _nfcWithdrawController.add(NfcWithdrawInvoiceStatus.completed());
      } catch (error) {
        log.info("NFC Payment Request error: $error");
        _nfcWithdrawController.add(NfcWithdrawInvoiceStatus.error(error));
      }
    }
  }

  @override
  Future dispose() {
    _lnUrlStreamController.close();
    _lnurlInputController.close();
    _nfcWithdrawController.close();
    return super.dispose();
  }
}
