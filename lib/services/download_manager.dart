import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:anytime/entities/downloadable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:rxdart/subjects.dart';
import 'package:breez/logger.dart';

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
    print("GraphDownloader before Initialize");
    log.info("GraphDownloader before Initialize");
    await FlutterDownloader.initialize(ignoreSsl: true, debug: true);
    print("GraphDownloader after Initialize");
    log.info("GraphDownloader after Initialize");

    bool success = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');    
    _port.listen((dynamic data) {
      final id = data[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;
      
      print("GraphDownloader2 callback $id, $status, $progress");
      log.info("GraphDownloader2 callback $id, $status, $progress");
      _updateProgress(id, progress, status);      
    });
    log.info("GraphDownloader register success = $success");
    FlutterDownloader.registerCallback(downloadCallback);

    final allTasks = await loadTasks();
    allTasks.forEach((t) {
      _tasksToPoll.add(t.taskId);
    });
    pollTasksStatus();
  }

  void pollTasksStatus() {
    if (_downloadTimer == null) {
      _downloadTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
        var tasks = await loadTasks();
        final polledTasks = tasks.where((t) => _tasksToPoll.contains(t.taskId));
        polledTasks.forEach((task) {
          _updateProgress(task.taskId, task.progress, task.status);
          if (finalTaskStatuses.contains(task.status)) {        
            _tasksToPoll.remove(task.taskId);
          }
        });
        if (_tasksToPoll.isEmpty){
          _downloadTimer?.cancel();
          _downloadTimer = null;
        }
      });
    }
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


  Future<String> enqueTask(String url, String downloadPath, String fileName,
      {showNotification = false}) async {
    final taskID =  await FlutterDownloader.enqueue(
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

  Future removeTask(String taskID, {shouldDeleteContent: true}) async {
    await FlutterDownloader.remove(
        taskId: taskID, shouldDeleteContent: shouldDeleteContent);
    _tasksToPoll.remove(taskID);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName('downloader_send_port');
    print("GraphDownloader callback $id, $status, $progress");
    log.info("GraphDownloader callback $id, $status, $progress");
    send.send([id, status, progress]);
  }
}
