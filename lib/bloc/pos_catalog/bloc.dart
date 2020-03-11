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

  final StreamController<Sale> _currentSaleController = BehaviorSubject<Sale>();
  Stream<Sale> get currentSaleStream => _currentSaleController.stream;

  PosCatalogBloc() {
    _repository = SqliteRepository();
    _loadItems();
    registerAsyncHandlers({
      AddItem: _addItem,
      UpdateItem: _updateItem,
      DeleteItem: _deleteItem,
      FetchItem: _fetchItem,
      AddSale: _addSale,
      FetchSale: _fetchSale,
      SetCurrentSale: _setCurrentSale,
    });
    listenActions();
    _currentSaleController.add(Sale(saleLines: List()));
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

  Future _setCurrentSale(SetCurrentSale action) async {
    _currentSaleController.add(action.currentSale);
    action.resolve(action.currentSale);
  }

  Future resetDB() async {
    await (_repository as SqliteRepository).dropDB();
  }
}
