import 'dart:async';

import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'package:breez/services/notifications.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/src/mixin/handler_mixin.dart';

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
  Future<String> registerDevice(String token, String nodeid) {
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
  Future<AddInvoiceReply> addInvoice(
    Int64 amount, {
    String payeeName,
    String payeeImageURL,
    String payerName,
    String payerImageURL,
    String description,
    Int64 expiry,
    LSPInformation lspInfo,
  }) {
    return Future.value(AddInvoiceReply());
  }
}

class DeviceMock extends Mock implements Device {
  final StreamController<NotificationType> _eventsController =
      StreamController.broadcast();

  Stream<NotificationType> get eventStream => _eventsController.stream;

  void dispose() {
    _eventsController.close();
  }
}

class FirebaseNotificationsMock extends Mock implements FirebaseNotifications {
  @override
  Future<String> getToken() => Future.value('a token');
}

class InjectorMock extends Mock implements ServiceInjector {
  MockClientHandler mockHandler;

  BreezBridge get breezBridge {
    return BreezLibMock();
  }

  @override
  Future<SharedPreferences> get sharedPreferences async {
    return SharedPreferencesMock();
  }

  @override
  Device get device => DeviceMock();

  @override
  Notifications get notifications => FirebaseNotificationsMock();

  @override
  Client get client {
    final handler = mockHandler ?? (request) => Future.value(Response('', 200));
    return MockClient(handler);
  }
}

void sqfliteFfiInitAsMockMethodCallHandler() {
  const channel = MethodChannel('com.tekartik.sqflite');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    try {
      return await FfiMethodCall(
        methodCall.method,
        methodCall.arguments,
      ).handleInIsolate();
    } on SqfliteFfiException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
        details: e.details,
      );
    }
  });
}
