import 'dart:async';
import 'dart:io';
import 'package:breez/logger.dart';

class ProgressDownloader {
  final StreamController<DownloadFileInfo> _progressController =
      new StreamController.broadcast();
  Stream<DownloadFileInfo> get progressStream => _progressController.stream;

  final String url;
  final String targetFilePath;

  ProgressDownloader(this.url, this.targetFilePath);

  void download() {
    final HttpClient client = new HttpClient();
    int byteCount = 0;    
    final fileSink = new File(targetFilePath).openWrite();
    var uri = Uri.parse(url);
    client.headUrl(uri).then((req) {
      req.headers.removeAll(HttpHeaders.acceptEncodingHeader);
      return req.close();
    }).then((resp) {
      int contentLength = resp.headers.contentLength;
      client.getUrl(uri).then((request) {
        return request.close();
      }).then((response) {
        response.listen((data) {
          byteCount += data.length;
          _progressController
              .add(new DownloadFileInfo(url, contentLength, byteCount));
          fileSink.add(data);
        }, onError: (e) {
          log.severe(e.toString());
          _progressController.add(e);
        }, onDone: () {
          fileSink
              .flush()
              .then((res) => fileSink.close())
              .then((res) => _progressController.close());
        });
      });
    });
  }
}

class DownloadFileInfo {
  final String fileURL;
  final int contentLength;
  final int bytesDownloaded;

  String get fileName => fileURL.split('/').last;

  DownloadFileInfo(this.fileURL, this.contentLength, this.bytesDownloaded);
}
