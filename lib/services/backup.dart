import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class BackupService {
  static const _methodChannel = const MethodChannel("com.breez.client/backup");
  static const _eventChannel = const EventChannel("com.breez.client/backup_stream");

  final StreamController<bool> _backupNotificationsController = new BehaviorSubject<bool>();
  Stream<bool> get backupNotifications => _backupNotificationsController.stream;

  BackupService(){
    _eventChannel.receiveBroadcastStream().listen((enabled) {
      print("Got backup notification");
      _backupNotificationsController.add(enabled);
    });
  }

  void authorize() async {
    return await _methodChannel.invokeMethod("authorize");
  }

  void backup(List<String> paths, String nodeId) async {
    return await _methodChannel.invokeMethod("backup", {"paths": paths, "nodeId": nodeId});
  }

  dynamic restore({String nodeId = ""}) async {
    return await _methodChannel.invokeMethod("restore", {"nodeId": nodeId});
  }
}
