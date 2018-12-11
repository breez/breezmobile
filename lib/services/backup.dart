import 'dart:collection';

import 'package:flutter/services.dart';
import 'dart:async';

class BackupService {
  static const _methodChannel = const MethodChannel("com.breez.client/backup");
  static const String _signInFaileCode = "SIGN_IN_FAILED";
  static const String _backupConflictCode = "BACKUP_CONFLICT_ERROR";  

  Future<dynamic> backup(List<String> paths, String nodeId, String breezBackupID, {bool silent = false}) {
    return _invokeMethod("backup", {"paths": paths, "nodeId": nodeId, "breezBackupID": breezBackupID, "silent": silent});
  }

  Future<Map<String, String>> getAvailableBackups() {
    return _invokeMethod("getAvailableBackups").then((res) => new Map<String, String>.from(res));
  }

  Future<List<String>> restore(String nodeId, String breezBackupID) {    
    return _invokeMethod("restore", {"nodeId": nodeId, "breezBackupID": breezBackupID}).then((res) => List<String>.from(res));
  }

  Future<dynamic> signOut(){
     return _invokeMethod("signOut");
  }

  Future<bool> isSafeForBreezBackupID(String nodeId, String breezBackupID){
    return _invokeMethod("isSafeForBreezBackupID", {"breezBackupID": breezBackupID, "nodeId": nodeId}).then((res) => res as bool);
  }

  Future<dynamic> _invokeMethod(String method, [dynamic arguments]) {
    return _methodChannel.invokeMethod(method, arguments).catchError((err){
      if (err.runtimeType == PlatformException) {
        PlatformException e = (err as PlatformException);
        if (e.code == _signInFaileCode) {
          throw new SignInFailedException();
        }
        if (e.code == _backupConflictCode) {
          throw new BackupConflictException();
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

class BackupConflictException implements Exception {
  String toString() {
    return "Backup conflict detected";
  }
}
