import 'dart:async';
import 'dart:convert';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/services/background_task.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupBloc {

  final BehaviorSubject<BackupState> _backupStateController =
      new BehaviorSubject<BackupState>();
  Stream<BackupState> get backupStateStream => _backupStateController.stream;

  final StreamController<void> _promptBackupController = new StreamController<void>.broadcast();
  Stream<void> get promptBackupStream => _promptBackupController.stream;

  final BehaviorSubject<BackupSettings> _backupSettingsController =
      new BehaviorSubject<BackupSettings>(seedValue: BackupSettings.start());
  Stream<BackupSettings> get backupSettingsStream =>
      _backupSettingsController.stream;
  Sink<BackupSettings> get backupSettingsSink => _backupSettingsController.sink;

  final _backupNowController = new StreamController<bool>();
  Sink<bool> get backupNowSink => _backupNowController.sink;

  final _restoreRequestController = new StreamController<String>();
  Sink<String> get restoreRequestSink => _restoreRequestController.sink;

  final _multipleRestoreController =
      new StreamController<List<SnapshotInfo>>.broadcast();
  Stream<List<SnapshotInfo>> get multipleRestoreStream =>
      _multipleRestoreController.stream;

  final _restoreFinishedController = new StreamController<bool>.broadcast();
  Stream<bool> get restoreFinishedStream => _restoreFinishedController.stream;

  BreezBridge _breezLib;  
  BackgroundTaskService _tasksService;
  SharedPreferences _sharedPrefrences;    
  bool _backupServiceNeedLogin = false;
  bool _enableBackupPrompt = false;
  bool _backupHasError = false;

  static const String BACKUP_SETTINGS_PREFERENCES_KEY = "backup_settings";  
  static const String LAST_BACKUP_TIME_PREFERENCE_KEY = "backup_last_time";

  BackupBloc() {
    ServiceInjector injector = new ServiceInjector();
    _breezLib = injector.breezBridge;
    _tasksService = injector.backgroundTaskService;

    SharedPreferences.getInstance().then((sp) {
      _sharedPrefrences = sp;     
      _initializePersistentData();
      _listenBackupPaths();
      _listenBackupNowRequests();
      _listenRestoreRequests();
      _scheduleBackgroundTasks();
    });
  }

  void _initializePersistentData() {     

    //last backup time persistency
    int lastTime = _sharedPrefrences.getInt(LAST_BACKUP_TIME_PREFERENCE_KEY);
    _backupStateController
          .add(BackupState(DateTime.fromMillisecondsSinceEpoch(lastTime ?? 0), false)); 
       
    _backupStateController.stream.listen((state) {
      _backupHasError = false;
      _sharedPrefrences.setInt(
          LAST_BACKUP_TIME_PREFERENCE_KEY, state.lastBackupTime.millisecondsSinceEpoch);
    }, onError: (e){
      _backupHasError = true;
      _pushPromptIfNeeded();
    });

    //settings persistency
    var backupSettings =
        _sharedPrefrences.getString(BACKUP_SETTINGS_PREFERENCES_KEY);
    if (backupSettings != null) {
      Map<String, dynamic> settings = json.decode(backupSettings);
      _backupSettingsController.add(BackupSettings.fromJson(settings));
    }
    _backupSettingsController.stream.listen((settings) {
      _sharedPrefrences.setString(
          BACKUP_SETTINGS_PREFERENCES_KEY, json.encode(settings.toJson()));
    });
  }

  _scheduleBackgroundTasks(){
    var backupFinishedEvents = [
      NotificationEvent_NotificationType.BACKUP_SUCCESS,
      NotificationEvent_NotificationType.BACKUP_AUTH_FAILED,
      NotificationEvent_NotificationType.BACKUP_FAILED
    ];
    Completer taskCompleter;

    Observable(_breezLib.notificationStream)     
    .listen((event) {
      if (taskCompleter == null && event.type == NotificationEvent_NotificationType.BACKUP_REQUEST) {
        taskCompleter = new Completer();        
        _tasksService.runAsTask(taskCompleter.future, (){
          taskCompleter?.complete();
          taskCompleter = null;
        });
        return;
      }

      if (taskCompleter != null && backupFinishedEvents.contains(event.type)) {
        taskCompleter?.complete();
        taskCompleter = null;
      }
    });
  }

  void _listenBackupNowRequests() {
    _backupNowController.stream.listen((_) => _backupNow());
  }
  
  void _backupNow() {    
    _breezLib.signIn(true)
      .then((_) => _breezLib.requestBackup());      
  }

  _listenBackupPaths() { 
    var backupOperations = [
      NotificationEvent_NotificationType.PAYMENT_SENT, 
      NotificationEvent_NotificationType.INVOICE_PAID,
      NotificationEvent_NotificationType.FUND_ADDRESS_CREATED
    ];

    Observable(_breezLib.notificationStream)     
    .listen((event) {
      if (event.type == NotificationEvent_NotificationType.BACKUP_REQUEST) {
        _backupStateController.add((BackupState(_backupStateController.value.lastBackupTime, true)));
      }      
      if (event.type == NotificationEvent_NotificationType.BACKUP_AUTH_FAILED) {
        _backupServiceNeedLogin = true;
        _backupStateController.addError(null);
      }
      if (event.type == NotificationEvent_NotificationType.BACKUP_FAILED) {
        _backupServiceNeedLogin = false;
        _backupStateController.addError(null);
      }
      if (event.type == NotificationEvent_NotificationType.BACKUP_SUCCESS) {        
        _backupServiceNeedLogin = false;
        _backupStateController.add(BackupState(DateTime.now(), false));
      }
      if (backupOperations.contains(event.type)) {
        _enableBackupPrompt = true;
        _pushPromptIfNeeded();    
      }      
    });
  }

  _pushPromptIfNeeded(){
    if (_enableBackupPrompt && _backupHasError) {
      _enableBackupPrompt = false;      
      _promptBackupController.add(null);
    }
  }

  void _listenRestoreRequests() {
    _restoreRequestController.stream.listen((nodeId) {
      if (nodeId == null || nodeId.isEmpty) {
        return _breezLib.getAvailableBackups()
        .then((backups) {          
          List snapshotsArray = json.decode(backups) as List;
          List<SnapshotInfo> snapshots = List<SnapshotInfo>();
          if (snapshotsArray != null) {            
            snapshots = snapshotsArray.map((s){
              return SnapshotInfo.fromJson(s);
            }).toList();
          }
          _multipleRestoreController.add(snapshots);
        }).catchError((error) {
          _restoreFinishedController.addError(error);
        });        
      }

      _breezLib.restore(nodeId)
        .then((_) => _restoreFinishedController.add(true))
        .catchError(_restoreFinishedController.addError);      
    });  
  }

  close() {
    _backupNowController.close();
    _restoreRequestController.close();
    _multipleRestoreController.close();
    _restoreFinishedController.close();    
    _backupSettingsController.close();
  }
}

class SnapshotInfo {
  final String nodeID;	
	final String modifiedTime;

  SnapshotInfo(this.nodeID, this.modifiedTime);
  
  SnapshotInfo.fromJson(Map<String, dynamic> json) : 
    this(
      json["NodeID"], 
      json["ModifiedTime"]
    );
}