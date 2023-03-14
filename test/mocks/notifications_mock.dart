import 'dart:async';

import 'package:breez/services/notifications.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsMock extends Mock implements Notifications {
  @override
  Future<String> getToken() {
    return Future<String>.value("dummy token");
  }

  BehaviorSubject<Map<String, dynamic>> notificationsController = BehaviorSubject<Map<String, dynamic>>();

  @override
  Stream<Map<String, dynamic>> get notifications => notificationsController.stream;

  void dispose() {
    notificationsController.close();
  }
}
