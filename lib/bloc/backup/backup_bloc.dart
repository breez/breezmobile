import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/async_action.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/user_profile/backup_user_preferences.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/background_task.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class BackupBloc with AsyncActionsHandler {
  static const String _signInFailedCode = "401";
  static const String _signInFailedMessage = "AuthError";
  static const String _methodNotFound = "405";
  static const String _notFoundMessage = "404";
  static const String _noAccess = "403";
  static const String _empty = "empty";
  static const String USER_DETAILS_PREFERENCES_KEY = "BreezUserModel.userID";

  static const _kDefaultOverrideFee = false;
  static const _kDefaultBaseFee = 20;
  static const _kDefaultProportionalFee = 1.0;

  static const _kPaymentOptionOverrideFee = "PAYMENT_OPTIONS_OVERRIDE_FEE";
  static const _kPaymentOptionBaseFee = "PAYMENT_OPTIONS_BASE_FEE";
  static const _kPaymentOptionProportionalFee =
      "PAYMENT_OPTIONS_PROPORTIONAL_FEE";

  final BehaviorSubject<BackupState> _backupStateController =
      BehaviorSubject<BackupState>();
  Stream<BackupState> get backupStateStream => _backupStateController.stream;

  final StreamController<bool> _promptBackupController =
      StreamController<bool>.broadcast();
  Stream<bool> get promptBackupStream => _promptBackupController.stream;

  final StreamController<bool> _backupPromptVisibleController =
      BehaviorSubject<bool>.seeded(false);
  Stream<bool> get backupPromptVisibleStream =>
      _backupPromptVisibleController.stream;
  Sink<bool> get backupPromptVisibleSink => _backupPromptVisibleController.sink;

  final BehaviorSubject<BackupSettings> _backupSettingsController =
      BehaviorSubject<BackupSettings>.seeded(BackupSettings.start());
  Stream<BackupSettings> get backupSettingsStream =>
      _backupSettingsController.stream;
  Sink<BackupSettings> get backupSettingsSink => _backupSettingsController.sink;

  final _backupNowController = StreamController<BackupNowAction>();
  Sink<BackupNowAction> get backupNowSink => _backupNowController.sink;

  final _backupAppDataController = StreamController<bool>.broadcast();
  Sink<bool> get backupAppDataSink => _backupAppDataController.sink;

  final _restoreLightningFeesController =
      StreamController<Map<String, dynamic>>.broadcast();
  Sink<Map<String, dynamic>> get restoreLightningFeesSink =>
      _restoreLightningFeesController.sink;
  Stream<Map<String, dynamic>> get restoreLightningFeesStream =>
      _restoreLightningFeesController.stream;

  final _backupActionsController = StreamController<AsyncAction>.broadcast();
  Sink<AsyncAction> get backupActionsSink => _backupActionsController.sink;

  BreezBridge _breezLib;
  BackgroundTaskService _tasksService;
  SharedPreferences _sharedPreferences;
  bool _backupServiceNeedLogin = false;
  bool _enableBackupPrompt = false;
  Map<Type, Function> _actionHandlers = {};
  FlutterSecureStorage _secureStorage;
  String _appDirPath;
  String _backupAppDataDirPath;

  static const String BACKUP_SETTINGS_PREFERENCES_KEY = "backup_settings";
  static const String LAST_BACKUP_TIME_PREFERENCE_KEY = "backup_last_time";
  static const String LAST_BACKUP_STATE_PREFERENCE_KEY = "backup_last_state";

  BackupBloc(
    Stream<BreezUserModel> userStream,
    Stream<bool> backupAnytimeDBStream, {
    ServiceInjector serviceInjector,
    FlutterSecureStorage secureStorage,
  }) {
    _initAppDataPathAndDir();
    _secureStorage = secureStorage ?? const FlutterSecureStorage();
    ServiceInjector injector = serviceInjector ?? ServiceInjector();
    _breezLib = injector.breezBridge;
    _tasksService = injector.backgroundTaskService;
    _actionHandlers = {
      SaveBackupKey: _saveBackupKey,
      UpdateBackupSettings: _updateBackupSettings,
      DownloadSnapshot: _downloadSnapshot,
      ListSnapshots: _listSnapshots,
      RestoreBackup: _restoreBackup,
    };

    SharedPreferences.getInstance().then((sp) async {
      _sharedPreferences = sp;
      // Read the backupKey from the secure storage and initialize the breez user model appropriately
      await _initializePersistentData();
      _listenBackupPaths();
      _listenBackupNowRequests();
      _listenAppDataBackupRequests(backupAnytimeDBStream);
      _scheduleBackgroundTasks();

      // Read the backupKey from the secure storage and initialize the breez user model appropriately
      _setBreezLibBackupKey();
      if (_backupSettingsController.value.backupProvider != null) {
        await _updateBackupProvider(_backupSettingsController.value);
      }
      _listenPinCodeChange(userStream);
      _listenUserPreferenceChanges(userStream);
      _listenActions();
    });
  }

  void _initAppDataPathAndDir() async {
    var appDir = await getApplicationDocumentsDirectory();
    _appDirPath = appDir.path;
    _backupAppDataDirPath =
        '$_appDirPath${Platform.pathSeparator}app_data_backup';
    Directory(_backupAppDataDirPath).createSync(recursive: true);
  }

  void _listenActions() {
    _backupActionsController.stream.listen((action) {
      var handler = _actionHandlers[action.runtimeType];
      if (handler != null) {
        handler(action).catchError((e) => action.resolveError(e));
      }
    });
  }

  Future _updateBackupSettings(UpdateBackupSettings action) async {
    final oldSettings = _backupSettingsController.value;
    final newSettings = action.settings;
    log.info("update backup from:\n$oldSettings to:\n$newSettings");
    _backupSettingsController.add(newSettings);
    // Always update settings
    await _setBreezLibBackupKey(backupKeyType: newSettings.backupKeyType);
    await _updateBackupProvider(newSettings);
    action.resolve(newSettings);
  }

  Future _updateBackupProvider(BackupSettings settings) async {
    String authData;
    if (settings.backupProvider.name ==
        BackupSettings.remoteServerBackupProvider().name) {
      log.info("update backup provider auth data as a remote server");
      var map = settings.remoteServerAuthData.toJson();
      authData = json.encode(map);
    } else {
      log.info(
          "update backup provider auth data as ${settings.backupProvider.name} server");
    }
    await _breezLib.setBackupProvider(settings.backupProvider.name, authData);
  }

  Future _initializePersistentData() async {
    //last backup time persistency
    String backupStateJson =
        _sharedPreferences.getString(LAST_BACKUP_STATE_PREFERENCE_KEY);
    BackupState backupState = BackupState.start();
    if (backupStateJson != null) {
      backupState = BackupState.fromJson(json.decode(backupStateJson));
    }

    _backupStateController.add(backupState);
    _backupStateController.stream.listen((state) {
      _sharedPreferences.setString(
          LAST_BACKUP_STATE_PREFERENCE_KEY, json.encode(state.toJson()));
    }, onError: (e) {
      _pushPromptIfNeeded();
    });

    //settings persistency
    var backupSettings =
        _sharedPreferences.getString(BACKUP_SETTINGS_PREFERENCES_KEY);
    if (backupSettings != null) {
      Map<String, dynamic> settings = json.decode(backupSettings);
      var backupSettingsModel = BackupSettings.fromJson(settings);
      // For backward compatibility migrate backup provider by assigning "Google Drive"
      // in case we had backup and the provider is not set.
      if (backupSettingsModel.backupProvider == null &&
          backupState?.lastBackupTime != null) {
        backupSettingsModel = backupSettingsModel.copyWith(
          backupProvider: BackupSettings.googleBackupProvider(),
        );
      }
      if (backupSettingsModel.backupProvider?.name ==
          BackupSettings.remoteServerBackupProvider().name) {
        String authdata =
            await _secureStorage.read(key: "remoteServerAuthData");
        if (authdata != null) {
          RemoteServerAuthData auth =
              RemoteServerAuthData.fromJson(json.decode(authdata));
          backupSettingsModel =
              backupSettingsModel.copyWith(remoteServerAuthData: auth);
        }
      }

      _backupSettingsController.add(backupSettingsModel);
    }

    _backupSettingsController.stream.listen((settings) async {
      _sharedPreferences.setString(
          BACKUP_SETTINGS_PREFERENCES_KEY, json.encode(settings.toJson()));
      if (settings.remoteServerAuthData != null) {
        String secureValue =
            json.encode(settings.remoteServerAuthData.toJson());
        await _secureStorage.write(
            key: "remoteServerAuthData",
            value: secureValue,
            mOptions: const MacOsOptions(synchronizable: true));
      }
    });
  }

  void _listenPinCodeChange(Stream<BreezUserModel> userStream) {
    userStream.listen((user) {
      _setBreezLibBackupKey();
    });
  }

  void _listenUserPreferenceChanges(Stream<BreezUserModel> userStream) {
    userStream.listen((user) async {
      await _compareUserPreferences(user);
    });
  }

  Future<void> _compareUserPreferences(BreezUserModel user) async {
    var appDir = await getApplicationDocumentsDirectory();
    var backupAppDataDirPath =
        '${appDir.path}${Platform.pathSeparator}app_data_backup';
    final backupUserPrefsPath =
        '$backupAppDataDirPath${Platform.pathSeparator}userPreferences.txt';
    // Check if userPreferences file exists
    if (await File(backupUserPrefsPath).exists()) {
      // Compare updated user preferences against stored user preferences
      BackupUserPreferences userPreferences =
          BackupUserPreferences.fromJson(user.toJson());
      BackupUserPreferences storedUserPreferences =
          await _getSavedUserPreferences(backupUserPrefsPath);
      // Update and trigger backup if user preferences has changed
      if (userPreferences.toJson().toString() !=
          storedUserPreferences.toJson().toString()) {
        await _updateUserPreferences(user)
            .then((_) => backupAppDataSink.add(true));
      }
    } else {
      await _saveUserPreferences();
    }
  }

  Future<BackupUserPreferences> _getSavedUserPreferences(
      String backupUserPrefsPath) async {
    final backupUserPrefs = await File(backupUserPrefsPath).readAsString();
    return BackupUserPreferences.fromJson(json.decode(backupUserPrefs));
  }

  Future<void> _updateUserPreferences(BreezUserModel userModel) async {
    final backupUserPrefsPath =
        '$_backupAppDataDirPath${Platform.pathSeparator}userPreferences.txt';
    var backupUserPreferences =
        BackupUserPreferences.fromJson(userModel.toJson());
    await File(backupUserPrefsPath)
        .writeAsString(jsonEncode(backupUserPreferences.toJson()))
        .catchError((err) {
      throw Exception("Failed to save user preferences.");
    });
  }

  // Save BreezUserModel json to backup directory
  Future<void> _saveUserPreferences() async {
    final backupUserPrefsPath =
        '$_backupAppDataDirPath${Platform.pathSeparator}userPreferences.txt';
    var preferences = await ServiceInjector().sharedPreferences;
    var userPreferences =
        preferences.getString(USER_DETAILS_PREFERENCES_KEY) ?? "{}";
    BreezUserModel userModel =
        BreezUserModel.fromJson(json.decode(userPreferences));
    var backupUserPreferences =
        BackupUserPreferences.fromJson(userModel.toJson());
    await File(backupUserPrefsPath)
        .writeAsString(json.encode(backupUserPreferences.toJson()))
        .catchError((err) {
      throw Exception("Failed to save user preferences.");
    });
  }

  Future _saveBackupKey(SaveBackupKey action) async {
    await BreezLibBackupKey.save(_secureStorage, action.backupPhrase);
    action.resolve(null);
  }

  Future _downloadSnapshot(DownloadSnapshot action) async {
    action.resolve(await _breezLib.downloadBackup(action.nodeID));
  }

  Future _setBreezLibBackupKey({BackupKeyType backupKeyType}) async {
    backupKeyType ??= _backupSettingsController.value.backupKeyType;
    var encryptionKey =
        await BreezLibBackupKey.fromSettings(_secureStorage, backupKeyType);

    return _breezLib.setBackupEncryptionKey(
        encryptionKey?.key, encryptionKey?.type);
  }

  Future _listSnapshots(ListSnapshots action) async {
    try {
      String backups = await _breezLib.getAvailableBackups();
      List snapshotsArray = json.decode(backups) as List;
      List<SnapshotInfo> snapshots = <SnapshotInfo>[];
      if (snapshotsArray != null) {
        snapshots = snapshotsArray.map((s) {
          return SnapshotInfo.fromJson(s);
        }).toList();
      }
      snapshots.sort((s1, s2) => s2.modifiedTime.compareTo(s1.modifiedTime));
      action.resolve(snapshots);
    } on PlatformException catch (e) {
      dynamic exception = e.message;
      // the error code equals the message from the go library so
      // not to confuse the two.
      if (e.code == _signInFailedMessage || e.message == _signInFailedCode) {
        exception = SignInFailedException(
          _backupSettingsController.value.backupProvider,
        );
      } else if (e.code == _empty) {
        exception = NoBackupFoundException();
      }
      action.resolveError(exception);
    } catch (error) {
      action.resolveError(error);
    }
  }

  Future _restoreBackup(RestoreBackup action) async {
    try {
      final snapshot = action.restoreRequest.snapshot;
      final key = action.restoreRequest.encryptionKey.key;
      log.info('snapshotInfo with timestamp: ${snapshot.modifiedTime}');
      if (key != null) log.info('using key with length: ${key.length}');

      _clearAppData();

      await _breezLib.restore(snapshot.nodeID, key);
      await _restoreAppData();

      _updateLastBackupTime(snapshot.modifiedTime);

      action.resolve(true);
    } catch (error) {
      _clearAppData();
      action.resolveError(error);
    }
  }

  void _updateLastBackupTime(String modifiedTime) {
    _backupStateController.add(
      _backupStateController.value?.copyWith(
        lastBackupTime: DateTime.tryParse(modifiedTime),
      ),
    );
  }

  _scheduleBackgroundTasks() {
    var backupFinishedEvents = [
      NotificationEvent_NotificationType.BACKUP_SUCCESS,
      NotificationEvent_NotificationType.BACKUP_AUTH_FAILED,
      NotificationEvent_NotificationType.BACKUP_FAILED
    ];
    Completer taskCompleter;

    _breezLib.notificationStream.listen((event) {
      if (taskCompleter == null &&
          event.type == NotificationEvent_NotificationType.BACKUP_REQUEST) {
        taskCompleter = Completer();
        _tasksService.runAsTask(taskCompleter.future, () {
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
    _backupNowController.stream.listen((action) => _backupNow(action));
  }

  Future _backupNow(BackupNowAction action) async {
    log.info("backup now requested: $action");
    if (_backupServiceNeedLogin) {
      await _breezLib.signOut();
    }
    await _breezLib.signIn(_backupServiceNeedLogin, action.recoverEnabled);
    await _saveAppData();
    _breezLib.requestBackup();
  }

  void _listenAppDataBackupRequests(Stream backupAnytimeDBStream) {
    Rx.merge([backupAnytimeDBStream, _backupAppDataController.stream])
        .listen((_) => _backupAppData());
  }

  Future _backupAppData() async {
    await _saveAppData();
    _breezLib.requestAppDataBackup();
  }

  _saveAppData() async {
    try {
      await _saveLightningFees();
      await _savePosDB();
      await _savePodcastsDB();
    } on Exception {
      rethrow;
    }
  }

  Future<void> _saveLightningFees() async {
    final lightningFeesPath =
        '$_backupAppDataDirPath${Platform.pathSeparator}lightningFees.txt';
    final lightningFeesPreferences = await _getLightningFeesPreferences();
    await File(lightningFeesPath)
        .writeAsString(json.encode(lightningFeesPreferences))
        .catchError((err) {
      throw Exception("Failed to save lightning fees.");
    });
  }

  Future<Map<String, dynamic>> _getLightningFeesPreferences() async {
    var preferences = await ServiceInjector().sharedPreferences;
    bool paymentFeeEnabled = preferences.containsKey(_kPaymentOptionOverrideFee)
        ? preferences.getBool(_kPaymentOptionOverrideFee)
        : _kDefaultOverrideFee;
    int baseFee = preferences.containsKey(_kPaymentOptionBaseFee)
        ? preferences.getInt(_kPaymentOptionBaseFee)
        : _kDefaultBaseFee;
    double proportionalFee =
        preferences.containsKey(_kPaymentOptionProportionalFee)
            ? preferences.getDouble(_kPaymentOptionProportionalFee)
            : _kDefaultProportionalFee;
    return {
      _kPaymentOptionOverrideFee: paymentFeeEnabled,
      _kPaymentOptionBaseFee: baseFee,
      _kPaymentOptionProportionalFee: proportionalFee,
    };
  }

  Future<void> _savePosDB() async {
    // Copy POS items to backup directory
    final posDbPath =
        '${await databaseFactory.getDatabasesPath()}${Platform.pathSeparator}product-catalog.db';
    if (await databaseExists(posDbPath)) {
      File(posDbPath)
          .copy(
              '$_backupAppDataDirPath${Platform.pathSeparator}product-catalog.db')
          .catchError((err) {
        throw Exception("Failed to copy pos items.");
      });
    }
  }

  Future<void> _savePodcastsDB() async {
    // Copy Podcasts library to backup directory
    final anytimeDbPath = '$_appDirPath${Platform.pathSeparator}anytime.db';
    if (await databaseExists(anytimeDbPath)) {
      File(anytimeDbPath)
          .copy('$_backupAppDataDirPath${Platform.pathSeparator}anytime.db')
          .catchError((err) {
        throw Exception("Failed to copy podcast library.");
      });
    }
  }

  _listenBackupPaths() {
    var backupOperations = [
      NotificationEvent_NotificationType.PAYMENT_SENT,
      NotificationEvent_NotificationType.INVOICE_PAID,
      NotificationEvent_NotificationType.FUND_ADDRESS_CREATED
    ];

    _breezLib.notificationStream.listen((event) async {
      if (event.type == NotificationEvent_NotificationType.BACKUP_REQUEST) {
        _backupServiceNeedLogin = false;
        _backupStateController.add(
          _backupStateController.value?.copyWith(inProgress: true),
        );
      }
      if (event.type == NotificationEvent_NotificationType.BACKUP_AUTH_FAILED) {
        _backupServiceNeedLogin = true;
        _backupStateController.addError(
          BackupFailedException(
            _backupSettingsController.value.backupProvider,
            true,
          ),
        );
      }
      if (event.type == NotificationEvent_NotificationType.BACKUP_FAILED) {
        _backupStateController.addError(
          BackupFailedException(
            _backupSettingsController.value.backupProvider,
            false,
          ),
        );
      }
      if (event.type == NotificationEvent_NotificationType.BACKUP_SUCCESS) {
        _backupServiceNeedLogin = false;
        _breezLib.getLatestBackupTime().then((timeStamp) {
          log.info("Timestamp=$timeStamp");
          if (timeStamp > 0) {
            log.info(timeStamp);
            DateTime latestDateTime =
                DateTime.fromMillisecondsSinceEpoch(timeStamp);
            _backupStateController.add(
              BackupState(latestDateTime, false, event.data[0]),
            );
          }
        });
      }
      if (backupOperations.contains(event.type)) {
        _enableBackupPrompt = true;
        _pushPromptIfNeeded();
      }
    });
  }

  _pushPromptIfNeeded() {
    if (_enableBackupPrompt &&
        (_backupServiceNeedLogin ||
            _backupSettingsController.value.backupProvider == null)) {
      _enableBackupPrompt = false;
      _promptBackupController.add(_backupServiceNeedLogin);
    }
  }

  Future testAuth(BackupProvider provider, RemoteServerAuthData authData) {
    return _breezLib
        .testBackupAuth(provider.name, json.encode(authData.toJson()))
        .catchError(
      (error) {
        log.info('backupBloc.testAuth caught error: $error');

        if (error is PlatformException) {
          var e = error;
          switch (e.message) {
            case _signInFailedCode:
            case _signInFailedMessage:
              throw SignInFailedException(provider);
              break;
            case _methodNotFound:
              throw MethodNotFoundException();
              break;
            case _noAccess:
            case _empty:
              throw NoBackupFoundException();
              break;
            case _notFoundMessage:
              throw RemoteServerNotFoundException();
              break;
          }
        }
        throw error;
      },
    );
  }

  Future<void> _restoreAppData() async {
    try {
      await _restoreLightningFees();
      await _restorePosDB();
      await _restorePodcastsDB();
    } on Exception {
      rethrow;
    }
  }

  Future<void> _restoreLightningFees() async {
    final lightningFeesPath =
        '$_backupAppDataDirPath${Platform.pathSeparator}lightningFees.txt';
    if (await File(lightningFeesPath).exists()) {
      final backupLightningFeesPrefs =
          await File(lightningFeesPath).readAsString();
      Map<String, dynamic> lightningFeesPrefs =
          json.decode(backupLightningFeesPrefs);
      restoreLightningFeesSink.add(lightningFeesPrefs);
    }
  }

  Future<void> _restorePosDB() async {
    final backupPosDbPath =
        '$_backupAppDataDirPath${Platform.pathSeparator}product-catalog.db';
    final posDbPath =
        '${await databaseFactory.getDatabasesPath()}${Platform.pathSeparator}product-catalog.db';
    if (await File(backupPosDbPath).exists()) {
      await File(backupPosDbPath).copy(posDbPath).catchError((err) {
        throw Exception("Failed to restore pos items.");
      });
    }
  }

  Future<void> _restorePodcastsDB() async {
    final backupAnytimeDbPath =
        '$_backupAppDataDirPath${Platform.pathSeparator}anytime.db';
    final anytimeDbPath = '$_appDirPath${Platform.pathSeparator}anytime.db';
    if (await File(backupAnytimeDbPath).exists()) {
      await File(backupAnytimeDbPath).copy(anytimeDbPath).catchError((err) {
        throw Exception("Failed to restore podcast library.");
      });
    }
  }

  void _clearAppData() {
    try {
      Directory(_backupAppDataDirPath)
          .list(recursive: true)
          .listen((file) => file.deleteSync());
    } on Exception {
      rethrow;
    }
  }

  close() {
    _backupNowController.close();
    _backupAppDataController.close();
    _restoreLightningFeesController.close();
    _backupSettingsController.close();
    _backupPromptVisibleController.close();
    _backupActionsController.close();
  }
}
