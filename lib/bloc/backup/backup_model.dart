enum BackupKeyType { NONE, PIN, PHRASE }

class BackupSettings {
  final bool promptOnError;
  final BackupKeyType backupKeyType;

  BackupSettings(this.promptOnError, this.backupKeyType);
  BackupSettings.start() : this(true, BackupKeyType.NONE);

  BackupSettings copyWith({bool promptOnError, BackupKeyType keyType}) {
    return BackupSettings(
      promptOnError ?? this.promptOnError,
      keyType ?? this.backupKeyType);
  }

  BackupSettings.fromJson(Map<String, dynamic> json) : this(
    json["promptOnError"] ?? false,
    BackupKeyType.values[json["backupKeyType"] ?? 0]);
    
  Map<String, dynamic> toJson(){
    return {"promptOnError": promptOnError, "backupKeyType": backupKeyType.index};
  }
}

class BackupState {
  final DateTime lastBackupTime;
  final bool inProgress;

  BackupState(this.lastBackupTime, this.inProgress);
}