import 'dart:async';
import 'dart:convert';

import 'package:breez/services/breezlib/breez_bridge.dart';

class AccountSynchronizer {
  final BreezBridge _breezLib;

  int _startPollTimestamp = 0;
  double _chainProgress = 0.0;
  bool _dismissed = false;

  final Function(int startTimestamp, double progress) onProgress;
  final Function onComplete;

  AccountSynchronizer(this._breezLib, {this.onProgress, this.onComplete}) {
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
  }

  void _pollSyncStatus() {
    new Timer(Duration(milliseconds: 2000), () {
      if (_dismissed) {
        return;
      }
      _breezLib.sendCommand("getinfo").then((info) {
        Map replyJson = json.decode(info);
        var sincedToTimestamp =
            int.parse(replyJson["best_header_timestamp"].toString()) * 1000;
        var syncedToChain = replyJson["synced_to_chain"].toString() == "true";

        if (_startPollTimestamp == 0 &&
            DateTime.now().millisecondsSinceEpoch - sincedToTimestamp > 0) {
          _startPollTimestamp = sincedToTimestamp;
        }
        if (_startPollTimestamp > sincedToTimestamp) {
          _startPollTimestamp = sincedToTimestamp;
        }
        
        _chainProgress = (sincedToTimestamp - _startPollTimestamp) /
            (DateTime.now().millisecondsSinceEpoch - _startPollTimestamp);

        if (_startPollTimestamp > 0) {
          _emitProgress();
        }

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

  void _emitProgress() {
    onProgress(_startPollTimestamp, _chainProgress);
  }
}
