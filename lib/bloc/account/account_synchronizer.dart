import 'dart:async';
import 'dart:convert';

import 'package:breez/services/breezlib/breez_bridge.dart';

class AccountSynchronizer {
  static const IN_MEMORY_SYNC_RATE = 100;
  static const BOOTSTRAP_FILES_FRACTION = 0.7;

  final BreezBridge _breezLib;

  int _startPollTimestamp = 0;
  double _chainProgress;
  double _bootstrapProgress;
  Timer _lndWaitTimer;
  bool _started = false;
  bool _dismissed = false;

  final bool bootstraping;
  final Function(int startTimestamp, bool bootstraping) onStart;
  final Function(int startTimestamp, double progress) onProgress;
  final Function onComplete;

  AccountSynchronizer(this._breezLib,
      {this.onStart, this.onProgress, this.onComplete, this.bootstraping}) {
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

        _chainProgress = _calculateChainProgress(
            sincedToTimestamp, _isInitialSync(replyJson));

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

  void _emitProgress() {
    if (!_started) {
      onStart(_startPollTimestamp, _bootstrapProgress != null);
      _started = true;
    }

    onProgress(_startPollTimestamp, _chainProgress ?? 0.0);
  }

  double _calculateChainProgress(int sincedToTimestamp, bool initialSync) {
    double chainProgress = (sincedToTimestamp - _startPollTimestamp) /
        (DateTime.now().millisecondsSinceEpoch - _startPollTimestamp);
    return chainProgress;
  }

  bool _isInitialSync(Map<dynamic, dynamic> nodeInfo) {
    var totalChannels = nodeInfo["num_active_channels"] +
        nodeInfo["num_inactive_channels"] +
        nodeInfo["num_pending_channels"];
    return totalChannels == 0;
  }
}
