import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/pos_csv_exporter.dart';
import 'package:breez/bloc/pos_catalog/repository.dart';
import 'package:breez/bloc/pos_catalog/sqlite/repository.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

import 'model.dart';

class PosCatalogBloc with AsyncActionsHandler {
  Repository _repository;

  final StreamController<List<Item>> _itemsStreamController =
      BehaviorSubject<List<Item>>();

  Stream<List<Item>> get itemsStream => _itemsStreamController.stream;

  final BehaviorSubject<Sale> _currentSaleController = BehaviorSubject<Sale>();

  Stream<Sale> get currentSaleStream => _currentSaleController.stream;

  final BehaviorSubject<List<ProductIcon>> _productIconsController =
      BehaviorSubject<List<ProductIcon>>();

  Stream<List<ProductIcon>> get productIconsStream =>
      _productIconsController.stream;

  PosCatalogBloc(Stream<AccountModel> accountStream) {
    _repository = SqliteRepository();
    _loadItems();
    registerAsyncHandlers({
      AddItem: _addItem,
      UpdateItem: _updateItem,
      DeleteItem: _deleteItem,
      FetchItem: _fetchItem,
      SubmitCurrentSale: _submitSale,
      FetchSale: _fetchSale,
      SetCurrentSale: _setCurrentSale,
      FilterItems: _filterItems,
      ExportItems: _exportItems,
      ImportItems: _importItems,
    });
    listenActions();
    _currentSaleController.add(Sale(saleLines: List()));
    _trackCurrentSaleRates(accountStream);
    _trackSalePayments();
    _loadIcons();
  }

  Future _loadIcons() async {
    String iconsJson =
        await rootBundle.loadString('src/json/pos-icons-meta.json');
    List<dynamic> decoded = json.decode(iconsJson);
    _productIconsController
        .add(decoded.map((e) => ProductIcon.fromJson(e)).toList());
  }

  void _trackSalePayments() {
    var breezBridge = ServiceInjector().breezBridge;

    breezBridge.notificationStream
        .where((event) =>
            event.type == NotificationEvent_NotificationType.INVOICE_PAID)
        .listen((event) async {
      var paymentHash = await breezBridge.getPaymentRequestHash(event.data[0]);
      var paidSale = await _repository.fetchSaleByPaymentHash(paymentHash);
      if (paidSale != null && paidSale.id == _currentSaleController.value.id) {
        _currentSaleController.add(Sale(saleLines: []));
      }
    });
  }

  void _trackCurrentSaleRates(Stream<AccountModel> accountStream) {
    accountStream.listen((acc) {
      var currentSale = _currentSaleController.value;

      // In case the price is locked we don't calculate the charge.
      if (currentSale.priceLocked) {
        return;
      }
      _currentSaleController.add(currentSale.copyWith(
          saleLines: currentSale.saleLines.map((sl) {
        double rate = sl.satConversionRate;
        Currency curr = Currency.fromTickerSymbol(sl.currency);
        if (curr != null) {
          rate = curr.satConversionRate;
        } else {
          rate = acc.getFiatCurrencyByShortName(sl.currency).satConversionRate;
        }
        return sl.copyWith(satConversionRate: rate);
      }).toList()));
    });
  }

  Future _loadItems({String filter}) async {
    _itemsStreamController.add(await _repository.fetchItems(filter: filter));
  }

  _filterItems(FilterItems action) async {
    _loadItems(filter: action.filter);
  }

  _exportItems(ExportItems action) async {
    List<Item> itemsList = await _repository.fetchItems();
    if (itemsList.length != 0) {
      action.resolve(await PosCsvUtils(itemsList).export());
    } else {
      throw Exception("EMPTY_LIST");
    }
  }

  _importItems(ImportItems action) async {
    List csvList = await action.importFile
        .openRead()
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    List<String> headerRow = List<String>.from(csvList.elementAt(0));
    var defaultHeaders = [
      "ID",
      "Name",
      "SKU",
      "Image URL",
      "Currency",
      "Price",
    ];
    // Need a more sophisticated control here. Check #1
    if (listEquals(headerRow, defaultHeaders)) {
      throw Exception("INVALID_FILE");
    }
    // remove header row
    csvList.removeAt(0);
    // create items list
    var itemsList = <Item>[];
    csvList.forEach((csvItem) {
      // #1: We should extend this so our users will be able
      // to import files that does not have this exact column order.
      Item item = Item(
          id: csvItem[0],
          name: csvItem[1],
          sku: csvItem[2].toString(),
          imageURL: csvItem[3] != "null" ? csvItem[3] : null,
          currency: csvItem[4] != "null" ? csvItem[4] : null,
          price: csvItem[5]);
      itemsList.add(item);
    });
    // We should try to restore old db if import fails.
    // var backupDB = await _repository.fetchItems();
    await resetDB();
    try {
      itemsList.forEach((item) async => await _addItem(AddItem(item)));
    } catch (e) {
      // backupDB.forEach((item) async => await _addItem(AddItem(item)));
      throw Exception("FAILED_IMPORT");
    }
    action.resolve(null);
    _loadItems();
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

  Future _submitSale(SubmitCurrentSale action) async {
    var currentSale = _currentSaleController.value.copyNew();
    int saleID = await _repository.addSale(currentSale, action.paymentHash);
    var submittedSale = await _repository.fetchSaleByID(saleID);
    _currentSaleController.add(submittedSale);
    action.resolve(submittedSale);
  }

  Future _fetchSale(FetchSale action) async {
    if (action.id != null) {
      action.resolve(await _repository.fetchSaleByID(action.id));
    } else {
      action.resolve(
          await _repository.fetchSaleByPaymentHash(action.paymentHash));
    }
  }

  Future _setCurrentSale(SetCurrentSale action) async {
    _currentSaleController.add(action.currentSale);
    action.resolve(action.currentSale);
  }

  Future resetDB() async {
    await (_repository as SqliteRepository).dropDB();
  }
}
