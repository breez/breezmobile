import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/backup/backup_model.dart';
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

  final BehaviorSubject<List<String>> _availableBackupPathsController = new BehaviorSubject<List<String>>();
  Stream<List<String>> get availableBackupPathsStream => _availableBackupPathsController.stream;

  final BehaviorSubject<DateTime> _lastBackupTimeController = new BehaviorSubject<DateTime>();
  Stream<DateTime> get lastBackupTimeStream => _lastBackupTimeController.stream;

  final BehaviorSubject<BackupSettings> _backupSettingsController = new BehaviorSubject<BackupSettings>(seedValue: BackupSettings.start());
  Stream<BackupSettings> get backupSettingsStream => _backupSettingsController.stream;
  Sink<BackupSettings> get backupSettingsSink => _backupSettingsController.sink;

  final _backupNowController = new StreamController<bool>();
  Sink<bool> get backupNowSink => _backupNowController.sink;

  final _restoreRequestController = new StreamController<String>();
  Sink<String> get restoreRequestSink => _restoreRequestController.sink;

  final _multipleRestoreController = new StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get multipleRestoreStream => _multipleRestoreController.stream;

  final _restoreFinishedController = new StreamController<bool>.broadcast();
  Stream<bool> get restoreFinishedStream => _restoreFinishedController.stream;

  bool _needBackupAfterRestart = false;

  static const String BACKUP_SETTINGS_PREFERENCES_KEY = "backup_settings";
  static const String AVAILABLE_PATHS_PREFERENCE_KEY = "backup_available_paths";
  static const String LAST_BACKUP_TIME_PREFERENCE_KEY = "backup_last_time";

  BackupBloc(this._accountStream) {
    ServiceInjector injector = new ServiceInjector();
    BreezBridge breezLib = injector.breezBridge;
    _service = BackupService();    

    var sharedPrefrences = SharedPreferences.getInstance();

    _listenBackupPaths(breezLib, sharedPrefrences);
    _listenBackupNowRequests(sharedPrefrences);
    _listenRestoreRequests(breezLib);

    _accountStream.listen((acc) {
      var existingID = _currentNodeId;
      _currentNodeId = acc.id;
      if (existingID == null && acc.id != null) {
        //TODO need to backup now.        
      }      
    });

    sharedPrefrences.then((preferences){

      //paths persistency
      List<String> paths = preferences.getStringList(AVAILABLE_PATHS_PREFERENCE_KEY);
      if (paths != null && paths.length > 0) {
        _needBackupAfterRestart = true;
      }      
      _availableBackupPathsController.stream.listen((backupPaths){
        preferences.setStringList(AVAILABLE_PATHS_PREFERENCE_KEY, backupPaths);
      });

      //last backup time persistency
      int lastTime = preferences.getInt(LAST_BACKUP_TIME_PREFERENCE_KEY);
      if (lastTime != null) {
        _lastBackupTimeController.add(DateTime.fromMillisecondsSinceEpoch(lastTime));
      }
      _lastBackupTimeController.stream.listen((lastTime){
        preferences.setInt(LAST_BACKUP_TIME_PREFERENCE_KEY, lastTime.millisecondsSinceEpoch);
      });

      //settings persistency
      var backupSettings = preferences.getString(BACKUP_SETTINGS_PREFERENCES_KEY);
      if (backupSettings != null) {
        Map<String, dynamic> settings = json.decode(backupSettings);
        _backupSettingsController.add(BackupSettings.fromJson(settings));
      }
      _backupSettingsController.stream.listen((settings){
        preferences.setString(BACKUP_SETTINGS_PREFERENCES_KEY, json.encode(settings.toJson()));
      });
    });
  }

  void _listenBackupNowRequests(Future<SharedPreferences> sharedPrefrences) {
    _backupNowController.stream.listen((data) {      
      backup(_availableBackupPathsController.value, _currentNodeId, false);
    });
  }

  _listenBackupPaths(BreezBridge breezLib, Future<SharedPreferences> sharedPrefrences) {
    Observable(breezLib.notificationStream).where((event) {
      return event.type ==
          NotificationEvent_NotificationType.BACKUP_FILES_AVAILABLE;
    }).listen((event) {
      _availableBackupPathsController.add(event.data);      
    });

    _availableBackupPathsController.stream
      .where((paths) => paths != null)
      .listen((paths){
        backup(paths, _currentNodeId, true);      
      });
  }

  void _listenRestoreRequests(BreezBridge breezLib) {    
    _restoreRequestController.stream.listen((nodeId) {
      if (nodeId == null || nodeId.isEmpty) {
        _service.signOut()
          .then((_){
            return _service.getAvailableBackups();
          })
          .then((backups){
             _multipleRestoreController.add(new Map<String, String>.from(backups));
          })
          .catchError((error) {
             _restoreFinishedController.addError(error);
          });
          return;
      }

       _service.restore(nodeId: nodeId).then((restoreResult) {
         return breezLib.bootstrap().then((done){
              return getApplicationDocumentsDirectory().then((appDir) {
                return breezLib.copyBreezConfig(appDir.path).then((done) {
                  return breezLib.bootstrapFiles(appDir.path, new List<String>.from(restoreResult)).then((done) {
                    _restoreFinishedController.add(true);
                  });
                });
              });
            });
       })
       .catchError((error) {
         _restoreFinishedController.addError(error);
        });
    });
  }

  void backup(List<String> backupPaths, String nodeId, bool silent) {
    _service.backup(backupPaths, nodeId, silent: silent)
      .then((_){
        _availableBackupPathsController.add(null);
        _lastBackupTimeController.add(DateTime.now());
      })
      .catchError((error) {
        _lastBackupTimeController.addError(error);
      });
  }

  close() {      
    _backupNowController.close();
    _restoreRequestController.close();
    _multipleRestoreController.close();
    _restoreFinishedController.close();
    _availableBackupPathsController.close();
    _backupSettingsController.close();
  }
}
