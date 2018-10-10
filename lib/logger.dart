library breez.logger;

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

final Logger log = new Logger('Breez');
const _platform = const MethodChannel('com.breez.client/share_breez_log');

Future<File> get _logFile async {
  var logPath = await ServiceInjector().breezBridge.getLogPath();
  return File(logPath);
}

void shareLog() {
  _logFile.then((file) {
    _platform.invokeMethod("shareLog", {'path': file.path});
  });
}

class BreezLogger {
  BreezLogger() {
    BreezBridge breezBridge = ServiceInjector().breezBridge;
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      breezBridge.log(rec.message, rec.level.name);      
    });
  }
}
