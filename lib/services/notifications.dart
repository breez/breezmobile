import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

final _log = FimberLog("Notifications");

abstract class Notifications {
  Future<String> getToken();
  Stream<Map<dynamic, dynamic>> get notifications;
}

class FirebaseNotifications implements Notifications {
  FirebaseMessaging _firebaseMessaging;
  NotificationSettings _firebaseNotificationSettings;

  final StreamController<Map<dynamic, dynamic>> _notificationController =
      BehaviorSubject<Map<dynamic, dynamic>>();
  Stream<Map<dynamic, dynamic>> get notifications =>
      _notificationController.stream;

  FirebaseNotifications() {
    _firebaseMessaging = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onResume);
  }

  Future<dynamic> _onMessage(RemoteMessage message) {
    _log.v("_onMessage = " + message.data.toString());
    var data = message.data["data"] ?? message.data["aps"] ?? message.data;
    if (data != null) {
      _notificationController.add(data);
    }
    return null;
  }

  Future<dynamic> _onResume(RemoteMessage message) {
    _log.v("_onResume = " + message.data.toString());
    var data = message.data["data"] ?? message.data;
    if (data != null) {
      _notificationController.add(data);
    }
    return null;
  }

  @override
  Future<String> getToken() async {
    _firebaseNotificationSettings = await _firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true);
    if(_firebaseNotificationSettings.authorizationStatus == AuthorizationStatus.authorized){
      return _firebaseMessaging.getToken();
    } else {
      return null;
    }
  }
}
