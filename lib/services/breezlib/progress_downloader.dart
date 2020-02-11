import 'dart:async';
import 'dart:io';
import 'package:breez/logger.dart';

class ProgressDownloader {
  final StreamController<DownloadFileInfo> _progressController =
      new StreamController.broadcast();
  Stream<DownloadFileInfo> get progressStream => _progressController.stream;
  StreamSubscription<List<int>> responseListener;

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
        int eventIndex = 0;
        responseListener = response.listen((data) {
          byteCount += data.length;                 
          fileSink.add(data);                    
          if (eventIndex++ % 10 ==0 || contentLength == byteCount) {
            _progressController
                .add(new DownloadFileInfo(url, contentLength, byteCount));            
          }         
        }, onError: (e) {
          log.severe("error in downloading, retrying..." + e.toString());          
          responseListener.cancel();          
          download();
        }, onDone: () {
          if (byteCount == contentLength) {          
            print("done got in downloading");
            fileSink
                .flush()
                .then((res) => fileSink.close())              
                .then((res) => _progressController.close());
          }
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
