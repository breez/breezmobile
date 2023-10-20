import 'dart:async';

import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

final _log = Logger("TorBloc");

class TorBloc {
  static const platform = MethodChannel('com.breez.client/tor');
  TorConfig torConfig;
  // backgroundService?

  Future<TorConfig> startTor() async {
    _log.info('TorBloc.startTor');
    try {
      final response = await platform.invokeMethod('startTorService');
      assert(response.isNotEmpty);
      _log.info('TorBloc.startTor: startTorService returned!');

      if (response.isNotEmpty) {
        _log.info('TorBloc.startTor: received response: $response');

        torConfig = TorConfig();

        var url = "wxyz://${response['Control']}".replaceAll('"', '');
        var port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.control = "$port";
        _log.info('torBloc.startTor: torConfig.control: ${torConfig.control}');

        url = "socks://${response['SOCKS']}".replaceAll('"', '');
        port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.socks = "$port";
        _log.info('torBloc.startTor: torConfig.socks: ${torConfig.socks}');

        url = "http://${response['HTTP']}".replaceAll('"', '');
        port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.http = "$port";
        _log.info('torBloc.startTor: torConfig.http: ${torConfig.http}');

        _log.info('TorBloc.startTor: tor has started with config : $torConfig');
      }
    } on PlatformException catch (e) {
      _log.info('TorBloc.startTor failed: $e');
    }
    return torConfig;
  }
}
