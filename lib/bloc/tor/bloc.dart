import 'dart:async';

import 'package:flutter/services.dart';

import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';

class TorBloc {
  static const platform = MethodChannel('com.breez.client/tor');
  TorConfig torConfig;
  // backgroundService?

  Future<TorConfig> startTor() async {
    log.info('TorBloc.startTor');
    try {
      final response = await platform.invokeMethod('startTorService');
      assert(response.isNotEmpty);
      log.info('TorBloc.startTor: startTorService returned!');

      if (response.isNotEmpty) {
        log.info('TorBloc.startTor: received response: $response');

        torConfig = TorConfig();

        var url = "wxyz://${response['Control']}".replaceAll('"', '');
        var port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.control = "$port";
        log.info('torBloc.startTor: torConfig.control: ${torConfig.control}');

        url = "socks://${response['SOCKS']}".replaceAll('"', '');
        port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.socks = "$port";
        log.info('torBloc.startTor: torConfig.socks: ${torConfig.socks}');

        url = "http://${response['HTTP']}".replaceAll('"', '');
        port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.http = "$port";
        log.info('torBloc.startTor: torConfig.http: ${torConfig.http}');

        log.info('TorBloc.startTor: tor has started with config : $torConfig');
      }
    } on PlatformException catch (e) {
      log.info('TorBloc.startTor failed: $e');
    }
    return torConfig;
  }
}
