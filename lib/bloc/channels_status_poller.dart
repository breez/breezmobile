import 'dart:async';

import 'package:breez/services/breezlib/data/rpc.pb.dart';

import '../logger.dart';
import 'account/account_actions.dart';
import 'async_action.dart';

class UnconfirmedChannelsStatusPoller {
  final Sink<AsyncAction> accountActions;
  final Function(double progress) onProgress;

  Timer _unconfirmedChannelsStatusTimer;
  UnconfirmedChannelsStatus initialStatus;
  UnconfirmedChannelsStatus lastStatus;

  UnconfirmedChannelsStatusPoller(this.accountActions, this.onProgress);

  start() async {
    try {
      _onNewUnconfirmedStatus(await _checkUnconfirmedChannelStatus());
    } catch (e) {
      log.severe("failed to query unconfimredChannelsStatus ${e.toString()}");
    }
    _unconfirmedChannelsStatusTimer =
        Timer.periodic(Duration(seconds: 10), (timer) async {
      var result = await _checkUnconfirmedChannelStatus();
      _onNewUnconfirmedStatus(result);
    });
  }

  Future<UnconfirmedChannelsStatus> _checkUnconfirmedChannelStatus() async {
    var action = UnconfirmedChannelsStatusAction(lastStatus);
    accountActions.add(action);
    return (await action.future) as UnconfirmedChannelsStatus;
  }

  _onNewUnconfirmedStatus(UnconfirmedChannelsStatus result) {
    if (initialStatus == null) {
      initialStatus = result;
    }
    lastStatus = result;

    if (result.statuses.length == 0) {
      onProgress(1.0);
      dispose();
      return;
    }

    if (result.statuses.length > 0) {
      var initialHint = _minUnconfirmed(initialStatus);
      var min = _minUnconfirmed(result);
      var max = _maxConfirmed(result);
      var progress = (min - initialHint) / (max - initialHint);
      onProgress(progress);
    }
  }

  double _minUnconfirmed(UnconfirmedChannelsStatus status) {
    double min = 0;
    if (status.statuses.length > 0) {
      status.statuses.forEach((status) {
        if (status.heightHint.toDouble() < min || min == 0) {
          min = status.heightHint.toDouble();
        }
      });
    }
    return min;
  }

  double _maxConfirmed(UnconfirmedChannelsStatus status) {
    double max = double.maxFinite;
    if (status.statuses.length > 0) {
      status.statuses.forEach((status) {
        if (status.lspConfirmedHeight.toDouble() > max ||
            max == double.maxFinite) {
          max = status.lspConfirmedHeight.toDouble();
        }
      });
    }
    return max;
  }

  void dispose() {
    _unconfirmedChannelsStatusTimer?.cancel();
  }
}
