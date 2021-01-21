import 'dart:async';

import 'package:anytime/services/download/download_manager.dart';
import 'package:breez/services/injector.dart';

class AnytimeDownloadManager implements DownloadManager {
  final statusController = StreamController<DownloadProgress>();
  final downloadManager = ServiceInjector().downloadManager;

  AnytimeDownloadManager() {
    downloadManager.downloadProgress
        .map((e) => DownloadProgress(e.id, e.percentage, e.status))
        .pipe(statusController);
  }
  @override
  void dispose() {
    statusController.close();
  }

  @override
  Stream<DownloadProgress> get downloadProgress => statusController.stream;

  @override
  Future<String> enqueTask(String url, String downloadPath, String fileName) {
    return downloadManager.enqueTask(url, downloadPath, fileName);
  }
}
