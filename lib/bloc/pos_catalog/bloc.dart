import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/repository.dart';
import 'package:breez/bloc/pos_catalog/sqlite/repository.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:rxdart/subjects.dart';

import 'model.dart';

class PosCatalogBloc with AsyncActionsHandler {
  Repository _repository;

  final StreamController<List<Item>> _itemsStreamController =
      BehaviorSubject<List<Item>>();

  Stream<List<Item>> get itemsStream => _itemsStreamController.stream;

  final BehaviorSubject<Sale> _currentSaleController = BehaviorSubject<Sale>();
  Stream<Sale> get currentSaleStream => _currentSaleController.stream;

  PosCatalogBloc(Stream<AccountModel> accountStream) {
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
      FilterItems: _filterItems,
    });
    listenActions();
    _currentSaleController.add(Sale(saleLines: List()));
    _trackCurrentSaleRates(accountStream);
  }

  void _trackCurrentSaleRates(Stream<AccountModel> accountStream){
    accountStream.listen((acc) {
      var currentSale = _currentSaleController.value;

      // In case the price is locked we don't calculate the charge.
      if (currentSale.priceLocked) {
        return;
      }
      _currentSaleController.add(currentSale.copyWith(
        saleLines: currentSale.saleLines.map(
          (sl){
            double rate = sl.satConversionRate;
            Currency curr = Currency.fromTickerSymbol(sl.currency);
            if (curr != null) {
              rate = curr.satConversionRate;
            } else {
              rate = acc.getFiatCurrencyByShortName(sl.currency).satConversionRate;
            }
            return sl.copywith(satConversionRate: rate);
          })
          .toList()));
    });
  }

  Future _loadItems({String filter}) async {
    _itemsStreamController.add(await _repository.fetchItems(filter: filter));
  }

  _filterItems(FilterItems action) {
    _loadItems(filter: action.filter);
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
