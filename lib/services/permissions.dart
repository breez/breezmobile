import 'package:flutter/services.dart';

class Permissions {
  static const MethodChannel channel =
  const MethodChannel('com.breez.client/permissions');

  void requestOptimizationWhitelist() {    
    channel.invokeMethod('requestOptimizationWhitelist');
  }
}
