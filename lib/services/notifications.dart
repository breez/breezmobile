import 'dart:async';

import 'package:breez/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

abstract class Notifications {
  Future<String> getToken();
  Stream<Map<dynamic, dynamic>> get notifications;
}

class FirebaseNotifications implements Notifications {
  FirebaseMessaging _firebaseMessaging;

  final StreamController<Map<dynamic, dynamic>> _notificationController =
      BehaviorSubject<Map<dynamic, dynamic>>();
  Stream<Map<dynamic, dynamic>> get notifications =>
      _notificationController.stream;

  FirebaseNotifications() {
    _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen((event) => _onMessage(event.data));
    FirebaseMessaging.onMessageOpenedApp
        .listen((event) => _onResume(event.data));
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message) {
    log.info("_onMessage = " + message.toString());
    var data = message["data"] ?? message["aps"] ?? message;
    if (data != null) {
      _notificationController.add(data);
    }
    return null;
  }

  Future<dynamic> _onResume(Map<String, dynamic> message) {
    log.info("_onResume = " + message.toString());
    var data = message["data"] ?? message;
    if (data != null) {
      _notificationController.add(data);
    }
    return null;
  }

  @override
  Future<String> getToken() {
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    return _firebaseMessaging.getToken();
  }
}
