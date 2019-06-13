library breez.logger;

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

import 'package:share_extend/share_extend.dart';

final Logger log = new Logger('Breez');
const _platform = const MethodChannel('com.breez.client/share_breez_log');

Future<File> get _logFile async {
  var logPath = await ServiceInjector().breezBridge.getLogPath();
  return File(logPath);
}

void shareLog() {
  _logFile.then((file) {
    ShareExtend.share(file.path, "file");    
  });
}

Future shareFile(String filePath){
  return ShareExtend.share(filePath, "file");  
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
