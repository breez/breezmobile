import 'dart:async';
import 'package:flutter/services.dart';

enum NotificationType {
  RESUME
}

class Device {
  static const EventChannel _notificationsChannel = const EventChannel('com.breez.client/lifecycle_events_notifications');

  final StreamController _eventsController = new StreamController<NotificationType>.broadcast();
  Stream get eventStream => _eventsController.stream;

  final StreamController _deviceClipboardController = new StreamController<String>.broadcast();
  Stream get deviceClipboardStream => _deviceClipboardController.stream;

  Device(){
    _notificationsChannel.receiveBroadcastStream().listen((event){
      if (event == "resume") {
        _eventsController.sink.add(NotificationType.RESUME);

        Clipboard.getData("text/plain").then((clipboardData) {
          var text = clipboardData.text;
          if (text.startsWith("lightning:")) {
            _deviceClipboardController.add(text.substring(10));
          }
        });
      }
    });
  } 
}
