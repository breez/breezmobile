import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/pos_catalog/repository.dart';
import 'package:breez/bloc/pos_catalog/sqlite/repository.dart';
import 'package:rxdart/subjects.dart';

import 'model.dart';

class PosCatalogBloc with AsyncActionsHandler {
  Repository _repository;

  final StreamController<List<Item>> _itemsStreamController =
      BehaviorSubject<List<Item>>();
  Stream<List<Item>> get itemsStream => _itemsStreamController.stream;

  PosCatalogBloc() {
    _repository = SqliteRepository();
    _load();
  }

  Future _load() async {
    _itemsStreamController.add(await _repository.fetchAllItems());
  }
}
