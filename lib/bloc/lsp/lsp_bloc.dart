import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/services/breez_server/generated/breez.pb.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/utils/retry.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logger.dart';
import '../async_actions_handler.dart';
import 'lsp_actions.dart';

class LSPBloc with AsyncActionsHandler {
  static const String SELECTED_LSP_PREFERENCES_KEY =
      "SELECTED_LSP_PREFERENCES_KEY";

  final _lspPromptController = StreamController<bool>.broadcast();
  Stream<bool> get lspPromptStream => _lspPromptController.stream;

  final _lspsStatusController = BehaviorSubject<LSPStatus>();
  Stream<LSPStatus> get lspStatusStream => _lspsStatusController.stream;

  final _reconnectStreamController = StreamController<void>.broadcast();

  final Stream<AccountModel> accountStream;
  BreezBridge _breezLib;

  LSPBloc(this.accountStream) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;

    registerAsyncHandlers({
      FetchLSPList: _fetchLSPList,
      ConnectLSP: _connectLSP,
    });

    listenActions();

    ServiceInjector().sharedPreferences.then((sp) async {
      // initial status
      var selectedLSP = sp.getString(SELECTED_LSP_PREFERENCES_KEY);
      _lspsStatusController
          .add(LSPStatus.initial().copyWith(selectedLSP: selectedLSP));
      _listenReconnects();
      _handleAccountChangs(sp);
      _handleLSPStatusChanges(sp);
    });
  }

  Future _fetchLSPList(FetchLSPList action) async {
    try {
      await _ensureLSPSFetched();
    } catch (err) {
      _lspsStatusController.add(_lspsStatusController.value
          .copyWith(lastConnectionError: err.toString()));
      rethrow;
    }
  }

  Future _connectLSP(ConnectLSP action) async {
    if (_lspsStatusController.value.availableLSPs.where((element) => element.lspID == action.lspID).length == 0) {
      throw Exception("LSP does not exist");
    }
    String selectedLSP = action.lspID;
    _lspsStatusController.add(_lspsStatusController.value
        .copyWith(selectedLSP: selectedLSP, lastConnectionError: null));
    await accountStream.where((a) => a.synced).first;

    try {
      await retry(() async {
        log.info("connecting to LSP...");
        var sp = await ServiceInjector().sharedPreferences;
        sp.setString(SELECTED_LSP_PREFERENCES_KEY, selectedLSP);
        action.resolve(await _breezLib.connectToLSPPeer(action.lspID));
      }, tryLimit: 3, interval: Duration(seconds: 2));
    } catch (err) {
      log.info("Failed to connect to LSP: " + err.toString());
      _lspsStatusController.add(_lspsStatusController.value
          .copyWith(lastConnectionError: err.toString()));
      rethrow;
    }
  }

  void _handleAccountChangs(SharedPreferences sp) {
    bool breezReady = false;
    _breezLib.notificationStream.listen((event) async {
      breezReady =
          breezReady || event.type == NotificationEvent_NotificationType.READY;
      if (breezReady &&
          event.type == NotificationEvent_NotificationType.ACCOUNT_CHANGED) {
        
        await _ensureLSPSFetched();
        if ( await _selectedLSP == null) {
          var availableLSPs = _lspsStatusController.value.availableLSPs;
          if (availableLSPs.length == 1) {
            log.info("LSP - not selected, selecting default");
            this.actionsSink.add(ConnectLSP(availableLSPs[0].lspID, null));
          }
          return;
        }

        log.info("LSP - account changed adding reconnect request");
        _reconnectStreamController.add(null);
      }
    });
  }

  void _handleLSPStatusChanges(SharedPreferences sp) {
    _lspsStatusController.stream.listen((status) {
      log.info("LSP - status changed adding reconnect request");
      _reconnectStreamController.add(null);
    });
  }

  void _listenReconnects() {
    Future connectingFuture = Future.value(null);
    _reconnectStreamController.stream
        .transform(DebounceStreamTransformer(Duration(milliseconds: 500)))
        .listen((_) async {
      connectingFuture.whenComplete(() {
        connectingFuture = _ensureLSPConnected();
      });
    });
  }

  Future<LSPInfo> get _selectedLSP async {
    var sp = await ServiceInjector().sharedPreferences;
    var selectedLSP = sp.getString(SELECTED_LSP_PREFERENCES_KEY);
    var lsp = _lspsStatusController.value.availableLSPs.firstWhere(
        (element) => element.lspID == selectedLSP,
        orElse: () => null);
    return lsp;
  }

  Future _ensureLSPConnected() async {
    var lsp = await _selectedLSP;
    if (lsp == null) {
      log.info("LSP - skipping reconnect, lsp not selected");
      return;
    }
    log.info("LSP - has selected lsp ensuring reconnect");
    var acc = await _breezLib.getAccount();
    if (acc.connectedPeers.contains(lsp.pubKey)) {
      log.info("LSP - already contains lsp peer, no need for reconnect");
      return;
    }
    log.info("LSP - do reconnect to lsp peer");
    await _breezLib.connectToLSPPeer(lsp.lspID);
    log.info("LSP - reconnected success");
  }

  void close() async {
    await dispose();
    await _lspsStatusController.close();
  }

  Future _ensureLSPSFetched() async {
    if (_lspsStatusController.value.availableLSPs.length == 0) {
      var list = await _breezLib.getLSPList();
        var lspInfoList = list.lsps.entries.map<LSPInfo>((entry) {
          return LSPInfo(entry.value, entry.key);
        }).toList();
        _lspsStatusController.add(
            _lspsStatusController.value.copyWith(availableLSPs: lspInfoList));
      }
  }
}
