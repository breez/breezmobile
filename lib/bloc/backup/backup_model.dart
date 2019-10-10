import 'package:breez/widgets/backup_provider_selection_dialog.dart';
import 'package:flutter/foundation.dart';

class BackupProvider {
  final String name;
  final String displayName;

  const BackupProvider(this.name, this.displayName);
}
enum BackupKeyType { NONE, PIN, PHRASE }

class BackupSettings {
  static const BackupProvider icloudBackupProvider = const BackupProvider("icloud", "Apple iCloud");
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
      (p) => p.name == json["backupProvider"], orElse: () => null),
  );

  Map<String, dynamic> toJson(){
    return {"promptOnError": promptOnError, "backupKeyType": backupKeyType.index, "backupProvider": backupProvider?.name};
  }

  static List<BackupProvider> availableBackupProviders(){
    List<BackupProvider> providers = [googleBackupProvider];
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

  BackupState.fromJson(Map<String, dynamic> json) : this(
    json["lastBackupTime"] != null ? DateTime.fromMillisecondsSinceEpoch(json["lastBackupTime"]) : null,
    false,
    json["lastBackupAccountName"],
  );

  Map<String, dynamic> toJson(){
    return {"lastBackupTime": lastBackupTime?.millisecondsSinceEpoch, "lastBackupAccountName": lastBackupAccountName};
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