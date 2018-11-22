import 'dart:async';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/backup.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupBloc {
  BackupService _service;
  Stream<AccountModel> _accountStream;
  String _currentNodeId;
  List<String> _currentBackupPaths;

  final _backupDisabledController = new StreamController<bool>.broadcast();
  Stream<bool> get backupDisabledStream => _backupDisabledController.stream;

  final _enableBackupController = new StreamController<bool>();
  Sink<bool> get enableBackupSink => _enableBackupController.sink;

  final _backupNowController = new StreamController<Null>();
  Sink<Null> get backupNowSink => _backupNowController.sink;

  static const String BACKUP_DISABLED_PREFERENCES_KEY = "backupDisabled";

  BackupBloc(this._accountStream) {
    ServiceInjector injector = new ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    _service = BackupService();

    var sharedPrefrences = SharedPreferences.getInstance();
    sharedPrefrences.then((preferences) {
      _backupDisabledController.add(preferences.getBool(BACKUP_DISABLED_PREFERENCES_KEY) ?? true);
    });

    _listenBackupPaths(breezLib);
    _listenEnableBackupRequests(sharedPrefrences);
    _listenBackupNowRequests();

    _accountStream.listen((acc) {
      _currentNodeId = acc.id;
    });
  }

  void _listenEnableBackupRequests(Future<SharedPreferences> sharedPrefrences) {
    _enableBackupController.stream.listen((enable){
      sharedPrefrences.then((preferences) {
        preferences.setBool(BACKUP_DISABLED_PREFERENCES_KEY, !enable);
      });
      if (enable) {
        _service.authorize();
      }
    });
  }

  void _listenBackupNowRequests() {
    _backupNowController.stream.listen((data){
      _service.backup(_currentBackupPaths, _currentNodeId);
    });
  }

  _listenBackupPaths(BreezBridge breezLib) {
    Observable(breezLib.notificationStream).where((event) {
      return event.type ==
          NotificationEvent_NotificationType.BACKUP_FILES_AVAILABLE;
    }).listen((event) {
      _service.backup(event.data, _currentNodeId);
      _currentBackupPaths = event.data;
    });
  }

  close() {
    _backupDisabledController.close();
    _enableBackupController.close();
    _backupNowController.close();
  }
}
