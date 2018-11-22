import 'package:flutter/services.dart';

class BackupService {
  static const _methodChannel = const MethodChannel("com.breez.client/backup");

  void authorize() async {
    return await _methodChannel.invokeMethod("authorize");
  }

  void backup(List<String> paths, String nodeId) async {
    return await _methodChannel.invokeMethod("backup", {"paths": paths, "nodeId": nodeId});
  }

  void restore() async {
    return await _methodChannel.invokeMethod("restore");
  }
}
