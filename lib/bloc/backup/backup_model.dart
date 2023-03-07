import 'dart:convert';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/foundation.dart';

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
}

enum BackupKeyType {
  NONE,
  PIN,
  PHRASE,
}

class BackupSettings {
  static BackupProvider icloudBackupProvider() => BackupProvider(
        "icloud",
        getSystemAppLocalizations().backup_model_name_apple_icloud,
      );

  static BackupProvider googleBackupProvider() => BackupProvider(
        "gdrive",
        getSystemAppLocalizations().backup_model_name_google_drive,
      );

  static BackupProvider remoteServerBackupProvider() => BackupProvider(
        "remoteserver",
        getSystemAppLocalizations().backup_model_name_remote_server,
      );

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

  static BackupSettings start() => BackupSettings(
        true,
        BackupKeyType.NONE,
        defaultTargetPlatform == TargetPlatform.android
            ? googleBackupProvider()
            : null,
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

  static List<BackupProvider> availableBackupProviders() {
    List<BackupProvider> providers = [
      googleBackupProvider(),
      remoteServerBackupProvider()
    ];
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      providers.insert(0, icloudBackupProvider());
    }
    return providers;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupSettings &&
          runtimeType == other.runtimeType &&
          promptOnError == other.promptOnError &&
          backupKeyType == other.backupKeyType &&
          backupProvider == other.backupProvider &&
          remoteServerAuthData == other.remoteServerAuthData;

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

  BackupState.fromJson(Map<String, dynamic> json)
      : this(
          json["lastBackupTime"] != null
              ? DateTime.fromMillisecondsSinceEpoch(json["lastBackupTime"])
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
