import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void setUpLogger() {
  Logger.root.level = Level.ALL;

  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      // Dart analyzer doesn't understand that here we are in debug mode so we have to use kDebugMode again
      if (kDebugMode) {
        debugPrint("[${record.loggerName}] {${record.level.name}} (${record.time}) : ${record.message}");
      }
    });
  }
}
