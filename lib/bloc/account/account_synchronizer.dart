import 'dart:async';
import 'dart:convert';

import 'package:breez/services/breezlib/breez_bridge.dart';

class AccountSynchronizer {
  static const IN_MEMORY_SYNC_RATE = 100;

  final BreezBridge _breezLib;

  int _bestHeaderTimestamp;
  int _startFilterDownloadTimestamp;
  int _startPollTimestamp = 0;

  bool _started = false;
  bool _dismissed = false;
  final Function(int startTimestamp) onStart;
  final Function(double progress) onProgress;
  final Function onComplete;

  AccountSynchronizer(
      this._breezLib, {this.onStart, this.onProgress, this.onComplete}) {
    _pollSyncStatus();
  }

  void dismiss(){
    _dismissed = true;
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

        if (_startPollTimestamp == 0) {
          _startPollTimestamp = sincedToTimestamp;
        }

        double chainProgress = (sincedToTimestamp - _startPollTimestamp) /
            (DateTime.now().millisecondsSinceEpoch - _startPollTimestamp);

        // if in the last second we fetched more than 100 headers then we are synching only headers from memory, no filters.
        // we use this as a huristics for the progress estimator. We allocate 10% of the progress for headers only sync.
        if (_bestHeaderTimestamp != null) {
          print("download rate: " + ((sincedToTimestamp - _bestHeaderTimestamp) / 600000).toString());
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

        if (!_started) {
          onStart(_startPollTimestamp);
          _started = true;
        }

        onProgress(chainProgress);

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
}
