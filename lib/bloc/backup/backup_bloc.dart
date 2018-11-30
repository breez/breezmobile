import 'dart:async';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/backup.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class BackupBloc {
  BackupService _service;
  AccountBloc _accountBloc;
  String _currentNodeId;
  List<String> _currentBackupPaths;

  final _promptEnableBackupController = new StreamController<bool>.broadcast();
  Stream<bool> get promptEnableStream => _promptEnableBackupController.stream;

  final _backupDisabledIndicatorController = new StreamController<bool>.broadcast();
  Stream<bool> get backupDisabledIndicatorStream => _backupDisabledIndicatorController.stream;

  final _disableBackupPromptController = new StreamController<bool>();
  Sink<bool> get disableBackupPromptSink => _disableBackupPromptController.sink;

  final _backupNowController = new StreamController<bool>();
  Sink<bool> get backupNowSink => _backupNowController.sink;

  final _restoreRequestController = new StreamController<String>();
  Sink<String> get restoreRequestSink => _restoreRequestController.sink;

  final _multipleRestoreController = new StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get multipleRestoreStream => _multipleRestoreController.stream;

  final _restoreFinishedController = new StreamController<bool>.broadcast();
  Stream<bool> get restoreFinishedStream => _restoreFinishedController.stream;

  static const String BACKUP_PROMPT_DISABLED_PREFERENCES_KEY = "backupDisabled";

  BackupBloc(this._accountBloc) {
    ServiceInjector injector = new ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    _service = BackupService();

    var sharedPrefrences = SharedPreferences.getInstance();

    _listenBackupPaths(breezLib, sharedPrefrences);
    _listenEnableBackupRequests(sharedPrefrences);
    _listenBackupNowRequests(sharedPrefrences);
    _listenRestoreRequests(breezLib);

    _accountBloc.accountStream.listen((acc) {
      _currentNodeId = acc.id;
    });
  }

  void _listenEnableBackupRequests(Future<SharedPreferences> sharedPrefrences) {
    _disableBackupPromptController.stream.listen((disable) {
      sharedPrefrences.then((preferences) {
        preferences.setBool(BACKUP_PROMPT_DISABLED_PREFERENCES_KEY, disable);
      });
    });
  }

  void _listenBackupNowRequests(Future<SharedPreferences> sharedPrefrences) {
    _backupNowController.stream.listen((data) {
      backup(_currentBackupPaths, _currentNodeId);
    });
  }

  _listenBackupPaths(BreezBridge breezLib, Future<SharedPreferences> sharedPrefrences) {
    Observable(breezLib.notificationStream).where((event) {
      return event.type ==
          NotificationEvent_NotificationType.BACKUP_FILES_AVAILABLE;
    }).listen((event) {
      _currentBackupPaths = event.data;
      sharedPrefrences.then((preferences) {
        if (preferences.getBool(BACKUP_PROMPT_DISABLED_PREFERENCES_KEY) ?? false) {
          // Prompt is disabled so go and back up
          backup(event.data, _currentNodeId);
        }
        else {
          // Prompting is enabled so show the dialog
          _promptEnableBackupController.add(true);
        }
      });
    });
  }

  void _listenRestoreRequests(BreezBridge breezLib) {
    _restoreRequestController.stream.listen((nodeId) {
      _service.restore(nodeId: nodeId).then((restoreResult) {
        if (restoreResult is List<dynamic>) {
          // We got a list of local files to restore from
          // So let's kick-off lighntinglib
          breezLib.bootstrap().then((done){
            getApplicationDocumentsDirectory().then((appDir) {
              breezLib.copyBreezConfig(appDir.path).then((done) {
                breezLib.bootstrapFiles(appDir.path, new List<String>.from(restoreResult)).then((done) {
                  _restoreFinishedController.add(true);
                });
              });
            });
          });
        }
        else {
          // We need to pick from different node IDs
          _multipleRestoreController.add(new Map<String, String>.from(restoreResult));
        }
      }).catchError((error) {
        // Notify user somehow?
      });
    });
  }

  void backup(List<String> backupPaths, String nodeId) {
    _service.backup(backupPaths, nodeId).catchError((error) {
      _backupDisabledIndicatorController.add(true);
    });
  }

  close() {
    _promptEnableBackupController.close();
    _disableBackupPromptController.close();
    _backupNowController.close();
    _restoreRequestController.close();
    _multipleRestoreController.close();
    _restoreFinishedController.close();
  }
}
