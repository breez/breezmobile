import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/l10n/text_uri.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import "package:ini/ini.dart";
import 'package:rxdart/rxdart.dart';

import '../blocs_provider.dart';
import 'add_fund_vendor_model.dart';
import 'add_funds_model.dart';
import 'moonpay_order.dart';

class AddFundsBloc extends Bloc {
  static const String ADD_FUNDS_SETTINGS_PREFERENCES_KEY = "add_funds_settings";
  static const String PENDING_MOONPAY_ORDER_KEY = "pending_moonpay_order";
  static bool _ipCheckResult = false;
  static Duration staleOrderInterval = Duration(hours: 1);

  bool _isMoonpayAllowed = false;

  final Stream<AccountModel> accountStream;
  final Stream<LSPStatus> lspStatusStream;
  final _addFundRequestController = StreamController<AddFundsInfo>.broadcast();

  Sink<AddFundsInfo> get addFundRequestSink => _addFundRequestController.sink;

  final _addFundResponseController =
      StreamController<AddFundResponse>.broadcast();

  Stream<AddFundResponse> get addFundResponseStream =>
      _addFundResponseController.stream;

  final _moonpayNextOrderController =
      StreamController<MoonpayOrder>.broadcast();
  Stream<MoonpayOrder> get moonpayNextOrderStream =>
      _moonpayNextOrderController.stream;

  final _completedMoonpayOrderController = BehaviorSubject<MoonpayOrder>();
  Stream<MoonpayOrder> get completedMoonpayOrderStream =>
      _completedMoonpayOrderController.stream;
  Sink<MoonpayOrder> get completedMoonpayOrderSink =>
      _completedMoonpayOrderController.sink;

  final _availableVendorsController =
      BehaviorSubject<List<AddFundVendorModel>>();

  Stream<List<AddFundVendorModel>> get availableVendorsStream =>
      _availableVendorsController.stream;

  final _addFundsSettingsController = BehaviorSubject<AddFundsSettings>();
  Stream<AddFundsSettings> get addFundsSettingsStream =>
      _addFundsSettingsController.stream;
  Sink<AddFundsSettings> get addFundsSettingsSink =>
      _addFundsSettingsController.sink;

  AddFundsBloc(Stream<BreezUserModel> userStream, this.accountStream,
      this.lspStatusStream) {
    ServiceInjector injector = ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    int requestNumber = 0;
    _addFundRequestController.stream.listen((addFundsInfo) {
      var currentRequest = ++requestNumber;
      if (!addFundsInfo.newAddress) {
        _addFundResponseController.add(null);
        return;
      }
      userStream.firstWhere((u) => u.userID != null).then((user) async {
        var lspStatus = await this.lspStatusStream.first;
        if (lspStatus.selectedLSP == null) {
          throw new Exception("lsp was not selected");
        }
        breezLib.addFundsInit(user.userID, lspStatus.selectedLSP).then((reply) {
          AddFundResponse response = AddFundResponse(reply);
          if (addFundsInfo.isMoonpay) {
            _attachMoonpayUrl(response, injector.breezServer);
          }
          _addFundResponseController.add(response);
        }).catchError((err) {
          _addFundResponseController.addError(err);
          _moonpayNextOrderController.addError(err);
        });
      });
    });
    _populateAvailableVendors();
    _addFundsSettingsController.add(AddFundsSettings.start());
    _handleAddFundsSettings(injector);
    _handleMoonpayOrders(injector);
  }

  Future _populateAvailableVendors() async {
    var pendingMoonpayOrder = _completedMoonpayOrderController.valueOrNull;
    bool hasPendingOrder = false;
    if (pendingMoonpayOrder != null) {
      Duration timePending = DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(
              pendingMoonpayOrder.orderTimestamp ?? 0));
      hasPendingOrder = timePending <= staleOrderInterval;
    }
    List<AddFundVendorModel> _vendorList = [];
    _vendorList.add(AddFundVendorModel(
      "Receive via BTC Address",
      "src/icon/bitcoin.png",
      "/deposit_btc_address",
      enabled: !hasPendingOrder,
      textUri: TextUri.BOTTOM_ACTION_BAR_RECEIVE_BTC_ADDRESS,
    ));
    _vendorList.add(AddFundVendorModel(
      "Buy Bitcoin",
      "src/icon/credit_card.png",
      "/buy_bitcoin",
      isAllowed: _isMoonpayAllowed,
      enabled: !hasPendingOrder,
      showLSPFee: true,
      textUri: TextUri.BOTTOM_ACTION_BAR_BUY_BITCOIN,
    ));
    _availableVendorsController.add(_vendorList);
  }

  Future _attachMoonpayUrl(
      AddFundResponse response, BreezServer breezServer) async {
    if (response.errorMessage == null || response.errorMessage.isEmpty) {
      Config config = await _readConfig();
      String baseUrl = config.get("MoonPay Parameters", 'baseUrl');
      String apiKey = config.get("MoonPay Parameters", 'apiKey');
      String currencyCode = config.get("MoonPay Parameters", 'currencyCode');
      String colorCode = config.get("MoonPay Parameters", 'colorCode');
      String redirectURL = config.get("MoonPay Parameters", 'redirectURL');
      String walletAddress = response.address;
      String maxQuoteCurrencyAmount = Currency.BTC.format(
          response.maxAllowedDeposit,
          includeDisplayName: false,
          removeTrailingZeros: true);
      String queryString = "?" +
          [
            "apiKey=$apiKey",
            "currencyCode=$currencyCode",
            "colorCode=$colorCode",
            "redirectURL=${Uri.encodeComponent(redirectURL)}",
            "enabledPaymentMethods=credit_debit_card,sepa_bank_transfer,gbp_bank_transfer",
            "walletAddress=$walletAddress",
            "maxQuoteCurrencyAmount=$maxQuoteCurrencyAmount"
          ].join("&");
      String moonpayUrl = await breezServer.signUrl(baseUrl, queryString);
      _moonpayNextOrderController
          .add(MoonpayOrder(walletAddress, moonpayUrl, null));
    }
  }

  _handleAddFundsSettings(ServiceInjector injector) async {
    var preferences = await injector.sharedPreferences;
    var addFundsSettings =
        preferences.getString(ADD_FUNDS_SETTINGS_PREFERENCES_KEY);
    Map<String, dynamic> settings =
        addFundsSettings != null ? json.decode(addFundsSettings) : {};
    _isMoonpayAllowed = settings["moonpayIpCheck"] == false;
    if (!_isMoonpayAllowed) {
      _isMoonpayAllowed = await _isIPMoonpayAllowed();
    }
    preferences.remove(PENDING_MOONPAY_ORDER_KEY);
    _populateAvailableVendors();

    _addFundsSettingsController.stream.listen((settings) async {
      preferences.setString(
          ADD_FUNDS_SETTINGS_PREFERENCES_KEY, json.encode(settings.toJson()));
      _isMoonpayAllowed = settings.moonpayIpCheck == false;
      if (!_isMoonpayAllowed) {
        _isMoonpayAllowed = await _isIPMoonpayAllowed();
      }
      _populateAvailableVendors();
    });
  }

  Future<bool> _isIPMoonpayAllowed() async {
    if (!_ipCheckResult) {
      Config config = await _readConfig();
      Uri uri = Uri.https(
        "api.moonpay.io",
        "/v3/ip_address",
        {
          "apiKey": config.get("MoonPay Parameters", 'apiKey'),
        },
      );
      var response = await http.get(uri);
      final body = response.body;
      if (response.statusCode != 200 || body == null) {
        String msg = (body?.length ?? 0) > 100 ? body.substring(0, 100) : body;
        log.severe('moonpay response error: $msg');
        throw "Service Unavailable. Please try again later.";
      }
      _ipCheckResult = jsonDecode(body)['isAllowed'];
    }
    return _ipCheckResult;
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

    Timer checkOrderTimer;
    _completedMoonpayOrderController.stream.listen((order) async {
      _populateAvailableVendors();

      checkOrderTimer?.cancel();
      if (order != null) {
        preferences.setString(
            PENDING_MOONPAY_ORDER_KEY, json.encode(order.toJson()));
        checkOrderTimer =
            Timer(staleOrderInterval, () => _populateAvailableVendors());
      }
    });

    accountStream.where((acc) => acc != null).listen((acc) {
      var fundsStatus = acc.swapFundsStatus;
      if (fundsStatus != null) {
        var allAddresses = fundsStatus.unConfirmedAddresses.toList()
          ..addAll(fundsStatus.confirmedAddresses);
        if (_completedMoonpayOrderController.hasValue &&
            allAddresses
                .contains(_completedMoonpayOrderController.value.address)) {
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
