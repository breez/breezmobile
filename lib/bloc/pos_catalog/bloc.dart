import 'dart:async';

import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
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
    _loadItems();
    registerAsyncHandlers({
      AddItem: _addItem,
      UpdateItem: _updateItem,
      DeleteItem: _deleteItem,
      FetchItem: _fetchItem,
      AddSale: _addSale,
      FetchSale: _fetchSale
    });
  }

  Future _loadItems() async {
    _itemsStreamController.add(await _repository.fetchAllItems());
  }

  Future _addItem(AddItem action) async {
    action.resolve(await _repository.addItem(action.item));
    _loadItems();
  }

  Future _updateItem(UpdateItem action) async {
    await _repository.updateItem(action.item);
    action.resolve(null);
    _loadItems();
  }

  Future _deleteItem(DeleteItem action) async {
    await _repository.deleteItem(action.id);
    action.resolve(null);
    _loadItems();
  }

  Future _fetchItem(FetchItem action) async {
    action.resolve(await _repository.fetchItemByID(action.id));
  }

  Future _addSale(AddSale action) async {
    action.resolve(await _repository.addSale(action.sale));    
  }

  Future _fetchSale(FetchSale action) async {
    action.resolve(await _repository.fetchSaleByID(action.id));
  }
}
