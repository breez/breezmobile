library breez.logger;

import 'dart:async';
import 'dart:io';

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

final Logger log = Logger('Breez');

Future<File> get _logFile async {
  var logPath = await ServiceInjector().breezBridge.getLogPath();
  return File(logPath);
}

void shareLog() {
  _logFile.then((file) {
    final logFile = XFile(file.path);
    Share.shareXFiles(
      [logFile],
      text: getSystemAppLocalizations().share_log_text,
    );
  });
}

Future shareFile(String filePath) {
  final file = XFile(filePath);
  return Share.shareXFiles(
    [file],
    text: getSystemAppLocalizations().share_file_title,
  );
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
      if (details == null) {
        print("Ignore log, details is null");
        return;
      }
      FlutterError.presentError(details);
      final stack = details.stack?.toString() ?? "NoStack";
      final name = details.context?.name ?? "FlutterError";
      final exception = details.exceptionAsString();
      breezBridge.log('$exception\n$stack', name);
      print("$exception\n$stack --$name");
    };
  }
}

extension LogDescriptionOnList<T> on List<T> {
  String logDescription(String Function(T e) description) {
    return "[${fold("", (p, e) => p.isEmpty ? description(e) : "$p,${description(e)}")}]";
  }
}
