import 'dart:async';
import 'dart:convert';

import 'package:breez/services/breezlib/breez_bridge.dart';

class AccountSynchronizer {
  static const IN_MEMORY_SYNC_RATE = 100;

  final BreezBridge _breezLib;

  int _bestHeaderTimestamp;
  int _startFilterDownloadTimestamp;
  int _startPollTimestamp = 0;

  double _chainProgress;
  double _bootstrapProgress;

  bool _started = false;
  bool _dismissed = false;
  StreamSubscription _bootstrapSubscription;

  final bool bootstraping;
  final Function(int startTimestamp, bool bootstraping) onStart;
  final Function(double progress) onProgress;
  final Function onComplete;

  AccountSynchronizer(this._breezLib,
      {this.onStart, this.onProgress, this.onComplete, this.bootstraping}) {
    _listenBootstrapProgress();
    _pollSyncStatus();
  }

  void dismiss() {
    _dismissed = true;
    _bootstrapSubscription.cancel();
  }

  void _pollSyncStatus() {
    new Timer(Duration(seconds: 1), () {
      if (_dismissed) {
        return;
      }
      _breezLib.sendCommand("getinfo").then((info) {
        Map replyJson = json.decode(info);
        var sincedToTimestamp =
            int.parse(replyJson["best_header_timestamp"].toString()) * 1000;
        var syncedToChain = replyJson["synced_to_chain"].toString() == "true";
        var totalChannels = replyJson["num_active_channels"] +
            replyJson["num_inactive_channels"] +
            replyJson["num_pending_channels"];

        if (_startPollTimestamp == 0) {
          _startPollTimestamp = sincedToTimestamp;
        }

        _chainProgress =
            calculateChainProgress(sincedToTimestamp, totalChannels == 0);

        emitProgress();

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

  void emitProgress(){    
    if (!_started) {
      onStart(_startPollTimestamp, _bootstrapProgress > 0);
      _started = true;
    }

    var totalProgress = _chainProgress ?? 0.0;
    if (_bootstrapProgress != null) {
      totalProgress = (_bootstrapProgress * 0.1 + totalProgress * 0.9);
    }
    onProgress(totalProgress);
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
      _bootstrapProgress = downloadedContentLength / totalContentLength;  
      emitProgress();    
    }, onDone: (){
      print("on done");
    }, onError: (err){
      print("error " + err.toString());
    });
  }

  double calculateChainProgress(int sincedToTimestamp, bool initialSync) {
    double chainProgress = (sincedToTimestamp - _startPollTimestamp) /
        (DateTime.now().millisecondsSinceEpoch - _startPollTimestamp);

    // if in the last second we fetched more than 100 headers then we are synching only headers from memory, no filters.
    // we use this as a huristics for the progress estimator. We allocate 10% of the progress for headers only sync.
    if (_bestHeaderTimestamp != null && !initialSync) {
      print("download rate: " +
          ((sincedToTimestamp - _bestHeaderTimestamp) / 600000).toString());
      if (sincedToTimestamp - _bestHeaderTimestamp >
          IN_MEMORY_SYNC_RATE * 10 * 60 * 1000) {
        _startFilterDownloadTimestamp = null;
        chainProgress = chainProgress * 0.1;
      } else {
        if (_startFilterDownloadTimestamp == null) {
          _startFilterDownloadTimestamp = sincedToTimestamp;
        }
        if (_startFilterDownloadTimestamp != _startPollTimestamp) {
          chainProgress = 0.1 +
              (sincedToTimestamp - _startFilterDownloadTimestamp) /
                  (DateTime.now().millisecondsSinceEpoch -
                      _startFilterDownloadTimestamp) *
                  0.9;
        }
      }
    }
    _bestHeaderTimestamp = sincedToTimestamp;
    return chainProgress;
  }
}
