import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class DeepLinksService {
  static const SESSION_SECRET = "sessionSecret";
  static const _eventChannel = const EventChannel('com.breez.client/breez_deep_links_notifications');
  static const _methodChannel = const MethodChannel("com.breez.client/breez_deep_links");

  final StreamController<String> _linksNotificationsController = new BehaviorSubject<String>();
  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  DeepLinksService(){
    _eventChannel.receiveBroadcastStream().listen((data) { 
      print("Got notification");
      _linksNotificationsController.add(data); 
    });
  }

  String extractSessionSecretFromLink(String link) { 
    return Uri.parse(link).queryParameters["session"];    
  }

  Future<String> generateInviteLink(String sessionSecret) async {
    String link = await _methodChannel.invokeMethod("generateLink",{"query": 'session=$sessionSecret'});
    return link;
  }
}
