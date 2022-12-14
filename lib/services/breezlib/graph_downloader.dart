import 'dart:async';
import 'dart:io';

import 'package:breez/logger.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../download_manager.dart';

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
    Timer.periodic(Duration(seconds: 10), (timer) async {
      var tasks = await downloadManager.loadTasks();
      tasks.forEach((currentTask) {
        var f = File(currentTask.savedDir +
            Platform.pathSeparator +
            currentTask.filename);

      log.info("GraphDownloader periodic file exists: ${f.existsSync()}");
      log.info("GraphDownloader periodic task: progress=${currentTask.progress}, status=${currentTask.status}, id=${currentTask.taskId}");
      });
    });
    downloadManager.downloadProgress.listen((event) async {
      log.info("GraphDownloader event: ${event.id}");
      log.info("GraphDownloader event: ${event.status}");
      log.info("GraphDownloader event: ${event.percentage}");      
      var tasks = await downloadManager.loadTasks();
      var downloadURL = (await preferences).getString("graph_url");
      var currentTask = tasks.firstWhere(
          (t) => t.url == downloadURL && t.taskId == event.id,
          orElse: () => null);
      log.info("GraphDownloader task status = ${currentTask.status}");
      var f = File(currentTask.savedDir +
            Platform.pathSeparator +
            currentTask.filename);

      log.info("GraphDownloadern file exists: ${f.existsSync()}");
      if (currentTask != null &&
          finalTaskStatuses.contains(currentTask.status)) {
        await _onTaskFinished(currentTask);
      }
    });    
  }

  Future _onTaskFinished(DownloadTask currentTask) async {
    if (_downloadCompleter != null) {
      if (currentTask.status == DownloadTaskStatus.complete) {
        _downloadCompleter.complete(File(currentTask.savedDir +
            Platform.pathSeparator +
            currentTask.filename));
      } else {
        _downloadCompleter.completeError("graph sync failed");
      }
    }
  }

  Future<File> downloadGraph(String downloadURL) async {   
    if (_downloadCompleter == null) {
      _downloadCompleter = Completer<File>();
    }
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
          log.info("removing enqueued download graph task");
          downloadManager.removeTask(tasks[i].taskId);
          continue;
        }

        if (tasks[i].status == DownloadTaskStatus.complete) {
          log.info(
              "Already has a recently completed graph download task, using it");
          _onTaskFinished(tasks[i]);
          return _downloadCompleter.future;
        }

        if (tasks[i].status == DownloadTaskStatus.running) {
          log.info(
              "Already has graph download task running, not starting another one");
          return _downloadCompleter.future;
        }
      }
    }

    log.info("Graph download started");
    var appDir = await getApplicationDocumentsDirectory();
    var downloadDirPath = appDir.path + Platform.pathSeparator + 'Download';
    var downloadDir = Directory(downloadDirPath);
    downloadDir.createSync(recursive: true);
    downloadManager.enqueTask(downloadURL, downloadDir.path, "channel.db");

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
    tasks.forEach((t) async {
      if (t.url == graphURL && finishedStatuses.contains(t.status)) {
        await downloadManager.removeTask(t.taskId, shouldDeleteContent: true);
      }
    });
    _downloadCompleter = null;
  }
}
