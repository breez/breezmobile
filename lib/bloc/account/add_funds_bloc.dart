import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import "package:ini/ini.dart";
import 'package:rxdart/rxdart.dart';

import '../blocs_provider.dart';
import 'account_model.dart';
import 'add_fund_vendor_model.dart';
import 'add_funds_model.dart';
import 'moonpay_order.dart';

class AddFundsBloc extends Bloc {
  static const String ADD_FUNDS_SETTINGS_PREFERENCES_KEY = "add_funds_settings";
  static const String PENDING_MOONPAY_ORDER_KEY = "pending_moonpay_order";
  static bool _ipCheckResult = false;

  final Stream<AccountModel> accountStream;
  final _addFundRequestController = new StreamController<bool>.broadcast();

  Sink<bool> get addFundRequestSink => _addFundRequestController.sink;

  final _addFundResponseController = new StreamController<AddFundResponse>.broadcast();

  Stream<AddFundResponse> get addFundResponseStream => _addFundResponseController.stream;  

  final _moonpayNextOrderController = new StreamController<MoonpayOrder>.broadcast();
  Stream<MoonpayOrder> get moonpayNextOrderStream => _moonpayNextOrderController.stream;

  final _completedMoonpayOrderController = new BehaviorSubject<MoonpayOrder>();
  Stream<MoonpayOrder> get completedMoonpayOrderStream => _completedMoonpayOrderController.stream;
  Sink<MoonpayOrder> get completedMoonpayOrderSink => _completedMoonpayOrderController.sink;  

  final _availableVendorsController = new BehaviorSubject<List<AddFundVendorModel>>();

  Stream<List<AddFundVendorModel>> get availableVendorsStream => _availableVendorsController.stream;

  final _addFundsSettingsController = new BehaviorSubject<AddFundsSettings>();
  Stream<AddFundsSettings> get addFundsSettingsStream => _addFundsSettingsController.stream;
  Sink<AddFundsSettings> get addFundsSettingsSink => _addFundsSettingsController.sink;

  AddFundsBloc(Stream<BreezUserModel> userStream, this.accountStream) {
    ServiceInjector injector = ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    int requestNumber = 0;
    _addFundRequestController.stream.listen((newAddress) {
      var currentRequest = ++requestNumber;      
      if (!newAddress) {
        _addFundResponseController.add(null);
        return;
      }
      userStream.firstWhere((u) => u.userID != null)
        .then((user) {
          breezLib.addFundsInit(user.userID).then((reply) {
          if (currentRequest == currentRequest) {
            AddFundResponse response = AddFundResponse(reply);
            _attachMoonpayUrl(response);
            _addFundResponseController.add(response);
          }
          }).catchError((err) {
            _addFundResponseController.addError(err);
            _moonpayNextOrderController.addError(err);
          });
        });        
    });
    _addFundsSettingsController.add(AddFundsSettings.start());
    _populateAvailableVendors(false);
    _handleAddFundsSettings(injector);
    _handleMoonpayOrders(injector);
  }  

  Future _populateAvailableVendors(bool moonpayAllowed) async {
    List<AddFundVendorModel> _vendorList = [];
    _vendorList.add(AddFundVendorModel("DEPOSIT TO BTC ADDRESS", "src/icon/bitcoin.png", "/deposit_btc_address"));
    _vendorList.add(AddFundVendorModel("BUY BITCOIN", "src/icon/credit_card.png", "/buy_bitcoin", isAllowed: moonpayAllowed));
    _vendorList.add(AddFundVendorModel("REDEEM FASTBITCOINS VOUCHER", "src/icon/vendors/fastbitcoins_logo.png", "/fastbitcoins", requireActiveChannel: true));
    _availableVendorsController.add(_vendorList);
  }

  Future _attachMoonpayUrl(AddFundResponse response) async {
    if (response.errorMessage == null || response.errorMessage.isEmpty) {
      String moonpayUrl = await _createMoonpayUrl();
      String walletAddress = response.address;
      String maxQuoteCurrencyAmount = Currency.BTC.format(response.maxAllowedDeposit, includeSymbol: false, fixedDecimals: false);
      moonpayUrl += "&walletAddress=$walletAddress&maxQuoteCurrencyAmount=$maxQuoteCurrencyAmount";
      _moonpayNextOrderController.add(MoonpayOrder(walletAddress, moonpayUrl, null));    
    }    
  }

  _handleAddFundsSettings(ServiceInjector injector) async {
    var preferences = await injector.sharedPreferences;
    var addFundsSettings = preferences.getString(ADD_FUNDS_SETTINGS_PREFERENCES_KEY);
    Map<String, dynamic> settings = addFundsSettings != null ? json.decode(addFundsSettings) : {};
    bool ipAllowed = settings["moonpayIpCheck"] == false;
    if (!ipAllowed) {
      ipAllowed = await _isIPMoonpayAllowed();
    }
    _populateAvailableVendors(ipAllowed);

    _addFundsSettingsController.stream.listen((settings) async {
      preferences.setString(ADD_FUNDS_SETTINGS_PREFERENCES_KEY, json.encode(settings.toJson()));
      bool ipAllowed = settings.moonpayIpCheck == false;
      if (!ipAllowed) {
        ipAllowed = await _isIPMoonpayAllowed();
      }
      _populateAvailableVendors(ipAllowed);
    });
  }

  Future<bool> _isIPMoonpayAllowed() async {
    if (!_ipCheckResult) {
      var response = await http.get("https://api.moonpay.io/v2/ip_address");
      if (response.statusCode != 200) {
        log.severe('moonpay response error: ${response.body.substring(0, 100)}');
        throw "Service Unavailable. Please try again later.";
      }
      _ipCheckResult = jsonDecode(response.body)['isAllowed'];
    }
    return _ipCheckResult;
  }

  Future<String> _createMoonpayUrl() async {
    Config config = await _readConfig();
    String baseUrl = config.get("MoonPay Parameters", 'baseUrl');
    String apiKey = config.get("MoonPay Parameters", 'apiKey');
    String currencyCode = config.get("MoonPay Parameters", 'currencyCode');
    String colorCode = config.get("MoonPay Parameters", 'colorCode');
    String redirectURL = config.get("MoonPay Parameters", 'redirectURL');
    return "$baseUrl?apiKey=$apiKey&currencyCode=$currencyCode&colorCode=$colorCode&redirectURL=${Uri.encodeComponent(redirectURL)}";
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
      _completedMoonpayOrderController.add(MoonpayOrder.fromJson(settings));
    }
    _completedMoonpayOrderController.stream.listen((order) async {
      if (order != null) {
        preferences.setString(PENDING_MOONPAY_ORDER_KEY, json.encode(order.toJson()));
      }
    });

    accountStream.where((acc) => acc != null).listen((acc){
      var fundsStatus = acc.swapFundsStatus;
      if (fundsStatus != null) {
        var allAddresses = fundsStatus.unConfirmedAddresses.toList()..addAll(fundsStatus.confirmedAddresses);
        if (allAddresses.contains(_completedMoonpayOrderController.value?.address)) {
          preferences.remove(PENDING_MOONPAY_ORDER_KEY);
          _completedMoonpayOrderController.add(null);
        }
      }
    });
  }

  dispose() {
    _addFundRequestController.close();
    _addFundResponseController.close();
    _addFundsSettingsController.close();
    _availableVendorsController.close();
    _moonpayNextOrderController.close();
    _completedMoonpayOrderController.close();
  }
}
