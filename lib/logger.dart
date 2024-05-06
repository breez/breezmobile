library breez.logger;

import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:git_info/git_info.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final _log = Logger("Logger");

void shareLog() async {
  final appDir = await getApplicationDocumentsDirectory();
  final encoder = ZipFileEncoder();
  final zipFilePath = "${appDir.path}/breez.logs.zip";
  encoder.create(zipFilePath);
  encoder.addDirectory(Directory("${appDir.path}/logs/"));
  encoder.close();
  final zipFile = XFile(zipFilePath);
  Share.shareXFiles(
    [zipFile],
    text: getSystemAppLocalizations().share_log_text,
  );
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
    Logger.root.level = Level.ALL;
    if (kDebugMode) {
      Logger.root.onRecord.listen((LogRecord rec) {
        // Dart analyzer doesn't understand that here we are in debug mode so we have to use kDebugMode again
        if (kDebugMode) {
          print(_recordToString(rec));
        }
      });
    }

    getApplicationDocumentsDirectory().then((appDir) {
      _pruneLogs(appDir);
      final file = File("${_logDir(appDir)}/${DateTime.now().millisecondsSinceEpoch}.log");
      try {
        file.createSync(recursive: true);
      } catch (e) {
        _log.severe("Failed to create log file", e);
        return;
      }
      final sync = file.openWrite(mode: FileMode.append);
      Logger.root.onRecord.listen((record) {
        sync.writeln(_recordToString(record));
      }, onDone: () {
        sync.flush();
        sync.close();
      });
    });

    // Log flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details == null) {
        if (kDebugMode) {
          _log.warning("Ignore log, details is null");
        }
        return;
      }
      FlutterError.presentError(details);
      final name = details.context?.name ?? "FlutterError";
      final exception = details.exceptionAsString();
      _log.severe("$exception -- $name", details, details.stack);
    };

    GitInfo.get().then((it) {
      _log.info("Logging initialized, app build on ${it.branch} at commit ${it.hash}");
      DeviceInfoPlugin().deviceInfo.then((deviceInfo) {
        _log.info("Device info:");
        deviceInfo.data.forEach((key, value) => _log.info("$key: $value"));
      }, onError: (error) {
        _log.severe("Failed to get device info", error);
      });
    }, onError: (error) {
      _log.severe("Failed to get git info", error);
    });
  }

  String _recordToString(LogRecord record) =>
      "[${record.loggerName}] {${record.level.name}} (${_formatTime(record.time)}) : ${record.message}"
      "${record.error != null ? "\n${record.error}" : ""}"
      "${record.stackTrace != null ? "\n${record.stackTrace}" : ""}";

  String _formatTime(DateTime time) => time.toUtc().toIso8601String();

  String _logDir(Directory appDir) => "${appDir.path}/logs/";

  void _pruneLogs(Directory appDir) {
    final loggingFolder = Directory(_logDir(appDir));
    if (loggingFolder.existsSync()) {
      // Get and sort log files by modified date
      List<FileSystemEntity> filesToBePruned = loggingFolder
          .listSync(followLinks: false)
          .where((e) => e.path.endsWith('.log'))
          .toList()
        ..sort((l, r) => l.statSync().modified.compareTo(r.statSync().modified));
      // Delete all except last 10 logs
      if (filesToBePruned.length > 10) {
        filesToBePruned.removeRange(
          filesToBePruned.length - 10,
          filesToBePruned.length,
        );
        for (var logFile in filesToBePruned) {
          logFile.delete();
        }
      }
    }
  }
}

extension LogDescriptionOnList<T> on List<T> {
  String logDescription(String Function(T e) description) {
    return "[${fold("", (p, e) => p.isEmpty ? description(e) : "$p,${description(e)}")}]";
  }
}
