import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:breez/services/breezlib/breez_bridge.dart';

class AccountSynchronizer {
  static const IN_MEMORY_SYNC_RATE = 100;
  static const BOOTSTRAP_FILES_FRACTION = 0.7;

  final BreezBridge _breezLib;

  int _previousSyncTimestamp;
  int _startFilterDownloadTimestamp;
  int _startPollTimestamp = 0;

  double _chainProgress;
  double _bootstrapProgress;  
  Timer _lndWaitTimer;

  bool _started = false;
  bool _dismissed = false;
  StreamSubscription _bootstrapSubscription;

  final bool bootstraping;
  final Function(int startTimestamp, bool bootstraping) onStart;
  final Function(int startTimestamp, double progress) onProgress;
  final Function onComplete;

  AccountSynchronizer(this._breezLib,
      {this.onStart, this.onProgress, this.onComplete, this.bootstraping}) {
    _listenBootstrapProgress();
    _pollSyncStatus();
    _breezLib.lastSyncedHeaderTimestamp().then((timestamp) {
      if (timestamp > 0) {
        _startPollTimestamp = timestamp * 1000;      
        _emitProgress();
      }
    });
  }

  void dismiss() {
    _dismissed = true;
    _bootstrapSubscription.cancel();
  }

  void _listenBootstrapProgress() {
    _bootstrapSubscription =
        _breezLib.chainBootstrapProgress.listen((fileInfo) {
      double totalContentLength = 0;
      double downloadedContentLength = 0;
      fileInfo.forEach((s, f) {
        totalContentLength += f.contentLength;
        downloadedContentLength += f.bytesDownloaded;
      });
      var downloadProgress = downloadedContentLength / totalContentLength;      
      if (downloadProgress == 1.0 && _lndWaitTimer == null) {        
        _lndWaitTimer = Timer.periodic(Duration(seconds: 3), (t){
          _bootstrapProgress = min(_bootstrapProgress +  0.02, 1.0);
          _emitProgress();
        });
      }
      _bootstrapProgress = 0.6 * downloadProgress;  
      _emitProgress();    
    }, onDone: (){
      print("on done");
    }, onError: (err){
      print("error " + err.toString());
    });
  }

  void _pollSyncStatus() {
    new Timer(Duration(milliseconds: 2000), () {
      if (_dismissed) {
        return;
      }
      _breezLib.sendCommand("getinfo").then((info) {
        if (_lndWaitTimer != null && _lndWaitTimer.isActive) {
          _lndWaitTimer.cancel();
          _lndWaitTimer = null;
          _bootstrapProgress = 1.0;
        }

        Map replyJson = json.decode(info);
        var sincedToTimestamp =
            int.parse(replyJson["best_header_timestamp"].toString()) * 1000;
        var syncedToChain = replyJson["synced_to_chain"].toString() == "true";

        if (_startPollTimestamp == 0) {
          _startPollTimestamp = sincedToTimestamp;
        }
        if (_startPollTimestamp > sincedToTimestamp) {
          _startPollTimestamp = sincedToTimestamp;
        }

        _chainProgress =
            _calculateChainProgress(sincedToTimestamp, _isInitialSync(replyJson));

        _emitProgress();

        if (syncedToChain) {
          onComplete();
          return;
        }
        _pollSyncStatus();
      }).catchError((err) {
        _pollSyncStatus();
      });
    });
  }

  void _emitProgress(){    
    if (!_started) {
      onStart(_startPollTimestamp, _bootstrapProgress != null);
      _started = true;
    }

    var totalProgress = _chainProgress ?? 0.0;
    if (_bootstrapProgress != null) {
      totalProgress = (_bootstrapProgress * BOOTSTRAP_FILES_FRACTION + totalProgress * (1- BOOTSTRAP_FILES_FRACTION));
    }
    onProgress(_startPollTimestamp, totalProgress);
  }

  DateTime _lastChainCalcChangeTime;
  double _calculateChainProgress(int sincedToTimestamp, bool initialSync) {

    //naive chain progress
    double chainProgress = (sincedToTimestamp - _startPollTimestamp) /
        (DateTime.now().millisecondsSinceEpoch - _startPollTimestamp);

    // if in the last second we fetched more than 100 headers then we are synching only headers from memory, no filters.
    // we use this as a huristics for the progress estimator. We allocate 10% of the progress for headers only sync.
    if (_previousSyncTimestamp != null  && _lastChainCalcChangeTime != null) {    

      // calculate download rate
      Duration lastChangeDuration = DateTime.now().difference(_lastChainCalcChangeTime);
      var downloadRatePerSecond = (sincedToTimestamp - _previousSyncTimestamp) / lastChangeDuration.inSeconds;

      // if the download rate is more than 1000 per second then we are surely 
      // only going over db headers. no networking yet.
      if (downloadRatePerSecond > 1000) {      
        _startFilterDownloadTimestamp = null;
        chainProgress = chainProgress * 0.1;
      } else {

        // if we haven't set the filter download timestamp, let's set it now.
        // it represents the timestamp the heavy sync begins, therefore we will 
        // give higher percentage weight.
        if (_startFilterDownloadTimestamp == null) {
          _startFilterDownloadTimestamp = sincedToTimestamp;
        }
        chainProgress = 0.1 + 0.9 *(
          (sincedToTimestamp - _startFilterDownloadTimestamp) /
                  (DateTime.now().millisecondsSinceEpoch -
                      _startFilterDownloadTimestamp)
        );          
      }
    }

    _previousSyncTimestamp = sincedToTimestamp;
    return chainProgress;
  }

  bool _isInitialSync(Map<dynamic, dynamic> nodeInfo){
    var totalChannels = nodeInfo["num_active_channels"] +
            nodeInfo["num_inactive_channels"] +
            nodeInfo["num_pending_channels"];
    return totalChannels == 0;
  }
}
