import 'dart:convert';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:logging/logging.dart';

final _log = Logger("BackupModel");

class RemoteServerAuthData {
  final String url;
  final String user;
  final String password;
  final String breezDir;

  const RemoteServerAuthData(
    this.url,
    this.user,
    this.password,
    this.breezDir,
  );

  RemoteServerAuthData.fromJson(Map<String, dynamic> json)
      : this(
          json["url"],
          json["user"],
          json["password"],
          json["breezDir"],
        );

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "user": user,
      "password": password,
      "breezDir": breezDir
    };
  }

  bool equal(RemoteServerAuthData other) {
    return json.encode(toJson()) == json.encode(other.toJson());
  }

  RemoteServerAuthData copyWith({
    String url,
    String user,
    String password,
    String breezDir,
  }) {
    return RemoteServerAuthData(
      url ?? this.url,
      user ?? this.user,
      password ?? this.password,
      breezDir ?? this.breezDir,
    );
  }

  @override
  String toString() {
    return 'RemoteServerAuthData{url: $url, user: $user, password: ****, breezDir: $breezDir}';
  }
}

class BackupProvider {
  final String name;
  final String displayName;

  const BackupProvider(
    this.name,
    this.displayName,
  );

  @override
  bool operator ==(Object other) {
    return other is BackupProvider && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'BackupProvider{name: $name, displayName: $displayName}';
  }

  static BackupProvider iCloud() => BackupProvider(
        "icloud",
        getSystemAppLocalizations().backup_model_name_apple_icloud,
      );

  static BackupProvider googleDrive() => BackupProvider(
        "gdrive",
        getSystemAppLocalizations().backup_model_name_google_drive,
      );

  static BackupProvider remoteServer() => BackupProvider(
        "remoteserver",
        getSystemAppLocalizations().backup_model_name_remote_server,
      );

  bool get isICloud => this == iCloud();
  bool get isGDrive => this == googleDrive();
  bool get isRemoteServer => this == remoteServer();
}

enum BackupKeyType {
  NONE,
  PIN,
  PHRASE,
}

class BackupSettings {
  final bool promptOnError;
  final BackupKeyType backupKeyType;
  final BackupProvider backupProvider;
  final RemoteServerAuthData remoteServerAuthData;

  BackupSettings(
    this.promptOnError,
    this.backupKeyType,
    this.backupProvider,
    this.remoteServerAuthData,
  );

  BackupSettings.initial()
      : this(
          true,
          BackupKeyType.NONE,
          _defaultBackupProvider(),
          const RemoteServerAuthData(null, null, null, null),
        );

  BackupSettings copyWith({
    bool promptOnError,
    BackupKeyType keyType,
    BackupProvider backupProvider,
    RemoteServerAuthData remoteServerAuthData,
  }) {
    return BackupSettings(
      promptOnError ?? this.promptOnError,
      keyType ?? backupKeyType,
      backupProvider ?? this.backupProvider,
      remoteServerAuthData ?? this.remoteServerAuthData,
    );
  }

  BackupSettings.fromJson(Map<String, dynamic> json)
      : this(
          json["promptOnError"] ?? false,
          BackupKeyType.values[json["backupKeyType"] ?? 0],
          BackupSettings.availableBackupProviders().firstWhere(
              (p) => p.name == json["backupProvider"],
              orElse: () => null),
          RemoteServerAuthData.fromJson(json["remoteServerAuthData"] ?? {}),
        );

  Map<String, dynamic> toJson() {
    return {
      "promptOnError": promptOnError,
      "backupKeyType": backupKeyType.index,
      "backupProvider": backupProvider?.name,
      "remoteServerAuthData": remoteServerAuthData.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupSettings &&
          runtimeType == other.runtimeType &&
          promptOnError == other.promptOnError &&
          backupKeyType == other.backupKeyType &&
          backupProvider == other.backupProvider &&
          remoteServerAuthData.equal(other.remoteServerAuthData);

  @override
  int get hashCode =>
      promptOnError.hashCode ^
      backupKeyType.hashCode ^
      backupProvider.hashCode ^
      remoteServerAuthData.hashCode;

  @override
  String toString() {
    return 'BackupSettings{promptOnError: $promptOnError, backupKeyType: $backupKeyType, '
        'backupProvider: $backupProvider, remoteServerAuthData: $remoteServerAuthData}';
  }

  static BackupProvider _defaultBackupProvider() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return BackupProvider.googleDrive();
      case TargetPlatform.iOS:
        return BackupProvider.iCloud();
      default:
        return null;
    }
  }

  static List<BackupProvider> availableBackupProviders() {
    List<BackupProvider> providers = [
      BackupProvider.googleDrive(),
      BackupProvider.remoteServer()
    ];
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      providers.insert(0, BackupProvider.iCloud());
    }
    return providers;
  }
}

class BackupState {
  final DateTime lastBackupTime;
  final bool inProgress;
  final String lastBackupAccountName;

  const BackupState(
    this.lastBackupTime,
    this.inProgress,
    this.lastBackupAccountName,
  );

  BackupState.initial() : this(null, false, null);

  BackupState copyWith({
    DateTime lastBackupTime,
    bool inProgress,
    String lastBackupAccountName,
  }) {
    return BackupState(
      lastBackupTime ?? this.lastBackupTime,
      inProgress ?? this.inProgress,
      lastBackupAccountName ?? this.lastBackupAccountName,
    );
  }

  BackupState.fromJson(Map<String, dynamic> json)
      : this(
          json["lastBackupTime"] != null
              ? DateTime.fromMillisecondsSinceEpoch(json["lastBackupTime"])
                  .toLocal()
              : null,
          false,
          json["lastBackupAccountName"],
        );

  Map<String, dynamic> toJson() {
    return {
      "lastBackupTime": lastBackupTime?.millisecondsSinceEpoch,
      "lastBackupAccountName": lastBackupAccountName
    };
  }

  bool get isInitial => this != null && this == BackupState.initial();
}

class BackupFailedException implements Exception {
  final BackupProvider provider;
  final bool authenticationError;

  const BackupFailedException(
    this.provider,
    this.authenticationError,
  );

  @override
  String toString() {
    return getSystemAppLocalizations().backup_model_error_failed;
  }
}

class SnapshotInfo {
  final String nodeID;
  final String modifiedTime;
  final bool encrypted;
  final String encryptionType;

  SnapshotInfo(
    this.nodeID,
    this.modifiedTime,
    this.encrypted,
    this.encryptionType,
  ) {
    assert(nodeID != null);
    assert(modifiedTime != null);
    _log.info(
      "New Snapshot encrypted = $encrypted encryptionType = $encryptionType",
    );
  }

  SnapshotInfo.fromJson(Map<String, dynamic> json)
      : this(
          json["NodeID"],
          json["ModifiedTime"],
          json["Encrypted"] == true,
          json["EncryptionType"],
        );
}

class SignInFailedException implements Exception {
  final BackupProvider provider;

  SignInFailedException(this.provider);

  @override
  String toString() {
    return "Sign in failed";
  }
}

class GoogleSignNotAvailableException implements Exception {
  @override
  String toString() {
    return getSystemAppLocalizations().google_sign_not_available_exception;
  }
}

class MethodNotFoundException implements Exception {
  MethodNotFoundException();

  @override
  String toString() {
    return "Method not found";
  }
}

class SignInCancelledException implements Exception {
  @override
  String toString() {
    return "Sign in cancelled";
  }
}

class InvalidCredentialsException implements Exception {
  @override
  String toString() {
    return "Sign in failed. Please try again";
  }
}

class InsufficientScopeException implements Exception {
  @override
  String toString() {
    return "Please give Breez required permissions and try again";
  }
}

class NoBackupFoundException implements Exception {
  @override
  String toString() {
    return "No backup found";
  }
}

class RemoteServerNotFoundException implements Exception {
  @override
  String toString() {
    return "The server was not found. Please check the address";
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

          /// Sets type of backups encrypted with PIN to
          /// BackupKeyType.NONE as they are are non-secure & deprecated
          result = '';
          break;
        default:
      }
    }

    return result;
  }

  BreezLibBackupKey({this.entropy, List<int> key}) : _key = key;

  static Future<BreezLibBackupKey> fromSettings(
    FlutterSecureStorage store,
    BackupKeyType backupKeyType,
  ) async {
    assert(store != null);

    BreezLibBackupKey result;
    switch (backupKeyType) {
      case BackupKeyType.NONE:
      case BackupKeyType.PIN:

        /// Sets backup key type of backups encrypted with PIN to
        /// BackupKeyType.NONE as they are are non-secure & deprecated
        result = BreezLibBackupKey(entropy: null, key: null);
        backupKeyType = BackupKeyType.NONE;
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

class RestoreRequest {
  final SnapshotInfo snapshot;
  final BreezLibBackupKey encryptionKey;

  RestoreRequest(this.snapshot, this.encryptionKey)
      : assert(
          snapshot.nodeID != null && snapshot.nodeID.isNotEmpty,
          "Node ID mustn't be empty for restore request.",
        ),
        assert(
          !(encryptionKey != null && encryptionKey.key != null) ||
              encryptionKey.key.isNotEmpty,
          "Encryption key mustn't be empty for encrypted backup.",
        );
}
