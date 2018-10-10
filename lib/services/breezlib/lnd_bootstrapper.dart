import 'dart:async';
import 'dart:io';
import 'package:breez/services/breezlib/progress_downloader.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:breez/logger.dart';

class LNDBootstrapper {

  final StreamController<DownloadFileInfo> _bootstrapFilesProgress = new StreamController.broadcast();
  Stream<DownloadFileInfo> get bootstrapProgressStreams => _bootstrapFilesProgress.stream;

  Future downloadBootstrapFiles(String lndDir) async {
    String network = await _readNetwork();
    String tempDirPath = lndDir + "/temp";
    Directory tempDir = Directory(tempDirPath);
    String targetDirPath = lndDir + '/data/chain/bitcoin/$network/';
    Directory targetDir = Directory(targetDirPath);
    String urlPrefix = 'https://node01.breez.technology/$network';    

    List<String> allFiles = 
    [ 
      '$network/neutrino.db',
      '$network/block_headers.bin',
      '$network/reg_filter_headers.bin'
    ];
    Iterable<String> destinationFiles = allFiles.map((file) => targetDirPath + file.split('/').last);    
    
    targetDir.createSync(recursive: true);

    //if bootstrap files already exist
    if (destinationFiles.every((f) => File(f).existsSync())) {     
      _bootstrapFilesProgress.close();
      return Future.value(null);
    }

    //clean temp dir and target dir.
    destinationFiles.map((file) => File(file).deleteSync());
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
    tempDir.createSync(recursive: true);

    final response =
      await http.get('$urlPrefix/CURRENT');
    if (response.statusCode != 200) {
      log.severe("Error downloading CURRENT file");
      //_bootstrapFilesProgress.add(??);
      _bootstrapFilesProgress.close();
      return Future.value(null);
    }
    var currentDir = response.body.trim();
    Iterable<String> urls = allFiles.map((file) => urlPrefix + '/' + currentDir + '/' + file);

    //download and move all files to the destination directory on completion
    return _bootstrapFilesProgress.addStream(_startDownload(urls.toList(), tempDirPath))
    .then((res) {        
      tempDir.list().forEach((e) => e.renameSync(targetDirPath + e.path.split('/').last)).then((value) {
        tempDir.deleteSync(recursive: true);
        _bootstrapFilesProgress.close();
      });
    });   
  }

  Stream<DownloadFileInfo> _startDownload (List<String> urls, String destinationPath) {
    List<Stream<DownloadFileInfo>> allDownloadStreams = 
      urls
      .map((url) { 
        var downloader = new ProgressDownloader(url, destinationPath + "/" + url.split('/').last);
        downloader.download();
        return downloader.progressStream;
      }).toList();   
   return Observable.merge(allDownloadStreams);          
  }

  Future<String> _readNetwork() async{
    String defaultConfig = await rootBundle.loadString('conf/breez.conf');
    var lines = defaultConfig.replaceAll("\r\n", "\n").split("\n");
    for (var i = 0; i < lines.length; ++i) {      
      if (lines[i].contains("network=")) {
        return lines[i].split("=")[1];
      }
    }
    return null;
  }
}