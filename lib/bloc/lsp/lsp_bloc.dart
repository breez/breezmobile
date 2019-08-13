import 'dart:async';

import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../async_actions_handler.dart';
import 'lsp_actions.dart';

class LSPBloc with AsyncActionsHandler {
  final StreamController _lspsStreamController =
      BehaviorSubject<List<LSPInfo>>();
  Stream<List<LSPInfo>> get lspsStream => _lspsStreamController.stream;

  BreezBridge _breezLib;

  LSPBloc() {
    ServiceInjector injector = new ServiceInjector();
    _breezLib = injector.breezBridge;

    registerAsyncHandlers({
      FetchLSPList: _fetchLSPList,
      ConnectLSP: _connectLSP,
    });

    listenActions();
  }

  Future _fetchLSPList(FetchLSPList action) async {
    var list = await _breezLib.getLSPList();

    var lspInfoList = list.lsps.entries.map<LSPInfo>((entry) {
      return LSPInfo(entry.value, entry.key);
    }).toList();

    _lspsStreamController.add(lspInfoList);
    action.resolve(lspInfoList);
  }

  Future _connectLSP(ConnectLSP action) async {
    action.resolve(await _breezLib.connectToLSP(action.lspID));
  }

  void close() async {
    await dispose();
    await _lspsStreamController.close();
  }
}
