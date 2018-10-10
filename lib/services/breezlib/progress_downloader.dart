import 'dart:async';
import 'dart:io';
import 'package:breez/logger.dart';

class ProgressDownloader {

  final StreamController<DownloadFileInfo> _progressController = new StreamController.broadcast();
  Stream<DownloadFileInfo> get progressStream => _progressController.stream;

  final String url;
  final String targetFilePath;

  ProgressDownloader(this.url, this.targetFilePath);

  void download() {    

    final HttpClient client = new HttpClient();
    int byteCount = 0;    
    //File targetFile =  new File(targetFilePath);
    final fileSink = new File(targetFilePath).openWrite();

    client.getUrl(Uri.parse(url))
      .then((request) => request.close())
      .then((response) {
        response.listen((data){
            byteCount += data.length;            
            _progressController.add(new DownloadFileInfo(url, response.contentLength, byteCount));
            //targetFile.writeAsBytesSync(data, mode: FileMode.append);
            fileSink.add(data);
          },
          onError: (e) {
            log.severe(e.toString());
            _progressController.add(e);
          },
          onDone:() {                          
              fileSink.flush()
                .then((res) => fileSink.close())
                .then((res) =>  _progressController.close());
              //fileSink.close();
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
