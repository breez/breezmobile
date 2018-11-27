import 'dart:async';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/backup.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class BackupBloc {
  BackupService _service;
  Stream<AccountModel> _accountStream;
  String _currentNodeId;
  List<String> _currentBackupPaths;

  final _promptEnableBackupController = new StreamController<bool>.broadcast();
  Stream<bool> get promptEnableStream => _promptEnableBackupController.stream;

  final _backupDisabledController = new StreamController<bool>.broadcast();
  Stream<bool> get backupDisabledStream => _backupDisabledController.stream;

  final _enableBackupController = new StreamController<bool>();
  Sink<bool> get enableBackupSink => _enableBackupController.sink;

  final _backupNowController = new StreamController<bool>();
  Sink<bool> get backupNowSink => _backupNowController.sink;

  final _restoreRequestController = new StreamController<String>();
  Sink<String> get restoreRequestSink => _restoreRequestController.sink;

  static const String BACKUP_DISABLED_PREFERENCES_KEY = "backupDisabled";

  BackupBloc(this._accountStream) {
    ServiceInjector injector = new ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    _service = BackupService();

    var sharedPrefrences = SharedPreferences.getInstance();
    sharedPrefrences.then((preferences) {
      _promptEnableBackupController
          .add(preferences.getBool(BACKUP_DISABLED_PREFERENCES_KEY) ?? false);
    });

    _listenEnableBackupNotifications(sharedPrefrences);
    _listenBackupPaths(breezLib);
    _listenEnableBackupRequests(sharedPrefrences);
    _listenBackupNowRequests(sharedPrefrences);
    _listenRestoreRequests(breezLib);

    _accountStream.listen((acc) {
      _currentNodeId = acc.id;
    });
  }

  void _listenEnableBackupNotifications(
      Future<SharedPreferences> sharedPrefrences) {
    _service.backupNotifications.listen((enabled) {
      if (enabled) {
        // Hide the backup disabled indicator
        _backupDisabledController.add(false);
        // Retry backing up
        _service.backup(_currentBackupPaths, _currentNodeId);
      } else {
        // Prompt to back up if not explicity disabled
        sharedPrefrences.then((preferences) {
          if (!(preferences.getBool(BACKUP_DISABLED_PREFERENCES_KEY) ??
              false)) {
            // Send a signal to prompt
            _backupDisabledController.add(true);
            _promptEnableBackupController.add(true);
          }
        });
      }
    });
  }

  void _listenEnableBackupRequests(Future<SharedPreferences> sharedPrefrences) {
    _enableBackupController.stream.listen((enable) {
      sharedPrefrences.then((preferences) {
        preferences.setBool(BACKUP_DISABLED_PREFERENCES_KEY, !enable);
      });
    });
  }

  void _listenBackupNowRequests(Future<SharedPreferences> sharedPrefrences) {
    _backupNowController.stream.listen((data) {
      _service.authorize();
      _service.backup(_currentBackupPaths, _currentNodeId);

      sharedPrefrences.then((preferences) {
        _backupDisabledController
            .add(preferences.getBool(BACKUP_DISABLED_PREFERENCES_KEY) ?? false);
      });
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

  void _listenRestoreRequests(BreezBridge breezLib) {
    _restoreRequestController.stream.listen((nodeId) {
      _service.restore();

      // ... and kick-off lighntinglib
      getApplicationDocumentsDirectory().then((appDir) {
        breezLib.bootstrap(appDir.path, /* list of all the files*/)
        breezLib.start(appDir.path);
      });
    });
  }

  close() {
    _promptEnableBackupController.close();
    _enableBackupController.close();
    _backupNowController.close();
    _restoreRequestController.close();
  }
}
