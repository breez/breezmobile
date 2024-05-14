import 'dart:async';
import 'dart:io';

import 'package:breez/services/download_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _log = Logger("GraphDownloader");

class GraphDownloader {
  final DownloadTaskManager downloadManager;
  final Future<SharedPreferences> preferences;
  final finalTaskStatuses = <DownloadTaskStatus>[
    DownloadTaskStatus.canceled,
    DownloadTaskStatus.failed,
    DownloadTaskStatus.complete,
    DownloadTaskStatus.undefined
  ];
  bool handlingFile = false;
  Completer<File> _downloadCompleter;

  GraphDownloader(this.downloadManager, this.preferences);

  Future init() async {
    downloadManager.downloadProgress.listen((event) async {
      _log.info("GraphDownloader event: ${event.id}");
      _log.info("GraphDownloader event: ${event.status}");
      _log.info("GraphDownloader event: ${event.percentage}");
      var tasks = await downloadManager.loadTasks();
      var downloadURL = (await preferences).getString("graph_url");
      var currentTask =
          tasks.firstWhere((t) => t.url == downloadURL && t.taskId == event.id, orElse: () => null);
      if (currentTask != null && finalTaskStatuses.contains(currentTask.status)) {
        _log.info("GraphDownloader task status = ${currentTask.status}");
        await _onTaskFinished(currentTask);
      }
    });
  }

  Future _onTaskFinished(DownloadTask currentTask) async {
    if (_downloadCompleter != null) {
      if (currentTask.status == DownloadTaskStatus.complete) {
        _downloadCompleter
            .complete(File(currentTask.savedDir + Platform.pathSeparator + currentTask.filename));
      } else {
        _downloadCompleter.completeError("graph sync failed");
      }
    }
  }

  Future<File> downloadGraph(String downloadURL) async {
    _downloadCompleter ??= Completer<File>();
    (await preferences).setString("graph_url", downloadURL);

    var tasks = await downloadManager.loadTasks();

    var expiredTime = DateTime.now().millisecondsSinceEpoch - 24 * 3600 * 1000;
    for (var i = 0; i < tasks.length; ++i) {
      if (tasks[i].url == downloadURL) {
        if (tasks[i].timeCreated < expiredTime) {
          downloadManager.removeTask(tasks[i].taskId);
          continue;
        }

        if (tasks[i].status == DownloadTaskStatus.enqueued) {
          _log.info("removing enqueued download graph task");
          downloadManager.removeTask(tasks[i].taskId);
          continue;
        }

        if (tasks[i].status == DownloadTaskStatus.complete) {
          _log.info("Already has a recently completed graph download task, using it");
          _onTaskFinished(tasks[i]);
          return _downloadCompleter.future;
        }

        if (tasks[i].status == DownloadTaskStatus.running) {
          _log.info("Already has graph download task running, not starting another one");
          return _downloadCompleter.future;
        }
      }
    }

    _log.info("Graph download started");
    var appDir = await getApplicationDocumentsDirectory();
    var downloadDirPath = '${appDir.path}${Platform.pathSeparator}Download';
    var downloadDir = Directory(downloadDirPath);
    downloadDir.createSync(recursive: true);
    await downloadManager.enqueTask(downloadURL, downloadDir.path, "channel.db");
    return _downloadCompleter.future;
  }

  Future deleteDownloads() async {
    var tasks = await downloadManager.loadTasks();
    var finishedStatuses = [
      DownloadTaskStatus.complete,
      DownloadTaskStatus.canceled,
      DownloadTaskStatus.failed
    ];
    var graphURL = (await preferences).getString("graph_url");
    for (var t in tasks) {
      if (t.url == graphURL && finishedStatuses.contains(t.status)) {
        await downloadManager.removeTask(t.taskId, shouldDeleteContent: true);
      }
    }
    _downloadCompleter = null;
  }

  Future deleteAllDownloads() async {
    var tasks = await downloadManager.loadTasks();
    for (var t in tasks) {
      await downloadManager.removeTask(t.taskId, shouldDeleteContent: true);
    }
    _downloadCompleter = null;
  }
}
