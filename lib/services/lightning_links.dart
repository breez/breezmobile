import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class LightningLinksService {
  static const _eventChannel = const EventChannel('com.breez.client/lightning_links_stream');
  static const _methodChannel = const MethodChannel("com.breez.client/lightning_links");

  final StreamController<String> _linksNotificationsController = new BehaviorSubject<String>();
  Stream<String> get linksNotifications => _linksNotificationsController.stream;

  DeepLinksService(){
    _eventChannel.receiveBroadcastStream().listen((data) {
      print("Got lightninglink");
      _linksNotificationsController.add(data);
    });
  }
}