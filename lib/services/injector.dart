import 'dart:async';

import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/currency_service.dart';
import 'package:breez/services/deep_links.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/lightning_links.dart';
import 'package:breez/services/local_auth_service.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/services/notifications.dart';
import 'package:breez/services/permissions.dart';
import 'package:breez/services/qr_scan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_task.dart';

class ServiceInjector {
  static final _singleton = ServiceInjector._internal();
  static ServiceInjector _injector;

  BreezServer _breezServer;
  FirebaseNotifications _notifications;
  BreezBridge _breezBridge;
  NFCService _nfcService;
  DeepLinksService _deepLinksService;
  LightningLinksService _lightningLinksService;
  Device _device;
  Future<SharedPreferences> _sharedPreferences;
  Permissions _permissions;
  BackgroundTaskService _backroundTaskService;
  CurrencyService _currencyService;
  LocalAuthenticationService _localAuthService;
  QRScanService _qrScanService;

  factory ServiceInjector() {
    return _injector != null ? _injector : _singleton;
  }

  ServiceInjector._internal();

  static void configure(ServiceInjector injector) {
    _injector = injector;
  }

  Notifications get notifications {
    return _notifications ??= FirebaseNotifications();
  }

  NFCService get nfc {
    return _nfcService ??= NFCService();
  }

  BreezServer get breezServer {
    return _breezServer ??= BreezServer();
  }

  BreezBridge get breezBridge {
    return _breezBridge ??= BreezBridge();
  }

  Device get device {
    return _device ??= Device();
  }

  DeepLinksService get deepLinks => _deepLinksService ??= DeepLinksService();

  LightningLinksService get lightningLinks =>
      _lightningLinksService ??= LightningLinksService();

  Future<SharedPreferences> get sharedPreferences =>
      _sharedPreferences ??= SharedPreferences.getInstance();

  Permissions get permissions {
    return _permissions ??= Permissions();
  }

  BackgroundTaskService get backgroundTaskService {
    return _backroundTaskService ??= BackgroundTaskService();
  }

  CurrencyService get currencyService {
    return _currencyService ??= CurrencyService();
  }

  LocalAuthenticationService get localAuthService {
    return _localAuthService ??= LocalAuthenticationService();
  }

  QRScanService get qrScanService {
    return _qrScanService ??= QRScanService();
  }
}
