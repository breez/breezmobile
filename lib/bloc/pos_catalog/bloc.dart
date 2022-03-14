import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/pos_csv_utils.dart';
import 'package:breez/bloc/pos_catalog/repository.dart';
import 'package:breez/bloc/pos_catalog/sqlite/repository.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'model.dart';

class PosCatalogBloc with AsyncActionsHandler {
  // ignore: non_constant_identifier_names
  static final InvalidFile = Exception('INVALID_FILE');
  // ignore: non_constant_identifier_names
  static final InvalidData = Exception('INVALID_DATA');

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

  final BehaviorSubject<String> _selectedCurrency = BehaviorSubject();

  Stream<String> get selectedCurrencyStream => _selectedCurrency.stream;

  final BehaviorSubject<String> _selectedPosTab = BehaviorSubject();

  Stream<String> get selectedPosTabStream => _selectedPosTab.stream;

  final BehaviorSubject<PosCatalogItemSort> _posItemSort = BehaviorSubject();

  Stream<PosCatalogItemSort> get posItemSort => _posItemSort.stream;

  final BehaviorSubject<PosReportTimeRange> _posReportRange = BehaviorSubject();

  Stream<PosReportTimeRange> get posReportRange => _posReportRange.stream;

  final BehaviorSubject<PosReportResult> _posReportResult = BehaviorSubject();

  Stream<PosReportResult> get posReportResult => _posReportResult.stream;

  PosCatalogBloc(
    Stream<AccountModel> accountStream,
    this._repository,
  ) {
    _loadPosCatalogItemSort();
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
      UpdatePosItemAdditionCurrency: _updatePosItemAdditionCurrency,
      UpdatePosSelectedTab: _updatePosSelectedTab,
      UpdatePosCatalogItemSort: _updatePosCatalogItemSort,
      UpdatePosReportTimeRange: _updatePosReportTimeRange,
      FetchPosReport: _fetchPosReport,
    });
    listenActions();
    _currentSaleController.add(Sale(
      saleLines: [],
      date: DateTime.now(),
    ));
    _trackCurrentSaleRates(accountStream);
    _trackSalePayments();
    _loadIcons();
    _loadSelectedCurrency();
    _loadSelectedPosTab();
    _loadSelectedReportTimeRange();
    _loadSelectedReportResult();
  }

  Future _loadIcons() async {
    String iconsJson =
        await rootBundle.loadString('src/json/pos-icons-meta.json');
    List<dynamic> decoded = json.decode(iconsJson);
    _productIconsController
        .add(decoded.map((e) => ProductIcon.fromJson(e)).toList());
  }

  void _loadSelectedCurrency() async {
    final prefs = await ServiceInjector().sharedPreferences;
    String currency;
    if (prefs.containsKey("ITEM_ADDITION_CURRENCY")) {
      currency = prefs.getString("ITEM_ADDITION_CURRENCY");
    } else {
      currency = "SAT";
    }
    _selectedCurrency.add(currency);
  }

  void _loadSelectedPosTab() async {
    final prefs = await ServiceInjector().sharedPreferences;
    String posTab;
    if (prefs.containsKey("POS_SELECTED_TAB")) {
      posTab = prefs.getString("POS_SELECTED_TAB");
    } else {
      posTab = "KEYPAD";
    }
    _selectedPosTab.add(posTab);
  }

  void _loadPosCatalogItemSort() async {
    final prefs = await ServiceInjector().sharedPreferences;
    PosCatalogItemSort sort;
    if (prefs.containsKey("POS_CATALOG_ITEM_SORT")) {
      sort = PosCatalogItemSort.values[prefs.getInt("POS_CATALOG_ITEM_SORT")];
    } else {
      sort = PosCatalogItemSort.NONE;
    }
    _posItemSort.add(sort);
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
        _currentSaleController.add(Sale(
          saleLines: [],
          date: DateTime.now(),
        ));
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
    final items = await _repository.fetchItems(filter: filter);
    final sort = _posItemSort.valueOrNull ?? PosCatalogItemSort.NONE;
    _itemsStreamController.add(_sort(items, sort));
  }

  List<Item> _sort(List<Item> catalogItems, PosCatalogItemSort sort) {
    switch (sort) {
      case PosCatalogItemSort.NONE:
        // Uses the sort read from disk
        break;
      case PosCatalogItemSort.ALPHABETICALLY_A_Z:
        catalogItems.sort((lhs, rhs) => lhs.name.compareTo(rhs.name));
        break;
      case PosCatalogItemSort.ALPHABETICALLY_Z_A:
        catalogItems.sort((lhs, rhs) => rhs.name.compareTo(lhs.name));
        break;
      case PosCatalogItemSort.PRICE_SMALL_TO_BIG:
        catalogItems.sort((lhs, rhs) => lhs.price.compareTo(rhs.price));
        break;
      case PosCatalogItemSort.PRICE_BIG_TO_SMALL:
        catalogItems.sort((lhs, rhs) => rhs.price.compareTo(lhs.price));
        break;
    }
    return catalogItems;
  }

  _filterItems(FilterItems action) async {
    _loadItems(filter: action.filter);
  }

  _exportItems(ExportItems action) async {
    List<Item> itemList = await _repository.fetchItems();
    if (itemList.length != 0) {
      action.resolve(await PosCsvUtils(itemList: itemList).export());
    } else {
      throw Exception("EMPTY_LIST");
    }
  }

  _importItems(ImportItems action) async {
    action.resolve(await importItems(
        await PosCsvUtils().retrieveItemListFromCSV(action.importFile)));
    _loadItems();
  }

  Future importItems(List<Item> itemList) async {
    await (_repository as SqliteRepository).replaceDB(itemList);
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

  Future _updatePosItemAdditionCurrency(
    UpdatePosItemAdditionCurrency action,
  ) async {
    final prefs = await ServiceInjector().sharedPreferences;
    prefs.setString("ITEM_ADDITION_CURRENCY", action.currency);
    _selectedCurrency.add(action.currency);
  }

  Future _updatePosSelectedTab(
    UpdatePosSelectedTab action,
  ) async {
    final prefs = await ServiceInjector().sharedPreferences;
    prefs.setString("POS_SELECTED_TAB", action.tab);
    _selectedPosTab.add(action.tab);
  }

  Future _updatePosCatalogItemSort(
    UpdatePosCatalogItemSort action,
  ) async {
    final prefs = await ServiceInjector().sharedPreferences;
    prefs.setInt("POS_CATALOG_ITEM_SORT", action.sort.index);
    _posItemSort.add(action.sort);
    _loadItems();
  }

  void _loadSelectedReportTimeRange() async {
    final prefs = await ServiceInjector().sharedPreferences;
    PosReportTimeRange timeRange;
    if (prefs.containsKey(_kPosReportTimeRangeKey)) {
      timeRange = PosReportTimeRange.fromJson(
        prefs.getString(_kPosReportTimeRangeKey),
      );
    } else {
      timeRange = PosReportTimeRange.daily();
    }
    _posReportRange.add(timeRange);
  }

  Future _updatePosReportTimeRange(
    UpdatePosReportTimeRange action,
  ) async {
    final prefs = await ServiceInjector().sharedPreferences;
    prefs.setString(_kPosReportTimeRangeKey, action.range.toJson());
    _posReportRange.add(action.range);
  }

  void _loadSelectedReportResult() async {
    _posReportResult.add(PosReportResult.empty());
  }

  Future _fetchPosReport(
    FetchPosReport action,
  ) async {
    _posReportResult.add(PosReportResult.load());
    final report = await _repository.fetchSalesReport(
      action.range.startDate,
      action.range.endDate,
    );
    _posReportResult.add(report);
  }

  Future resetDB() async {
    await (_repository as SqliteRepository).dropDB();
    _loadItems();
  }
}

const _kPosReportTimeRangeKey = "POS_REPORT_TIME_RANGE_JSON";
