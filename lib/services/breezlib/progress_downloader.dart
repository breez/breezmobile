import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class ProgressDownloader {
  final StreamController<DownloadFileInfo> _progressController =
      new StreamController.broadcast();
  Stream<DownloadFileInfo> get progressStream => _progressController.stream;  

  final String url;
  final String targetFilePath;

  ProgressDownloader(this.url, this.targetFilePath);

  void download() {

  final HttpClient client = new HttpClient();
  var uri = Uri.parse(url);
  client.headUrl(uri).then((req) {
      req.headers.removeAll(HttpHeaders.acceptEncodingHeader);
      return req.close();
    }).then((resp) {
      int contentLength = resp.headers.contentLength;    
      var dio = new Dio();
      dio.download(
        url,
        targetFilePath,
        onReceiveProgress: (received, total){
          _progressController
                  .add(new DownloadFileInfo(url, contentLength, received));
        })
        .then((_){
          _progressController.close();
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
