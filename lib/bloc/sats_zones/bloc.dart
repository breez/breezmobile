import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/sats_zones/actions.dart';
import 'package:breez/bloc/sats_zones/repository.dart';
import 'package:breez/bloc/sats_zones/sqlite/repository.dart';
import 'package:rxdart/subjects.dart';

import 'model.dart';

class SatsZonesBloc with AsyncActionsHandler {
  // ignore: non_constant_identifier_names
  static final InvalidFile = Exception('INVALID_FILE');

  // ignore: non_constant_identifier_names
  static final InvalidData = Exception('INVALID_DATA');

  Repository _repository;

  final StreamController<List<SatsZone>> _satsZonesStreamController =
      BehaviorSubject<List<SatsZone>>();

  Stream<List<SatsZone>> get satsZonesStream =>
      _satsZonesStreamController.stream;

  SatsZonesBloc() {
    _repository = SqliteRepository();
    _loadSatsZones();
    registerAsyncHandlers({
      AddSatsZone: _addSatsZone,
      FetchSatsZone: _fetchSatsZone,
      UpdateSatsZone: _updateSatsZone,
      DeleteSatsZone: _deleteSatsZone,
      FilterSatsZones: _filterSatsZone,
    });
    listenActions();
  }

  Future _loadSatsZones({String filter}) async {
    _satsZonesStreamController
        .add(await _repository.fetchSatsZones(filter: filter));
  }

  Future _addSatsZone(AddSatsZone action) async {
    action.resolve(await _repository.addSatsZone(action.satsZone));
    _loadSatsZones();
  }

  Future _fetchSatsZone(FetchSatsZone action) async {
    action.resolve(await _repository.fetchSatsZoneByID(action.id));
  }

  Future _updateSatsZone(UpdateSatsZone action) async {
    await _repository.updateSatsZone(action.satsZone);
    action.resolve(null);
    _loadSatsZones();
  }

  Future _deleteSatsZone(DeleteSatsZone action) async {
    await _repository.deleteSatsZone(action.id);
    action.resolve(null);
    _loadSatsZones();
  }

  _filterSatsZone(FilterSatsZones action) async {
    _loadSatsZones(filter: action.filter);
  }

  Future resetDB() async {
    await (_repository as SqliteRepository).dropDB();
  }
}
