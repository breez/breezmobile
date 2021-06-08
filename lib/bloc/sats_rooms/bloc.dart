import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/sats_rooms/actions.dart';
import 'package:breez/bloc/sats_rooms/repository.dart';
import 'package:breez/bloc/sats_rooms/sqlite/repository.dart';
import 'package:rxdart/subjects.dart';

import 'model.dart';

class SatsRoomsBloc with AsyncActionsHandler {
  // ignore: non_constant_identifier_names
  static final InvalidFile = Exception('INVALID_FILE');

  // ignore: non_constant_identifier_names
  static final InvalidData = Exception('INVALID_DATA');

  Repository _repository;

  final StreamController<List<SatsRoom>> _satsRoomsStreamController =
      BehaviorSubject<List<SatsRoom>>();

  Stream<List<SatsRoom>> get satsRoomsStream =>
      _satsRoomsStreamController.stream;

  SatsRoomsBloc() {
    _repository = SqliteRepository();
    _loadSatsRooms();
    registerAsyncHandlers({
      AddSatsRoom: _addSatsRoom,
      FetchSatsRoom: _fetchSatsRoom,
      UpdateSatsRoom: _updateSatsRoom,
      DeleteSatsRoom: _deleteSatsRoom,
      FilterSatsRooms: _filterSatsRooms,
    });
    listenActions();
  }

  Future _loadSatsRooms({String filter}) async {
    _satsRoomsStreamController
        .add(await _repository.fetchSatsRooms(filter: filter));
  }

  Future _addSatsRoom(AddSatsRoom action) async {
    action.resolve(await _repository.addSatsRoom(action.satsRoom));
    _loadSatsRooms();
  }

  Future _fetchSatsRoom(FetchSatsRoom action) async {
    action.resolve(await _repository.fetchSatsRoomByID(action.id));
  }

  Future _updateSatsRoom(UpdateSatsRoom action) async {
    await _repository.updateSatsRoom(action.satsRoom);
    action.resolve(null);
    _loadSatsRooms();
  }

  Future _deleteSatsRoom(DeleteSatsRoom action) async {
    await _repository.deleteSatsRoom(action.id);
    action.resolve(null);
    _loadSatsRooms();
  }

  _filterSatsRooms(FilterSatsRooms action) async {
    _loadSatsRooms(filter: action.filter);
  }

  Future resetDB() async {
    await (_repository as SqliteRepository).dropDB();
  }
}
