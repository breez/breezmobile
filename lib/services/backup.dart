import 'package:flutter/services.dart';
import 'dart:async';

class BackupService {
  static const _methodChannel = const MethodChannel("com.breez.client/backup");
  static const String _signInFaileCode = "SIGN_IN_FAILED";

  Future<dynamic> backup(List<String> paths, String nodeId, {bool silent = false}) {
    return _methodChannel.invokeMethod("backup", {"paths": paths, "nodeId": nodeId, "silent": silent});
  }

  Future<Map<String, String>> getAvailableBackups() {
    return _invokeMethod("getAvailableBackups").then((res) => new Map<String, String>.from(res));
  }

  Future<List<String>> restore({String nodeId = ""}) {    
    return _invokeMethod("restore", {"nodeId": nodeId}).then((res) => List<String>.from(res));
  }

  Future<dynamic> signOut(){
     return _invokeMethod("signOut");
  }

  Future<dynamic> _invokeMethod(String method, [dynamic arguments]) {
    return _methodChannel.invokeMethod(method, arguments).catchError((err){
      if (err.runtimeType == PlatformException) {
        PlatformException e = (err as PlatformException);
        if (e.code == _signInFaileCode) {
          throw new SignInFailedException();
        }
        throw (err as PlatformException).message;
      }
      throw err;
    });
  }
}

class SignInFailedException implements Exception {
  String toString() {
    return "Sign in failed";
  }
}
