import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'breez_lib_mock.dart';
import 'device_mock.dart';
import 'firebase_notifications_mock.dart';
import 'shared_preferences_mock.dart';

class InjectorMock extends Mock implements ServiceInjector {
  BreezLibMock breezLibMock = BreezLibMock();

  BreezBridge get breezBridge => breezLibMock;

  SharedPreferencesMock sharedPreferencesMock = SharedPreferencesMock();

  @override
  Future<SharedPreferences> get sharedPreferences async => sharedPreferencesMock;

  DeviceMock deviceMock = DeviceMock();

  @override
  Device get device => deviceMock;

  FirebaseNotificationsMock firebaseNotificationsMock = FirebaseNotificationsMock();

  @override
  Notifications get notifications => firebaseNotificationsMock;

  MockClientHandler mockHandler;

  @override
  Client get client {
    final handler = mockHandler ?? (request) => Future.value(Response('', 200));
    return MockClient(handler);
  }

  void dispose() {
    breezLibMock.dispose();
    deviceMock.dispose();
  }
}
