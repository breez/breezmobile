import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';

final _log = FimberLog("TorBloc");

class TorBloc {
  static const platform = MethodChannel('com.breez.client/tor');
  TorConfig torConfig;

  Future<TorConfig> startTor() async {
    _log.v("TorBloc.startTor");
    try {
      final response = await platform.invokeMethod('startTorService');
      assert(response.isNotEmpty);
      _log.v("TorBloc.startTor: startTorService returned!");

      if (response.isNotEmpty) {
        _log.v("TorBloc.startTor: received response: $response");

        torConfig = TorConfig();

        var url = "wxyz://${response['Control']}".replaceAll('"', '');
        var port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.control = "$port";
        _log.v("torBloc.startTor: torConfig.control: ${torConfig.control}");

        url = "socks://${response['SOCKS']}".replaceAll('"', '');
        port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.socks = "$port";
        _log.v("torBloc.startTor: torConfig.socks: ${torConfig.socks}");

        url = "http://${response['HTTP']}".replaceAll('"', '');
        port = Uri.parse(url).port;
        assert(port > 0);
        torConfig.http = "$port";
        _log.v("torBloc.startTor: torConfig.http: ${torConfig.http}");

        _log.v("TorBloc.startTor: tor has started with config : $torConfig");
      }
    } on PlatformException catch (e) {
      _log.e("TorBloc.startTor failed: $e", ex: e);
    }

    return torConfig;
  }
}
