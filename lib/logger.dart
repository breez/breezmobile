library breez.logger;

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fimber_io/fimber_io.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final _log = FimberLog("logger");

void shareLog() async {
  final appDir = await getApplicationDocumentsDirectory();
  final encoder = ZipFileEncoder();
  final zipFilePath = "${appDir.path}/breez.logs.zip";
  encoder.create(zipFilePath);
  encoder.addDirectory(Directory("${appDir.path}/logs/"));
  encoder.close();
  final zipFile = XFile(zipFilePath);
  Share.shareXFiles([zipFile]);
}

class BreezLogger {
  BreezLogger() {
    final logLevels = [
      "V", // log.v Verbose
      "D", // log.d Debug
      "I", // log.i Info
      "W", // log.w Warning
      "E", // log.e Error
    ];

    if (kDebugMode) {
      Fimber.plantTree(FimberTree(
        logLevels: logLevels,
      ));
    }

    getApplicationDocumentsDirectory().then(
          (appDir) {
        _pruneLogs(appDir);
        final tokens = [
          CustomFormatTree.timeStampToken,
          CustomFormatTree.levelToken,
          CustomFormatTree.tagToken,
          CustomFormatTree.messageToken,
          CustomFormatTree.fileNameToken,
          CustomFormatTree.lineNumberToken,
          CustomFormatTree.filePathToken,
          CustomFormatTree.exceptionMsgToken,
          CustomFormatTree.exceptionStackToken,
        ];
        Fimber.plantTree(
          SizeRollingFileTree(
            DataSize(megabytes: 10),
            filenamePrefix: "${appDir.path}/logs/breez.",
            filenamePostfix: ".log",
            logLevels: logLevels,
            logFormat: tokens.fold("", (p, e) => p == "" ? e : "$p :: $e"),
          ),
        );
        FlutterError.onError = (FlutterErrorDetails details) async {
          FlutterError.presentError(details);
          final name = details.context?.name ?? "FlutterError";
          final exception = details.exceptionAsString();
          _log.e("$exception --$name", ex: details, stacktrace: details.stack);
        };
      },
    );
  }
}

void _pruneLogs(Directory appDir) {
  final loggingFolder = Directory("${appDir.path}/logs/");
  if (loggingFolder.existsSync()) {
    // Get and sort log files by modified date
    List<FileSystemEntity> filesToBePruned = loggingFolder
        .listSync(followLinks: false)
        .where((e) => e.path.endsWith('.log'))
        .toList()
      ..sort((l, r) => l.statSync().modified.compareTo(r.statSync().modified));
    // Delete all except last 2 logs
    if (filesToBePruned.length > 2) {
      filesToBePruned.removeRange(
        filesToBePruned.length - 2,
        filesToBePruned.length,
      );
      for (var logFile in filesToBePruned) {
        logFile.delete();
      }
    }
  }
}

extension LogDescriptionOnList<T> on List<T> {
  String logDescription(String Function(T e) description) {
    return "[${fold("", (p, e) => p.isEmpty ? description(e) : "$p,${description(e)}")}]";
  }
}
