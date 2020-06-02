import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:breez/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class GraphDownloader {
  static const graphURL =
      "https://bt2.breez.technology/mainnet/graph/graph-000c.db";
  final Function(String filePath) onDownloadSuccess;

  ReceivePort _port = ReceivePort();
  bool handlingFile = false;

  GraphDownloader(this.onDownloadSuccess);

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
      if (currentTask.url == graphURL) {
        await _onTaskFinished(currentTask);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future _onTaskFinished(DownloadTask currentTask) async {
    if (handlingFile) {
      return;
    }
    handlingFile = true;
    try {
      await FlutterDownloader.cancelAll();
      await onDownloadSuccess(
          currentTask.savedDir + Platform.pathSeparator + currentTask.filename);
    } catch (err) {
      handlingFile = false;
      log.severe("failed to sync graph from file ${err.toString()}");
    }

    var tasks = await FlutterDownloader.loadTasks();
    tasks.forEach((t) async {
      if (t.status == DownloadTaskStatus.canceled) {
        await FlutterDownloader.remove(
            taskId: t.taskId, shouldDeleteContent: true);
      }
    });
  }

  Future downloadGraph() async {
    var tasks = await FlutterDownloader.loadTasks();
    var runningStatuses = [
      DownloadTaskStatus.running,
      DownloadTaskStatus.enqueued
    ];

    var expiredTime = DateTime.now().millisecondsSinceEpoch - 24 * 3600 * 1000;
    for (var i = 0; i < tasks.length; ++i) {
      if (tasks[i].url == graphURL) {
        if (tasks[i].status == DownloadTaskStatus.complete &&
            tasks[i].timeCreated > expiredTime) {
          log.info(
              "Already has a recently completed graph download task, using it");
          _onTaskFinished(tasks[i]);
          return;
        }

        if (runningStatuses.indexOf(tasks[i].status) >= 0) {
          log.info(
              "Already has graph download task running, not starting another one");
          return;
        }
      }
    }

    log.info("Graph download started");
    var appDir = await getApplicationDocumentsDirectory();
    var downloadDirPath = appDir.path + Platform.pathSeparator + 'Download';
    var downloadDir = Directory(downloadDirPath);
    downloadDir.createSync(recursive: true);
    await FlutterDownloader.enqueue(
        url: graphURL,
        savedDir: downloadDir.path,
        fileName: "graph",
        showNotification: false,
        openFileFromNotification: false);
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
