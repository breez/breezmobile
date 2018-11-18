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

  SessionLinkModel parseSessionInviteLink(String link) {     
    return SessionLinkModel.fromLinkQuery( Uri.parse(link).query);
  }

  Future<String> generateSessionInviteLink(SessionLinkModel link) async {
    return await _methodChannel.invokeMethod("generateLink",{"query": link.toLinkQuery()});    
  }
}

class SessionLinkModel {
  final String sessionID;
  final String sessionSecret;
  final String initiatorPubKey;

  SessionLinkModel(this.sessionID, this.sessionSecret, this.initiatorPubKey);

  String toLinkQuery(){
    return 'sessionID=$sessionID&sessionSecret=$sessionSecret&pubKey=$initiatorPubKey';
  }

  static SessionLinkModel fromLinkQuery(String queryStr) {       
    Map<String, String> query = Uri.splitQueryString(queryStr); 
    return SessionLinkModel(query["sessionID"], query["sessionSecret"], query["pubKey"]);
  }
}
