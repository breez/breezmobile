import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:anytime/entities/downloadable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/subjects.dart';

final _log = Logger("DownloadManager");

class DownloadStatus {
  final String id;
  final int percentage;
  final DownloadState status;

  DownloadStatus(this.id, this.percentage, this.status);
}

class DownloadTaskManager {
  final ReceivePort _port = ReceivePort();
  final downloadController = BehaviorSubject<DownloadStatus>();
  final List<String> _tasksToPoll = List.empty(growable: true);
  final finalTaskStatuses = <DownloadTaskStatus>[
    DownloadTaskStatus.canceled,
    DownloadTaskStatus.failed,
    DownloadTaskStatus.complete,
    DownloadTaskStatus.undefined
  ];
  Timer _downloadTimer;
  Stream<DownloadStatus> get downloadProgress => downloadController.stream;

  DownloadTaskManager() {
    _init();
  }

  Future _init() async {
    _log.info("GraphDownloader before Initialize");
    await FlutterDownloader.initialize(ignoreSsl: true, debug: true);
    _log.info("GraphDownloader after Initialize");

    bool success = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      final id = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus(data[1] as int);
      final progress = data[2] as int;

      _log.info("GraphDownloader2 callback $id, $status, $progress");
      _updateProgress(id, progress, status);
    });
    _log.info("GraphDownloader register success = $success");
    FlutterDownloader.registerCallback(downloadCallback);

    final allTasks = await loadTasks();
    for (var t in allTasks) {
      _tasksToPoll.add(t.taskId);
    }
    pollTasksStatus();
  }

  void pollTasksStatus() {
    _downloadTimer ??= Timer.periodic(const Duration(seconds: 3), (timer) async {
      var tasks = await loadTasks();
      final polledTasks = tasks.where((t) => _tasksToPoll.contains(t.taskId));
      for (var task in polledTasks) {
        _updateProgress(task.taskId, task.progress, task.status);
        if (finalTaskStatuses.contains(task.status)) {
          _tasksToPoll.remove(task.taskId);
        }
      }
      if (_tasksToPoll.isEmpty) {
        _downloadTimer?.cancel();
        _downloadTimer = null;
      }
    });
  }

  void _updateProgress(String taskID, int progress, DownloadTaskStatus status) {
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

    downloadController.add(DownloadStatus(taskID, progress, state));
  }

  Future<String> enqueTask(
    String url,
    String downloadPath,
    String fileName, {
    showNotification = false,
  }) async {
    final taskID = await FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadPath,
      fileName: fileName,
      showNotification: showNotification,
      openFileFromNotification: false,
    );
    _tasksToPoll.add(taskID);
    pollTasksStatus();
    return taskID;
  }

  Future<List<DownloadTask>> loadTasks() async {
    return await FlutterDownloader.loadTasks();
  }

  Future removeTask(String taskID, {shouldDeleteContent = true}) async {
    await FlutterDownloader.remove(taskId: taskID, shouldDeleteContent: shouldDeleteContent);
    _tasksToPoll.remove(taskID);
  }

  static void downloadCallback(String id, int status, int progress) {
    final send = IsolateNameServer.lookupPortByName('downloader_send_port');
    _log.info("GraphDownloader callback $id, $status, $progress");
    send.send([id, status, progress]);
  }
}
