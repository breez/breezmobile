import 'dart:async';

import 'package:breez/bloc/network/model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';

class NetworkBloc {
  final BreezBridge breezLib;

  const NetworkBloc(
    this.breezLib,
  );

  Stream<NodeStatus> nodeStatus() async* {
    yield NodeStatus.TESTING;

    final peers = await breezLib.getPeers();
    if (peers == null) {
      yield NodeStatus.NOT_CONNECTED;
      return;
    }

    final peerList = peers.peer;
    if (peerList == null || peerList.isEmpty) {
      yield NodeStatus.NOT_CONNECTED;
      return;
    }

    final url = peerList[0];
    final error = await _test(url);
    if (error != null) {
      yield NodeStatus.NOT_CONNECTED;
      yield* _retryNodeStatus(1, url);
      return;
    }

    yield NodeStatus.CONNECTED;
  }

  Stream<NodeStatus> _retryNodeStatus(int attempt, String url) async* {
    // Test again in 1 minute
    await Future.delayed(Duration(minutes: 1));

    if (attempt > 3) {
      yield NodeStatus.NOT_CONNECTED;
      return;
    }

    final error = await _test(url);
    if (error != null) {
      yield NodeStatus.NOT_CONNECTED;
      yield* _retryNodeStatus(attempt + 1, url);
      return;
    }

    yield NodeStatus.CONNECTED;
  }

  Future<String> _test(String url) async {
    try {
      return await breezLib
          .testPeer(url)
          .onError((error, stackTrace) => throw error);
    } catch (e) {
      return e;
    }
  }
}
