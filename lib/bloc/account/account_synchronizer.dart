import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:breez/services/breezlib/breez_bridge.dart';

class AccountSynchronizer {
  final BreezBridge _breezLib;

  int _startPollTimestamp = 0;
  double _bootstrapProgress = 0.0;
  double _chainProgress = 0.0;
  double _openChannelProgress = 0.0;
  bool _dismissed = false;
  bool bootstrap = false;

  final Function(int startTimestamp, double progress, bool syncedToChain,
      bool isBootstrap) onProgress;
  final Function onComplete;

  AccountSynchronizer(this._breezLib, {this.onProgress, this.onComplete}) {
    _pollSyncStatus();
    _breezLib.lastSyncedHeaderTimestamp().then((timestamp) {
      if (timestamp > 0) {
        bootstrap = false;
        _startPollTimestamp = timestamp * 1000;
        _emitProgress();
      } else {
        bootstrap = true;
        _pollBootstrap();
      }
    });
  }

  void dismiss() {
    _dismissed = true;
  }

  void _pollBootstrap() {
    Timer(Duration(seconds: 1), () {
      _bootstrapProgress = min(_bootstrapProgress + 0.1, 1.0);
      _emitProgress();
      if (_startPollTimestamp == 0 && _bootstrapProgress < 1.0) {
        _pollBootstrap();
      } else {
        _bootstrapProgress = 1.0;
      }
    });
  }

  void _pollSyncStatus() {
    Timer(Duration(seconds: 1), () {
      if (_dismissed) {
        return;
      }
      _breezLib.sendCommand("getinfo").then((info) {
        Map replyJson = json.decode(info);
        var syncedToTimestamp =
            int.parse(replyJson["best_header_timestamp"].toString()) * 1000;
        var syncedToChain = replyJson["synced_to_chain"].toString() == "true";

        if (_startPollTimestamp == 0 &&
            DateTime.now().millisecondsSinceEpoch - syncedToTimestamp > 0) {
          _startPollTimestamp = syncedToTimestamp;
        }
        if (_startPollTimestamp > syncedToTimestamp) {
          _startPollTimestamp = syncedToTimestamp;
        }

        if (_startPollTimestamp > 0) {
          if (syncedToChain) {
            _chainProgress = 1.0;
          } else if (_chainProgress < 1.0) {
            _chainProgress = (syncedToTimestamp - _startPollTimestamp) /
                (DateTime.now().millisecondsSinceEpoch - _startPollTimestamp);
          }
          _emitProgress();
        }

        int numChannels = replyJson["num_pending_channels"] +
            replyJson["num_active_channels"] +
            replyJson["num_inactive_channels"];
        bool hasChannel = numChannels > 0;
        if (syncedToChain) {
          if (!bootstrap || hasChannel || _openChannelProgress == 1.0) {
            onComplete();
            return;
          }
          _openChannelProgress = min(_openChannelProgress + 0.1, 1.0);
        }
        _pollSyncStatus();
      }).catchError((err) {
        _pollSyncStatus();
      });
    });
  }

  void _emitProgress() {
    double progress = _chainProgress;
    if (bootstrap) {
      progress = _bootstrapProgress * 0.7 +
          _chainProgress * 0.2 +
          _openChannelProgress * 0.1;
    }
    onProgress(_startPollTimestamp, progress, _chainProgress == 1.0, bootstrap);
  }
}
