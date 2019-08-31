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

  final _moonPayOrderController = new BehaviorSubject<MoonpayOrder>();

  Stream<MoonpayOrder> get moonPayOrderStream => _moonPayOrderController.stream;

  Sink<MoonpayOrder> get moonPayOrderSink => _moonPayOrderController.sink;

  final _availableVendorsController = new BehaviorSubject<AddFundVendorModel>();

  Stream<AddFundVendorModel> get availableVendorsStream => _availableVendorsController.stream;

  AddFundsBloc(String userID) {
    ServiceInjector injector = ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    _addFundRequestController.stream.listen((request) {
      _addFundResponseController.add(null);
      breezLib.addFundsInit(userID).then((reply) {
        AddFundResponse response = AddFundResponse(reply);
        _addFundResponseController.add(response);
        _attachMoonpayUrl(response);
      }).catchError(_addFundResponseController.addError);
    }).onDone(_dispose);
    _initializeAvailableVendors().then((_) => _listenAccountSettings(injector));
    _handleMoonpayOrders(injector);
  }

  Future _initializeAvailableVendors() async {
    _availableVendorsController.add(AddFundVendorModel("Moonpay", null, false));
  }

  Future _attachMoonpayUrl(AddFundResponse response) async {
    String moonpayUrl = await _createMoonpayUrl();
    String walletAddress = "n4VQ5YdHf7hLQ2gWQYYrcxoE5B7nWuDFNF"; // Will switch to response.address when we use public apiKey
    String maxQuoteCurrencyAmount = Currency.BTC.format(response.maxAllowedDeposit, includeSymbol: false, fixedDecimals: false);
    moonpayUrl += "&walletAddress=$walletAddress&maxQuoteCurrencyAmount=$maxQuoteCurrencyAmount";
    _availableVendorsController.add(_availableVendorsController.value.copyWith(url: moonpayUrl));
  }

  _listenAccountSettings(ServiceInjector injector) async {
    var preferences = await injector.sharedPreferences;
    var accountSettings = preferences.getString(ACCOUNT_SETTINGS_PREFERENCES_KEY);
    if (accountSettings != null) {
      Map<String, dynamic> settings = json.decode(accountSettings);
      if (settings["moonpayIpCheck"]) {
        _isIPMoonpayAllowed().then((isAllowed) {
          _availableVendorsController.add(_availableVendorsController.value.copyWith(isAllowed: isAllowed));
        });
      } else {
        _availableVendorsController.add(_availableVendorsController.value.copyWith(isAllowed: true));
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
    String moonPayURL =
        "$baseUrl?apiKey=$apiKey&currencyCode=$currencyCode&colorCode=$colorCode&redirectURL=${Uri.encodeFull(redirectURL)}";
    return moonPayURL;
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
      _moonPayOrderController.add(MoonpayOrder.fromJson(settings));
    }
    _moonPayOrderController.stream.listen((order) async {
      preferences.setString(PENDING_MOONPAY_ORDER_KEY, json.encode(order.toJson()));
    });
  }

  _dispose() {
    _addFundRequestController.close();
    _addFundResponseController.close();
    _availableVendorsController.close();
    _moonPayOrderController.close();
  }
}
