import 'dart:async';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/services/notifications.dart';
import 'package:fixnum/fixnum.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class SharedPreferencesMock extends Mock implements SharedPreferences {
  Map<String, bool> _cache = {};

  @override
  bool getBool(String key) {
    return _cache[key];
  }

  @override
  Future<bool> setBool(String key, bool value) {
    _cache[key] = value;
    return Future<bool>.value(value);
  }
}

class BreezServerMock extends Mock implements BreezServer {
  Future<String> registerDevice(String token) {
    return Future<String>.value("1234");
  }
}

class NotificationsMock extends Mock implements Notifications {
  @override
  Future<String> getToken() {
    return Future<String>.value("dummy token");
  }

  @override
  Stream<Map<String, dynamic>> get notifications =>
      new BehaviorSubject<Map<String, dynamic>>().stream;
}

class NFCServiceMock extends Mock implements NFCService {
  Stream<String> receivedBreezIds() {
    return new StreamController<String>().stream;
  }
}

class BreezLibMock extends Mock implements BreezBridge {
  Future<String> addInvoice(Int64 amount,
      {String payeeName,
      String payeeImageURL,
      String payerName,
      String payerImageURL,
      String description,
      Int64 expiry,
      bool standard = false}) {
    return Future.value("lightning:test");
  }
}

class InjectorMock extends Mock implements ServiceInjector {
  BreezBridge get breezBridge {
    return BreezLibMock();
  }
}
