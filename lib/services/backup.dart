import 'package:flutter/services.dart';
import 'dart:async';

class BackupService {
  static const _methodChannel = const MethodChannel("com.breez.client/backup");

  Future<dynamic> backup(List<String> paths, String nodeId) {
    return _methodChannel.invokeMethod("backup", {"paths": paths, "nodeId": nodeId});
  }

  Future<dynamic> restore({String nodeId = ""}) {
    return _methodChannel.invokeMethod("restore", {"nodeId": nodeId});
  }
}
