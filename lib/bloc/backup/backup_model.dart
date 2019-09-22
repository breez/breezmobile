import 'package:flutter/foundation.dart';

class BackupProvider {
  final String name;
  final String displayName;

  const BackupProvider(this.name, this.displayName);
}

class BackupSettings {
  static const BackupProvider icloudBackupProvider = const BackupProvider("icloud", "Apple ICloud");
  static const BackupProvider googleBackupProvider = const BackupProvider("gdrive", "Google Drive");

  final bool promptOnError;
  final BackupProvider backupProvider;

  BackupSettings(this.promptOnError, this.backupProvider);
  BackupSettings.start() : this(
    true , 
    defaultTargetPlatform == TargetPlatform.android ? googleBackupProvider : null);

  BackupSettings copyWith({bool promptOnError, BackupProvider backupProvider}) {
    return BackupSettings(promptOnError ?? this.promptOnError, backupProvider ?? this.backupProvider);
  }

  BackupSettings.fromJson(Map<String, dynamic> json) : this(
    json["promptOnError"] ?? false,
    BackupSettings.availableBackupProviders().firstWhere(
      (p) => p.name == ["backupProvider"], orElse: null),
  );

  Map<String, dynamic> toJson(){
    return {"promptOnError": promptOnError, "backupProvider": backupProvider};
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