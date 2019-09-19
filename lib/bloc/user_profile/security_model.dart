enum BackupKeyType { NONE, PIN, PHRASE }

class SecurityModel {
  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 120;

  final bool requiresPin;
  final BackupKeyType backupKeyType;
  final int automaticallyLockInterval;

  SecurityModel._({this.requiresPin, this.backupKeyType, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, int automaticallyLockInterval, BackupKeyType backupKeyType}) {
    return new SecurityModel._(
        requiresPin: requiresPin ?? this.requiresPin,
        automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval,
        backupKeyType: backupKeyType ?? this.backupKeyType,);
  }

  SecurityModel.initial()
      : this._(
            requiresPin: false, automaticallyLockInterval: _defaultLockInterval, backupKeyType: BackupKeyType.NONE,);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : requiresPin = json['requiresPin'] ?? false,
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval,
        backupKeyType = BackupKeyType.values[json["backupKeyType"] ?? 0];

  Map<String, dynamic> toJson() => {
        'automaticallyLockInterval': automaticallyLockInterval,
        'requiresPin': requiresPin,
        'backupKeyType': backupKeyType.index,
      };
}
