import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import "package:ini/ini.dart";
import 'package:rxdart/rxdart.dart';

import 'account_model.dart';
import 'add_fund_vendor_model.dart';
import 'moonpay_order.dart';

class AddFundsBloc {
  static const String ACCOUNT_SETTINGS_PREFERENCES_KEY = "account_settings";
  static const String PENDING_MOONPAY_ORDER_KEY = "pending_moonpay_order";

  final _addFundRequestController = new StreamController<void>();

  Sink<void> get addFundRequestSink => _addFundRequestController.sink;

  final _addFundResponseController = new StreamController<AddFundResponse>();

  Stream<AddFundResponse> get addFundResponseStream => _addFundResponseController.stream;

  final _moonpayOrderController = new BehaviorSubject<MoonpayOrder>();

  Stream<MoonpayOrder> get moonpayOrderStream => _moonpayOrderController.stream;

  Sink<MoonpayOrder> get moonpayOrderSink => _moonpayOrderController.sink;

  final _moonpayUrlController = new BehaviorSubject<String>();

  Stream<String> get moonpayUrlStream => _moonpayUrlController.stream;

  final _availableVendorsController = new BehaviorSubject<List<AddFundVendorModel>>();

  Stream<List<AddFundVendorModel>> get availableVendorsStream => _availableVendorsController.stream;

  AddFundsBloc(String userID) {
    ServiceInjector injector = ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    _addFundRequestController.stream.listen((request) {
      _addFundResponseController.add(null);
      breezLib.addFundsInit(userID).then((reply) {
        AddFundResponse response = AddFundResponse(reply);
        _attachMoonpayUrl(response);
        _addFundResponseController.add(response);
      }).catchError(_addFundResponseController.addError);
    }).onDone(_dispose);
    _initializeAvailableVendors().then((_) => _listenAccountSettings(injector));
    _handleMoonpayOrders(injector);
  }

  Future _initializeAvailableVendors() async {
    List<AddFundVendorModel> _vendorList = [];
    _vendorList.add(AddFundVendorModel("btcaddress", true));
    _vendorList.add(AddFundVendorModel("moonpay", false));
    _vendorList.add(AddFundVendorModel("fastbitcoin", true));
    _availableVendorsController.add(_vendorList);
  }

  Future _attachMoonpayUrl(AddFundResponse response) async {
    String moonpayUrl = await _createMoonpayUrl();
    String walletAddress = "n4VQ5YdHf7hLQ2gWQYYrcxoE5B7nWuDFNF"; // Will switch to response.address when we use public apiKey
    String maxQuoteCurrencyAmount = Currency.BTC.format(response.maxAllowedDeposit, includeSymbol: false, fixedDecimals: false);
    moonpayUrl += "&walletAddress=$walletAddress&maxQuoteCurrencyAmount=$maxQuoteCurrencyAmount";
    _moonpayUrlController.add(moonpayUrl);
  }

  _listenAccountSettings(ServiceInjector injector) async {
    var preferences = await injector.sharedPreferences;
    var accountSettings = preferences.getString(ACCOUNT_SETTINGS_PREFERENCES_KEY);
    if (accountSettings != null) {
      Map<String, dynamic> settings = json.decode(accountSettings);
      if (settings["moonpayIpCheck"]) {
        _isIPMoonpayAllowed().then((isAllowed) {
          _availableVendorsController.value[_availableVendorsController.value.indexWhere((vendor) => vendor.name == "moonpay")] =
              _availableVendorsController.value.firstWhere((vendor) => vendor.name == "moonpay").copyWith(isAllowed: isAllowed);
        });
      } else {
        _availableVendorsController.value[_availableVendorsController.value.indexWhere((vendor) => vendor.name == "moonpay")] =
            _availableVendorsController.value.firstWhere((vendor) => vendor.name == "moonpay").copyWith(isAllowed: true);
      }
    }
  }

  Future<bool> _isIPMoonpayAllowed() async {
    var response = await http.get("https://api.moonpay.io/v2/ip_address");
    if (response.statusCode != 200) {
      log.severe('moonpay response error: ${response.body.substring(0, 100)}');
      throw "Service Unavailable. Please try again later.";
    }
    return jsonDecode(response.body)['isAllowed'];
  }

  Future<String> _createMoonpayUrl() async {
    Config config = await _readConfig();
    String baseUrl = config.get("MoonPay Parameters", 'baseUrl');
    String apiKey = config.get("MoonPay Parameters", 'apiKey');
    String currencyCode = config.get("MoonPay Parameters", 'currencyCode');
    String colorCode = config.get("MoonPay Parameters", 'colorCode');
    String redirectURL = config.get("MoonPay Parameters", 'redirectURL');
    return "$baseUrl?apiKey=$apiKey&currencyCode=$currencyCode&colorCode=$colorCode&redirectURL=${Uri.encodeFull(redirectURL)}";
  }

  Future<Config> _readConfig() async {
    String lines = await rootBundle.loadString('conf/moonpay.conf');
    return Config.fromString(lines);
  }

  Future _handleMoonpayOrders(ServiceInjector injector) async {
    var preferences = await injector.sharedPreferences;
    var pendingOrder = preferences.getString(PENDING_MOONPAY_ORDER_KEY);
    if (pendingOrder != null) {
      Map<String, dynamic> settings = json.decode(pendingOrder);
      _moonpayOrderController.add(MoonpayOrder.fromJson(settings));
    }
    _moonpayOrderController.stream.listen((order) async {
      preferences.setString(PENDING_MOONPAY_ORDER_KEY, json.encode(order.toJson()));
    });
  }

  _dispose() {
    _addFundRequestController.close();
    _addFundResponseController.close();
    _availableVendorsController.close();
    _moonpayOrderController.close();
    _moonpayUrlController.close();
  }
}
