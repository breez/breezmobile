import 'dart:convert';

import 'package:flutter/foundation.dart';

class NextCloudAuthData {
  final String url;
  final String user;
  final String password;
  final String breezDir;

  NextCloudAuthData(this.url, this.user, this.password, this.breezDir);

  NextCloudAuthData.fromJson(Map<String, dynamic> json)
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

  bool equal(NextCloudAuthData other) {
    return json.encode(this.toJson()) == json.encode(other.toJson());
  }

  NextCloudAuthData copyWith(
      {String url, String user, String password, String breezDir}) {
    return NextCloudAuthData(
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

  const BackupProvider(this.name, this.displayName);
}

enum BackupKeyType { NONE, PIN, PHRASE }

class BackupSettings {
  static const BackupProvider icloudBackupProvider =
      BackupProvider("icloud", "Apple iCloud");
  static const BackupProvider googleBackupProvider =
      BackupProvider("gdrive", "Google Drive");
  static const BackupProvider nextcloudBackupProvider =
      BackupProvider("nextcloud", "Next Cloud");

  final bool promptOnError;
  final BackupKeyType backupKeyType;
  final BackupProvider backupProvider;
  final NextCloudAuthData nextCloudAuthData;

  BackupSettings(this.promptOnError, this.backupKeyType, this.backupProvider,
      this.nextCloudAuthData);
  BackupSettings.start()
      : this(
            true,
            BackupKeyType.NONE,
            defaultTargetPlatform == TargetPlatform.android
                ? googleBackupProvider
                : null,
            NextCloudAuthData(null, null, null, null));

  BackupSettings copyWith(
      {bool promptOnError,
      BackupKeyType keyType,
      BackupProvider backupProvider,
      NextCloudAuthData nextCloudAuthData}) {
    return BackupSettings(
        promptOnError ?? this.promptOnError,
        keyType ?? this.backupKeyType,
        backupProvider ?? this.backupProvider,
        nextCloudAuthData ?? this.nextCloudAuthData);
  }

  BackupSettings.fromJson(Map<String, dynamic> json)
      : this(
          json["promptOnError"] ?? false,
          BackupKeyType.values[json["backupKeyType"] ?? 0],
          BackupSettings.availableBackupProviders().firstWhere(
              (p) => p.name == json["backupProvider"],
              orElse: () => null),
          NextCloudAuthData.fromJson(json["nextcloudAuthData"] ?? {}),
        );

  Map<String, dynamic> toJson() {
    return {
      "promptOnError": promptOnError,
      "backupKeyType": backupKeyType.index,
      "backupProvider": backupProvider?.name,
      "nextcloudAuthData": nextCloudAuthData.toJson(),
    };
  }

  static List<BackupProvider> availableBackupProviders() {
    List<BackupProvider> providers = [
      googleBackupProvider,
      nextcloudBackupProvider
    ];
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      providers.insert(0, icloudBackupProvider);
    }
    return providers;
  }
}

class BackupState {
  final DateTime lastBackupTime;
  final bool inProgress;
  final String lastBackupAccountName;

  BackupState(this.lastBackupTime, this.inProgress, this.lastBackupAccountName);

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

  BackupFailedException(this.provider, this.authenticationError);

  String toString() {
    return "Backup Failed";
  }
}
