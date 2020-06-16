library breez.logger;

import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

final Logger log = Logger('Breez');

Future<File> get _logFile async {
  var logPath = await ServiceInjector().breezBridge.getLogPath();
  return File(logPath);
}

void shareLog() {
  _logFile.then((file) async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir = await tempDir.createTemp("logs");
    var encoder = ZipFileEncoder();
    var zipFile = '${tempDir.path}/log.zip';
    encoder.create(zipFile);
    encoder.addDirectory(file.parent);
    encoder.close();
    ShareExtend.share(zipFile, "file");
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
    });
  }
}
