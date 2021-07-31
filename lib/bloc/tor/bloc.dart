import 'dart:async';

import 'package:flutter/services.dart';

import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';

class TorBloc {
  static const platform = MethodChannel('com.breez.client/tor');
  TorConfig torConfig;
  bool _torHasStarted = false;
  // backgroundService?

  Future<TorConfig> startTor() async {
    log.info('TorBloc.startTor');
    // TODO(nochiel) if AccountSettings.useTor then
    // - save config to be used by LND in db. The daemon can get it from there.
    try {
      final response = await platform.invokeMethod(
          'startTorService'); 
      assert(response.isNotEmpty);
      log.info('TorBloc.startTor: startTorService returned!');

      if (response.isNotEmpty) {
          _torHasStarted = true;

          torConfig = TorConfig();

          var url = "wxyz://${response['Control']}".replaceAll('"', '');
          var port = Uri.parse(url).port;
          torConfig.control = "$port";
          print('torBloc.startTor: torConfig.control: ${torConfig.control}');

          url = "socks://${response['SOCKS']}".replaceAll('"', '');
          port = Uri.parse(url).port;
          torConfig.socks = "$port";
          print('torBloc.startTor: torConfig.socks: ${torConfig.socks}');

          url = "http://${response['HTTP']}".replaceAll('"', '');
          port = Uri.parse(url).port;
          torConfig.http = "$port";
          print('torBloc.startTor: torConfig.http: ${torConfig.http}');

          log.info(
                  'TorBloc.startTor: tor has started with config : ${torConfig}');
      }
    } on PlatformException catch (e) {
      log.info('TorBloc.startTor failed: $e');
    }

    return torConfig;
  }
}
