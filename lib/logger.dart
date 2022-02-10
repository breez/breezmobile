library breez.logger;

import 'dart:async';
import 'dart:io';

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:share_extend/share_extend.dart';

final Logger log = Logger('Breez');

Future<File> get _logFile async {
  var logPath = await ServiceInjector().breezBridge.getLogPath();
  return File(logPath);
}

void shareLog() {
  _logFile.then((file) {
    ShareExtend.share(file.path, "file");
  });
}

Future shareFile(String filePath) {
  return ShareExtend.share(filePath, "file");
}

class BreezLogger {
  BreezLogger() {
    BreezBridge breezBridge = ServiceInjector().breezBridge;
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      breezBridge.log(rec.message, rec.level.name);
      print(rec.message);
    });
    // Log flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (details != null && details.context != null)
        breezBridge.log(details.exceptionAsString() + '\n' + details.stack.toString(), details.context.name ?? "FlutterError");
        print(details.exceptionAsString() + '\n' + details.stack.toString() + " --" + details.context.name);
    };
  }
}
