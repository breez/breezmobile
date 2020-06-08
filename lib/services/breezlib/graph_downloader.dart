import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:breez/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class GraphDownloader {
  static const graphURLPrefix =
      "https://bt2.breez.technology/mainnet/graph/";

  ReceivePort _port = ReceivePort();
  bool handlingFile = false;
  Completer<File> _downloadCompleter;

  Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(debug: true);
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      log.info("Graph download completed id=$id status = $status");

      var tasks = await FlutterDownloader.loadTasks();
      var currentTask = tasks.firstWhere((t) => t.taskId == id);
       await _onTaskFinished(currentTask);
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future _onTaskFinished(DownloadTask currentTask) async {
    if (_downloadCompleter != null) {
      if (currentTask.status == DownloadTaskStatus.complete) {
        _downloadCompleter.complete(File(currentTask.savedDir + Platform.pathSeparator + currentTask.filename));
      } else {
        _downloadCompleter.completeError("graph sync failed");
      }
    }
  }

  Future<File> downloadGraph(String downloadURL) async {
    if (_downloadCompleter == null) {
      _downloadCompleter = Completer<File>();
    }

    var tasks = await FlutterDownloader.loadTasks();
    var runningStatuses = [
      DownloadTaskStatus.running,
      DownloadTaskStatus.enqueued
    ];

    var expiredTime = DateTime.now().millisecondsSinceEpoch - 24 * 3600 * 1000;
    for (var i = 0; i < tasks.length; ++i) {
      if (tasks[i].url == downloadURL) {
        if (tasks[i].status == DownloadTaskStatus.complete &&
            tasks[i].timeCreated > expiredTime) {
          log.info(
              "Already has a recently completed graph download task, using it");
          _onTaskFinished(tasks[i]);
          return _downloadCompleter.future;
        }

        if (runningStatuses.indexOf(tasks[i].status) >= 0) {
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
    FlutterDownloader.enqueue(
        url: downloadURL,
        savedDir: downloadDir.path,
        fileName: "graph",
        showNotification: false,
        openFileFromNotification: false);

    return _downloadCompleter.future;
  }

  Future deleteDownloads() async{
    var tasks = await FlutterDownloader.loadTasks();
    var finishedStatuses = [
      DownloadTaskStatus.complete,
      DownloadTaskStatus.canceled,
      DownloadTaskStatus.failed
    ];
    tasks.forEach((t) async {
      if (finishedStatuses.contains(t.status)) {
        await FlutterDownloader.remove(
            taskId: t.taskId, shouldDeleteContent: true);
      }
    });
    _downloadCompleter = null;
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) async {
    var finalStatuses = [
      DownloadTaskStatus.complete,
      DownloadTaskStatus.failed,
      DownloadTaskStatus.canceled
    ];
    if (finalStatuses.contains(status)) {
      final SendPort send =
          IsolateNameServer.lookupPortByName('downloader_send_port');
      if (send != null) {
        send.send([id, status]);
        return;
      }
      log.info("got downloadCallback and didn't find port for UI thread");
    }
  }
}
