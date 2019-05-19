import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:breez/logger.dart';

abstract class Notifications {
    Future<String> getToken();
    Stream<Map<dynamic, dynamic>> get notifications;
}


class FirebaseNotifications implements Notifications {
  
  FirebaseMessaging _firebaseMessaging;

  final StreamController<Map<dynamic, dynamic>> _notificationController = new BehaviorSubject<Map<dynamic, dynamic>>();
  Stream<Map<dynamic, dynamic>> get notifications => _notificationController.stream;

  FirebaseNotifications() {    
    _firebaseMessaging = new FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: _onMessage,
      onResume: _onResume,
      onLaunch: _onResume
    );
  }

  Future<dynamic> _onMessage(Map<String, dynamic> message) { 
    print("_onMessge: " + message.toString());
    var data = message["data"] ?? message["aps"];
    if (data != null) {
      _notificationController.add(data);
    }
    return null;
  }

  Future<dynamic> _onResume(Map<String, dynamic> message) {  
    print("_onResume: " + message.toString());     
    _notificationController.add(message);
    return null;
  }

  @override
  Future<String> getToken() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    return _firebaseMessaging.getToken();
  }

}