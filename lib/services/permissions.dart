import 'package:flutter/services.dart';

class Permissions {
  static const MethodChannel channel =
  const MethodChannel('com.breez.client/permissions');

  Future<bool> requestOptimizationWhitelist() {    
    return channel.invokeMethod('requestOptimizationWhitelist').then( (res) => res as bool);
  }

  Future<bool> isInOptimizationWhitelist(){
    return channel.invokeMethod("isInOptimizationWhitelist").then((res) => res as bool);
  }
}
