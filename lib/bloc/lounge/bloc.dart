import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/lounge/actions.dart';
import 'package:breez/bloc/lounge/repository.dart';
import 'package:breez/bloc/lounge/sqlite/repository.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/subjects.dart';

import 'model.dart';

class LoungesBloc with AsyncActionsHandler {
  // ignore: non_constant_identifier_names
  static final InvalidFile = Exception('INVALID_FILE');

  // ignore: non_constant_identifier_names
  static final InvalidData = Exception('INVALID_DATA');

  Repository _repository;

  final StreamController<List<Lounge>> _loungesStreamController =
      BehaviorSubject<List<Lounge>>();

  Stream<List<Lounge>> get loungesStream => _loungesStreamController.stream;

  LoungesBloc() {
    _repository = SqliteRepository();
    _loadLounges();
    registerAsyncHandlers({
      AddLounge: _addLounge,
      FetchLounge: _fetchLounge,
      UpdateLounge: _updateLounge,
      DeleteLounge: _deleteLounge,
      FilterLounges: _filterLounge,
    });
    listenActions();
  }

  Future<String> _getPersistentNodeID() async {
    var preferences = await ServiceInjector().sharedPreferences;
    return preferences
        .getString(AccountBloc.PERSISTENT_NODE_ID_PREFERENCES_KEY);
  }

  Future _loadLounges({String filter}) async {
    _loungesStreamController.add(await _repository.fetchLounge(filter: filter));
  }

  Future _addLounge(AddLounge action) async {
    var nodeID = await _getPersistentNodeID();
    if (nodeID == null) {
      throw new Exception("node is not initialized");
    }
    action.resolve(await _repository.addLounge(Lounge(
        loungeID: action.loungeID ?? "breez-$nodeID",
        title: action.title,
        isHosted: action.loungeID == null)));
    _loadLounges();
  }

  Future _fetchLounge(FetchLounge action) async {
    action.resolve(await _repository.fetchLoungeByID(action.id));
  }

  Future _updateLounge(UpdateLounge action) async {
    await _repository.updateLounge(action.lounge);
    action.resolve(null);
    _loadLounges();
  }

  Future _deleteLounge(DeleteLounge action) async {
    await _repository.deleteLounge(action.id);
    action.resolve(null);
    _loadLounges();
  }

  _filterLounge(FilterLounges action) async {
    _loadLounges(filter: action.filter);
  }

  Future resetDB() async {
    await (_repository as SqliteRepository).dropDB();
  }
}
