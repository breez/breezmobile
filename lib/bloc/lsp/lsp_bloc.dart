import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
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
  static const LSP_DONT_PROMPT_PREFERENCES_KEY =
      "LSP_DONT_PROMPT_PREFERENCES_KEY";

  final _lspPromptController = StreamController<bool>.broadcast();
  Stream<bool> get lspPromptStream => _lspPromptController.stream;

  final _lspsStatusController = BehaviorSubject<LSPStatus>();
  Stream<LSPStatus> get lspStatusStream => _lspsStatusController.stream;

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

    ServiceInjector().sharedPreferences.then((sp) {
      _updateLSPStatus(sp);
      _handleLSPStatusChanges(sp);
      this.actionsSink.add(FetchLSPList());
    });
  }

  Future _fetchLSPList(FetchLSPList action) async {
    if (_lspsStatusController.value.availableLSPs.length > 0) {
      action.resolve(_lspsStatusController.value.availableLSPs);
      return;
    }

    try {
      var list = await _breezLib.getLSPList();
      var lspInfoList = list.lsps.entries.map<LSPInfo>((entry) {
        return LSPInfo(entry.value, entry.key);
      }).toList();

      _lspsStatusController.add(
          _lspsStatusController.value.copyWith(availableLSPs: lspInfoList));
      action.resolve(lspInfoList);
    } catch (err) {
      _lspsStatusController.add(_lspsStatusController.value
          .copyWith(lastConnectionError: err.toString()));
      rethrow;
    }
  }

  Future _connectLSP(ConnectLSP action) async {
    _lspsStatusController.add(_lspsStatusController.value.copyWith(
        connectionStatus: LSPConnectionStatus.InProgress,
        lastConnectionError: null,
        dontPromptToConnect: true));
    await accountStream.where((a) => a.synced).first;

    try {
      await retry(() async {
        log.info("connecting to LSP...");
        if (action.lnurl?.isNotEmpty == true) {
          action.resolve(await _breezLib.connectToLnurl(action.lnurl));
        } else {
          action.resolve(await _breezLib.connectToLSP(action.lspID));
        }
        _lspsStatusController.add(_lspsStatusController.value.copyWith(
            connectionStatus: LSPConnectionStatus.Active,
            lastConnectionError: null));
      }, tryLimit: 3, interval: Duration(seconds: 2));
    } catch (err) {
      log.info("Failed to connect to LSP: " + err.toString());
      _lspsStatusController.add(_lspsStatusController.value.copyWith(
          connectionStatus: LSPConnectionStatus.NotSelected,
          lastConnectionError: err.toString()));
      rethrow;
    }
  }

  void _updateLSPStatus(SharedPreferences sp) {
    var dontPrompt = sp.getBool(LSP_DONT_PROMPT_PREFERENCES_KEY);
    _lspsStatusController.add(
        LSPStatus.initial().copyWith(dontPromptToConnect: dontPrompt ?? false));
    List<Account_AccountStatus> lspSelectedStatuses = [
      Account_AccountStatus.CONNECTED,
      Account_AccountStatus.PROCESSING_CONNECTION
    ];

    bool breezReady = false;
    _breezLib.notificationStream.listen((event) {
      breezReady =
          breezReady || event.type == NotificationEvent_NotificationType.READY;
      if (breezReady &&
          event.type == NotificationEvent_NotificationType.ACCOUNT_CHANGED) {
        _breezLib.getAccount().then((acc) async {
          bool lspSelected = lspSelectedStatuses.contains(acc.status);
          _lspsStatusController.add(_lspsStatusController.value.copyWith(
              connectionStatus: lspSelected
                  ? LSPConnectionStatus.Active
                  : LSPConnectionStatus.NotSelected,
              dontPromptToConnect:
                  _lspsStatusController.value.dontPromptToConnect ||
                      lspSelected));
        });
      }
    });
  }

  void _handleLSPStatusChanges(SharedPreferences sp) {
    _lspsStatusController.stream.listen((status) {
      sp.setBool(LSP_DONT_PROMPT_PREFERENCES_KEY, status.dontPromptToConnect);
      if (status.shouldAutoReconnect) {
        this.actionsSink.add(ConnectLSP(status.availableLSPs[0].lspID, null));
      } else if (status.selectionRequired &&
          !status.dontPromptToConnect &&
          !_lspPromptController.isClosed) {
        _lspPromptController.add(true);
        _lspPromptController.close();
      }
    });
  }

  void close() async {
    await dispose();
    await _lspsStatusController.close();
  }
}
