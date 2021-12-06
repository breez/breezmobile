import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/background_task.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/injector.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../async_action.dart';
import 'backup_actions.dart';

class BackupBloc {
  static const String _signInFailedCode = "AuthError";
  static const String _notFoundCode = "NotFoundError";

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

  static const String BACKUP_SETTINGS_PREFERENCES_KEY = "backup_settings";
  static const String LAST_BACKUP_TIME_PREFERENCE_KEY = "backup_last_time";
  static const String LAST_BACKUP_STATE_PREFERENCE_KEY = "backup_last_state";

  BackupBloc(Stream<BreezUserModel> userStream) {
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
      // Read the backupKey from the secure storage and initialize the breez user model appropriately
      await _initializePersistentData();
      _listenBackupPaths();
      _listenBackupNowRequests();
      _listenRestoreRequests();
      _scheduleBackgroundTasks();

      // Read the backupKey from the secure storage and initialize the breez user model appropriately
      _setBreezLibBackupKey();
      if (_backupSettingsController.value.backupProvider != null) {
        await _updateBackupProvider(_backupSettingsController.value);
      }
      _listenPinCodeChange(userStream);
      _listenActions();
    });
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
        BackupSettings.remoteServerBackupProvider.name) {
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
            backupProvider: BackupSettings.googleBackupProvider);
      }
      if (backupSettingsModel.backupProvider?.name ==
          BackupSettings.remoteServerBackupProvider.name) {
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

  void _listenPinCodeChange(Stream<BreezUserModel> userStream) {
    userStream.listen((user) {
      _setBreezLibBackupKey();
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
    _breezLib.requestBackup();
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
          snapshots
              .sort((s1, s2) => s2.modifiedTime.compareTo(s1.modifiedTime));
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
      assert(!request.snapshot.nodeID.isEmpty);

      _breezLib
          .restore(request.snapshot.nodeID, request.encryptionKey.key)
          .then((_) => _restoreFinishedController.add(true))
          .catchError(_restoreFinishedController.addError);
    });
  }

  Future testAuth(BackupProvider provider, RemoteServerAuthData authData) {
    return _breezLib
        .testBackupAuth(provider.name, json.encode(authData.toJson()))
        .catchError((error) {
      log.info('backupBloc.testAuth caught error: $error');

      if (error is PlatformException) {
        var e = (error as PlatformException);
        // Handle PlatformException(ResultError, "AuthError", Failed to invoke testBackupAuth, null)
        switch (e.message) {
          case _signInFailedCode:
            throw SignInFailedException(provider);
            break;

          case _notFoundCode:
            throw RemoteServerNotFoundException();
            break;
        }
      }

      throw error;
    });
  }

  close() {
    _backupNowController.close();
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
    log.info(
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

class RemoteServerNotFoundException implements Exception {
  RemoteServerNotFoundException();

  String toString() {
    return "The server/url was not found.";
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
    }
    result?.backupKeyType = backupKeyType;

    return result;
  }

  static Future save(FlutterSecureStorage store, String key) async {
    await store.write(key: 'backupKey', value: key);
  }
}
