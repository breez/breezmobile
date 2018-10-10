import 'dart:async';
import 'dart:typed_data';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/lnd/generated/rpc.pb.dart';
import 'package:breez/services/lnd/lnd.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/services/notifications.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class LNDMock extends Mock implements LNDService {
  Future<GenSeedResponse> genSeed(
      Uint8List aezeedPassphrase, Uint8List seedEntropy) {
    GenSeedResponse response = new GenSeedResponse();
    response.cipherSeedMnemonic.add("testMnemonics");
    response.encipheredSeed = new Uint8List(10);
    return Future<GenSeedResponse>.value(response);
  }

  @override
  Future<dynamic> initialize() {
    return Future.value(null);
  }
}

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
  Stream<Map<String, dynamic>> get notifications => new BehaviorSubject<Map<String, dynamic>>().stream;
}

class NFCServiceMock extends Mock implements NFCService {
  Stream<String> receivedBreezIds() {
    return new StreamController<String>().stream;
  }
}

class InjectorMock extends Mock implements ServiceInjector {
  LNDService _lnd;

  @override
  LNDService get lnd => _lnd ??= new LNDMock();

  @override
  Future<SharedPreferences> get sharedPreferences =>
      Future<SharedPreferences>.value(new SharedPreferencesMock());

  @override
  BreezServer get breezServer => new BreezServerMock();

  @override
  Notifications get notifications => new NotificationsMock();

  @override
  NFCService get nfc {
    return new NFCServiceMock();
  }
}
