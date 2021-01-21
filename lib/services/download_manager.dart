import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:anytime/entities/downloadable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:rxdart/subjects.dart';

class DownloadStatus {
  final String id;
  final int percentage;
  final DownloadState status;

  DownloadStatus(this.id, this.percentage, this.status);
}

class DownloadTaskManager {
  final ReceivePort _port = ReceivePort();
  final downloadController = BehaviorSubject<DownloadStatus>();
  Stream<DownloadStatus> get downloadProgress => downloadController.stream;

  DownloadTaskManager() {
    _init();
  }

  Future _init() async {
    await FlutterDownloader.initialize();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      final id = data[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      var state = DownloadState.none;

      if (status == DownloadTaskStatus.enqueued) {
        state = DownloadState.queued;
      } else if (status == DownloadTaskStatus.canceled) {
        state = DownloadState.cancelled;
      } else if (status == DownloadTaskStatus.complete) {
        state = DownloadState.downloaded;
      } else if (status == DownloadTaskStatus.running) {
        state = DownloadState.downloading;
      } else if (status == DownloadTaskStatus.failed) {
        state = DownloadState.failed;
      } else if (status == DownloadTaskStatus.paused) {
        state = DownloadState.paused;
      }

      downloadController.add(DownloadStatus(id, progress, state));
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future<String> enqueTask(String url, String downloadPath, String fileName,
      {showNotification = false}) async {
    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadPath,
      fileName: fileName,
      showNotification: showNotification,
      openFileFromNotification: false,
    );
  }

  Future<List<DownloadTask>> loadTasks() async {
    return await FlutterDownloader.loadTasks();
  }

  Future removeTask(String taskID, {shouldDeleteContent: true}) async {
    return await FlutterDownloader.remove(
        taskId: taskID, shouldDeleteContent: shouldDeleteContent);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName('downloader_send_port');

    send.send([id, status, progress]);
  }
}
