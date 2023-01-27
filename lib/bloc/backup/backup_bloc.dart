import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clovrlabs_wallet/bloc/backup/backup_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/backup_user_preferences.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:clovrlabs_wallet/services/background_task.dart';
import 'package:clovrlabs_wallet/services/breezlib/breez_bridge.dart';
import 'package:clovrlabs_wallet/services/breezlib/data/rpc.pb.dart';
import 'package:clovrlabs_wallet/services/injector.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../async_action.dart';
import 'backup_actions.dart';

class BackupBloc {
  static const String _signInFailedCode = "AuthError";
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

  final _backupNowController = StreamController<bool>();

  Sink<bool> get backupNowSink => _backupNowController.sink;

  final _backupAppDataController = StreamController<bool>.broadcast();

  Sink<bool> get backupAppDataSink => _backupAppDataController.sink;

  final _restoreLightningFeesController =
      StreamController<Map<String, dynamic>>.broadcast();

  Sink<Map<String, dynamic>> get restoreLightningFeesSink =>
      _restoreLightningFeesController.sink;

  Stream<Map<String, dynamic>> get restoreLightningFeesStream =>
      _restoreLightningFeesController.stream;

  final _restoreRequestController = StreamController<RestoreRequest>();

  Sink<RestoreRequest> get restoreRequestSink => _restoreRequestController.sink;

  final _multipleRestoreController =
      StreamController<List<SnapshotInfo>>.broadcast();

  Stream<List<SnapshotInfo>> get multipleRestoreStream =>
      _multipleRestoreController.stream;

  final _restoreFinishedController = StreamController<bool>.broadcast();

  Stream<bool> get restoreFinishedStream => _restoreFinishedController.stream;

  final _backupActionsController = StreamController<AsyncAction>.broadcast();

  Sink<AsyncAction> get backupActionsSink => _backupActionsController.sink;

  BreezBridge _breezLib;
  BackgroundTaskService _tasksService;
  SharedPreferences _sharedPreferences;
  bool _backupServiceNeedLogin = false;
  bool _enableBackupPrompt = false;
  Map<Type, Function> _actionHandlers = Map();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String _appDirPath;
  String _backupAppDataDirPath;

  static const String BACKUP_SETTINGS_PREFERENCES_KEY = "backup_settings";
  static const String LAST_BACKUP_TIME_PREFERENCE_KEY = "backup_last_time";
  static const String LAST_BACKUP_STATE_PREFERENCE_KEY = "backup_last_state";

  BackupBloc(
    Stream<ClovrUserModel> userStream,
  ) {
    _initAppDataPathAndDir();
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _tasksService = injector.backgroundTaskService;
    _actionHandlers = {
      SaveBackupKey: _saveBackupKey,
      UpdateBackupSettings: _updateBackupSettings,
      DownloadSnapshot: _downloadSnapshot,
    };

    SharedPreferences.getInstance().then((sp) async {
      _sharedPreferences = sp;
      // Read the backupKey from the secure storage and initialize the ClovrLabs Wallet  user model appropriately
      await _initializePersistentData();
      _listenBackupPaths();
      _listenBackupNowRequests();
      _listenRestoreRequests();
      _scheduleBackgroundTasks();

      // Read the backupKey from the secure storage and initialize the ClovrLabs Wallet user model appropriately
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
        _appDirPath + Platform.pathSeparator + 'app_data_backup';
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
    var currentSettings = _backupSettingsController.value;
    _backupSettingsController.add(action.settings);
    if (action.settings.backupKeyType != currentSettings.backupKeyType) {
      await _setBreezLibBackupKey(backupKeyType: action.settings.backupKeyType);
    }
    if (action.settings.backupProvider != currentSettings.backupProvider ||
        !currentSettings.remoteServerAuthData
            .equal(action.settings.remoteServerAuthData)) {
      await _updateBackupProvider(action.settings);
    }
    action.resolve(action.settings);
  }

  Future _updateBackupProvider(BackupSettings settings) async {
    String authData;
    if (settings.backupProvider.name ==
        BackupSettings.remoteServerBackupProvider().name) {
      var map = settings.remoteServerAuthData.toJson();
      authData = json.encode(map);
    }
    await _breezLib.setBackupProvider(settings.backupProvider.name, authData);
  }

  Future _initializePersistentData() async {
    //last backup time persistency
    String backupStateJson =
        _sharedPreferences.getString(LAST_BACKUP_STATE_PREFERENCE_KEY);
    BackupState backupState = BackupState(null, false, null);
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
            key: "remoteServerAuthData", value: secureValue);
      }
    });
  }

  void _listenPinCodeChange(Stream<ClovrUserModel> userStream) {
    userStream.listen((user) {
      _setBreezLibBackupKey();
    });
  }

  void _listenUserPreferenceChanges(Stream<ClovrUserModel> userStream) {
    userStream.listen((user) async {
      await _compareUserPreferences(user);
    });
  }

  Future<void> _compareUserPreferences(ClovrUserModel user) async {
    var appDir = await getApplicationDocumentsDirectory();
    var backupAppDataDirPath =
        appDir.path + Platform.pathSeparator + 'app_data_backup';
    final backupUserPrefsPath =
        backupAppDataDirPath + Platform.pathSeparator + 'userPreferences.txt';
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

  Future<void> _updateUserPreferences(ClovrUserModel userModel) async {
    final backupUserPrefsPath =
        _backupAppDataDirPath + Platform.pathSeparator + 'userPreferences.txt';
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
        _backupAppDataDirPath + Platform.pathSeparator + 'userPreferences.txt';
    var preferences = await ServiceInjector().sharedPreferences;
    var userPreferences =
        preferences.getString(USER_DETAILS_PREFERENCES_KEY) ?? "{}";
    ClovrUserModel userModel =
    ClovrUserModel.fromJson(json.decode(userPreferences));
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

    // We call _breezLib.setBackupEncryptionKey even if encryptionKey?.key == null
    // because breezLib sets a persistent flag on whether to use encryption if len(encryptionKey?.key) > 0.
    // Maybe setUseEncryption should be set explicitly for clarity? (@nochiel)
    return _breezLib.setBackupEncryptionKey(
        encryptionKey?.key, encryptionKey?.type);
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
    _backupNowController.stream.listen((_) => _backupNow());
  }

  Future _backupNow() async {
    if (_backupServiceNeedLogin) {
      await _breezLib.signOut();
    }
    await _breezLib.signIn(_backupServiceNeedLogin);
    await _saveAppData();
    _breezLib.requestBackup();
  }

  void _listenAppDataBackupRequests() {
    Rx.merge([_backupAppDataController.stream])
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
    } on Exception catch (exception) {
      throw exception;
    }
  }

  Future<void> _saveLightningFees() async {
    final lightningFeesPath =
        _backupAppDataDirPath + Platform.pathSeparator + 'lightningFees.txt';
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
    final posDbPath = await databaseFactory.getDatabasesPath() +
        Platform.pathSeparator +
        'product-catalog.db';
    if (await databaseExists(posDbPath)) {
      File(posDbPath)
          .copy(_backupAppDataDirPath +
              Platform.pathSeparator +
              'product-catalog.db')
          .catchError((err) {
        throw Exception("Failed to copy pos items.");
      });
    }
  }

  _listenBackupPaths() {
    var backupOperations = [
      NotificationEvent_NotificationType.PAYMENT_SENT,
      NotificationEvent_NotificationType.INVOICE_PAID,
      NotificationEvent_NotificationType.FUND_ADDRESS_CREATED
    ];

    _breezLib.notificationStream.listen((event) {
      if (event.type == NotificationEvent_NotificationType.BACKUP_REQUEST) {
        _backupServiceNeedLogin = false;
        _backupStateController.add((BackupState(
            _backupStateController.value?.lastBackupTime,
            true,
            _backupStateController.value?.lastBackupAccountName)));
      }
      if (event.type == NotificationEvent_NotificationType.BACKUP_AUTH_FAILED) {
        _backupServiceNeedLogin = true;
        _backupStateController.addError(BackupFailedException(
            _backupSettingsController.value.backupProvider, true));
      }
      if (event.type == NotificationEvent_NotificationType.BACKUP_FAILED) {
        _backupStateController.addError(BackupFailedException(
            _backupSettingsController.value.backupProvider, false));
      }
      if (event.type == NotificationEvent_NotificationType.BACKUP_SUCCESS) {
        _backupServiceNeedLogin = false;
        _backupStateController
            .add(BackupState(DateTime.now(), false, event.data[0]));
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

  void _listenRestoreRequests() {
    _restoreRequestController.stream.listen((request) {
      if (request == null) {
        _breezLib.getAvailableBackups().then((backups) {
          List snapshotsArray = json.decode(backups) as List;
          List<SnapshotInfo> snapshots = <SnapshotInfo>[];
          if (snapshotsArray != null) {
            snapshots = snapshotsArray.map((s) {
              return SnapshotInfo.fromJson(s);
            }).toList();
          }
          if(snapshots.isNotEmpty) {
            snapshots
                .sort((s1, s2) => s2.modifiedTime.compareTo(s1.modifiedTime));
          }
          _multipleRestoreController.add(snapshots);
        }).catchError((error) {
          if (error.runtimeType == PlatformException) {
            PlatformException e = (error as PlatformException);
            if (e.code == _signInFailedCode || e.message == _signInFailedCode) {
              error = SignInFailedException(
                  _backupSettingsController.value.backupProvider);
            } else {
              error = (error as PlatformException).message;
            }
          }

          _restoreFinishedController.addError(error);
        });

        return;
      }

      if (request.encryptionKey != null && request.encryptionKey.key != null) {
        assert(request.encryptionKey.key.length > 0 || true);
      }
      assert(request.snapshot.nodeID.isNotEmpty);

      _breezLib
          .restore(request.snapshot.nodeID, request.encryptionKey.key)
          .then((_) => _restoreAppData()
              .then((value) => _restoreFinishedController.add(true))
              .catchError(_restoreFinishedController.addError));
    });
  }

  _restoreAppData() async {
    try {
      await _restoreLightningFees();
      await _restorePosDB();
    } on Exception catch (exception) {
      throw exception;
    }
  }

  Future<void> _restoreLightningFees() async {
    final lightningFeesPath =
        _backupAppDataDirPath + Platform.pathSeparator + 'lightningFees.txt';
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
        _backupAppDataDirPath + Platform.pathSeparator + 'product-catalog.db';
    final posDbPath = await databaseFactory.getDatabasesPath() +
        Platform.pathSeparator +
        'product-catalog.db';
    if (await File(backupPosDbPath).exists()) {
      await File(backupPosDbPath).copy(posDbPath).catchError((err) {
        throw Exception("Failed to restore pos items.");
      });
    }
  }

  Future<void> _restorePodcastsDB() async {
    final backupAnytimeDbPath =
        _backupAppDataDirPath + Platform.pathSeparator + 'anytime.db';
    final anytimeDbPath = _appDirPath + Platform.pathSeparator + 'anytime.db';
    if (await File(backupAnytimeDbPath).exists()) {
      await File(backupAnytimeDbPath).copy(anytimeDbPath).catchError((err) {
        throw Exception("Failed to restore podcast library.");
      });
    }
  }

  close() {
    _backupNowController.close();
    _backupAppDataController.close();
    _restoreLightningFeesController.close();
    _restoreRequestController.close();
    _multipleRestoreController.close();
    _restoreFinishedController.close();
    _backupSettingsController.close();
    _backupPromptVisibleController.close();
    _backupActionsController.close();
  }
}

class SnapshotInfo {
  final String nodeID;
  final String modifiedTime;
  final bool encrypted;
  final String encryptionType;

  SnapshotInfo(
      this.nodeID, this.modifiedTime, this.encrypted, this.encryptionType) {
    print(
        "New Snapshot encrypted = ${this.encrypted} encrytionType = ${this.encryptionType}");
  }

  SnapshotInfo.fromJson(Map<String, dynamic> json)
      : this(
          json["NodeID"],
          json["ModifiedTime"],
          json["Encrypted"] == true,
          json["EncryptionType"],
        );
}

class RestoreRequest {
  final SnapshotInfo snapshot;
  final BreezLibBackupKey encryptionKey;

  RestoreRequest(this.snapshot, this.encryptionKey);
}

class SignInFailedException implements Exception {
  final BackupProvider provider;

  SignInFailedException(this.provider);

  String toString() {
    return "Sign in failed";
  }
}

class BreezLibBackupKey {
  static const KEYLENGTH = 32;
  static const ENTROPY_LENGTH = 16 * 2; // 2 hex characters == 1 byte.

  BackupKeyType backupKeyType;
  String entropy;

  List<int> _key;

  set key(List<int> v) => _key = v;

  List<int> get key {
    var entropyBytes = _key;
    if (entropyBytes == null) {
      /*
      assert(entropy != null);
      assert(entropy.isNotEmpty);
      */
      if (entropy != null && entropy.isNotEmpty) {
        entropyBytes = HEX.decode(entropy);
      }
    }

    if (entropyBytes != null && entropyBytes.length != KEYLENGTH) {
      // The length of a "Mnemonics" entropy hex string in bytes is 32.
      // The length of a "Mnemonics12" entropy hex string in bytes is 16.

      entropyBytes = sha256.convert(entropyBytes).bytes;
    }

    return entropyBytes;
  }

  String get type {
    var result = '';
    if (key != null) {
      switch (backupKeyType) {
        case BackupKeyType.PHRASE:
          assert(entropy.length == ENTROPY_LENGTH ||
              entropy.length == ENTROPY_LENGTH * 2);
          result =
              entropy.length == ENTROPY_LENGTH ? 'Mnemonics12' : 'Mnemonics';
          break;
        case BackupKeyType.PIN:
          result = 'Pin';
          break;
        default:
      }
    }

    return result;
  }

  BreezLibBackupKey({this.entropy, List<int> key}) : _key = key;

  static Future<BreezLibBackupKey> fromSettings(
      FlutterSecureStorage store, BackupKeyType backupKeyType) async {
    assert(store != null);

    BreezLibBackupKey result;
    switch (backupKeyType) {
      case BackupKeyType.PIN:
        var pinCode = await store.read(key: 'pinCode');
        result = BreezLibBackupKey(key: utf8.encode(pinCode));
        break;
      case BackupKeyType.PHRASE:
        result = BreezLibBackupKey(entropy: await store.read(key: 'backupKey'));
        break;
      default:
    }
    result?.backupKeyType = backupKeyType;

    return result;
  }

  static Future save(FlutterSecureStorage store, String key) async {
    await store.write(key: 'backupKey', value: key);
  }
}
