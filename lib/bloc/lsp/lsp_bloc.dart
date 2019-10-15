import 'dart:async';

import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../async_actions_handler.dart';
import 'lsp_actions.dart';

class LSPBloc with AsyncActionsHandler {
  static const LSP_DONT_PROMPT_PREFERENCES_KEY = "LSP_DONT_PROMPT_PREFERENCES_KEY";

  final _lspsStatusController =
      BehaviorSubject<LSPStatus>();
  Stream<LSPStatus> get lspStatusStream => _lspsStatusController.stream;

  BreezBridge _breezLib;

  LSPBloc() {
    ServiceInjector injector = new ServiceInjector();
    _breezLib = injector.breezBridge;

    registerAsyncHandlers({
      FetchLSPList: _fetchLSPList,
      ConnectLSP: _connectLSP,
    });

    listenActions();

    ServiceInjector().sharedPreferences.then((sp) => _listenLSPStatus(sp));    
  }

  Future _fetchLSPList(FetchLSPList action) async {
    var list = await _breezLib.getLSPList();

    var lspInfoList = list.lsps.entries.map<LSPInfo>((entry) {
      return LSPInfo(entry.value, entry.key);
    }).toList();

    _lspsStatusController.add(
      _lspsStatusController.value.copyWith(availableLSPs: lspInfoList)
    );
    action.resolve(lspInfoList);
  }

  Future _connectLSP(ConnectLSP action) async {
    _lspsStatusController.add(
      _lspsStatusController.value.copyWith(
        connectionStatus: LSPConnectionStatus.InProgress, lastConnectionError: null)
    );

    try {      
      if (action.lnurl?.isNotEmpty == true) {
        action.resolve(await _breezLib.connectToLnurl(action.lnurl));  
      } else {
        action.resolve(await _breezLib.connectToLSP(action.lspID));
      }
      _lspsStatusController.add(
        _lspsStatusController.value.copyWith(
          connectionStatus: LSPConnectionStatus.Active, lastConnectionError: null)
      );
    } catch (err) {
      _lspsStatusController.add(
        _lspsStatusController.value.copyWith(
          connectionStatus: LSPConnectionStatus.NotSelected,
          lastConnectionError: err.toString()
        )
      );
      rethrow;
    }
  }

  void _listenLSPStatus(SharedPreferences sp){

    var dontPrompt = sp.getBool(LSP_DONT_PROMPT_PREFERENCES_KEY);
    _lspsStatusController.add(LSPStatus(null, null, null, dontPrompt ?? false));

    List<Account_AccountStatus> lspSelectedStatuses = [
      Account_AccountStatus.CONNECTED, Account_AccountStatus.PROCESSING_CONNECTION
    ];

    _breezLib.notificationStream.listen((_){
      _breezLib.getAccount().then((acc){
        bool lspSelected =  lspSelectedStatuses.contains(acc.status);
        _lspsStatusController.add(
          _lspsStatusController.value.copyWith(
            connectionStatus: lspSelected ? LSPConnectionStatus.Active : LSPConnectionStatus.NotSelected,
            dontPromptToConnect: _lspsStatusController.value.dontPromptToConnect || lspSelected)
        );
      });
    });

    _lspsStatusController.stream.listen((status){
      sp.setBool(LSP_DONT_PROMPT_PREFERENCES_KEY, status.dontPromptToConnect);
    });
  }

  void close() async {
    await dispose();
    await _lspsStatusController.close();
  }
}
