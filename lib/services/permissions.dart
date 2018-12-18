import 'package:flutter/services.dart';

class Permissions {
  static const MethodChannel channel =
  const MethodChannel('com.breez.client/permissions');

  void requestOptimizationWhitelist() {    
    channel.invokeMethod('requestOptimizationWhitelist');
  }

  Future<bool> isInOptimizationWhitelist(){
    return channel.invokeMethod("isInOptimizationWhitelist").then((res) => res as bool);
  }
}
