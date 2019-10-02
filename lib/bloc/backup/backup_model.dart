import 'package:flutter/foundation.dart';

class BackupProvider {
  final String name;
  final String displayName;

  const BackupProvider(this.name, this.displayName);
}
enum BackupKeyType { NONE, PIN, PHRASE }

class BackupSettings {
  static const BackupProvider icloudBackupProvider = const BackupProvider("icloud", "Apple ICloud");
  static const BackupProvider googleBackupProvider = const BackupProvider("gdrive", "Google Drive");

  final bool promptOnError;
  final BackupKeyType backupKeyType;
  final BackupProvider backupProvider;

  BackupSettings(this.promptOnError, this.backupKeyType, this.backupProvider);
  BackupSettings.start() : this(
    true ,
    BackupKeyType.NONE, 
    defaultTargetPlatform == TargetPlatform.android ? googleBackupProvider : null);

  BackupSettings copyWith({bool promptOnError, BackupKeyType keyType, BackupProvider backupProvider}) {
    return BackupSettings(
      promptOnError ?? this.promptOnError, 
      keyType ?? this.backupKeyType,
      backupProvider ?? this.backupProvider);
  }

  BackupSettings.fromJson(Map<String, dynamic> json) : this(
    json["promptOnError"] ?? false,
    BackupKeyType.values[json["backupKeyType"] ?? 0],
    BackupSettings.availableBackupProviders().firstWhere(
      (p) => p.name == ["backupProvider"], orElse: null),
  );

  Map<String, dynamic> toJson(){
    return {"promptOnError": promptOnError, "backupKeyType": backupKeyType.index, "backupProvider": backupProvider};
  }

  static List<BackupProvider> availableBackupProviders(){
    List<BackupProvider> providers = [googleBackupProvider];
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      providers.add(icloudBackupProvider);
    }
    return providers;
  }
}

class BackupState {
  final DateTime lastBackupTime;
  final bool inProgress;

  BackupState(this.lastBackupTime, this.inProgress);
}