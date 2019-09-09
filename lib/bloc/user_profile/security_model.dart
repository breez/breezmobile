class SecurityModel {

  static List<int> lockIntervals = List.unmodifiable([0, 30, 120, 300, 600, 1800, 3600]);
  static const int _defaultLockInterval = 120;

  final bool requiresPin;
  final String backupPhrase;
  final bool secureBackupWithPin;
  final int automaticallyLockInterval;

  SecurityModel({this.requiresPin, this.backupPhrase, this.secureBackupWithPin, this.automaticallyLockInterval});

  SecurityModel copyWith({bool requiresPin, String backupPhrase, int automaticallyLockInterval, bool secureBackupWithPin}) {
    return new SecurityModel(requiresPin: requiresPin ?? this.requiresPin,
        backupPhrase: backupPhrase ?? this.backupPhrase,
        automaticallyLockInterval: automaticallyLockInterval ?? this.automaticallyLockInterval,
        secureBackupWithPin: secureBackupWithPin ?? this.secureBackupWithPin);
  }

  SecurityModel.initial()
      : this(requiresPin: false, backupPhrase: "", automaticallyLockInterval: _defaultLockInterval, secureBackupWithPin: false);

  SecurityModel.fromJson(Map<String, dynamic> json)
      : requiresPin = json['requiresPin'] ?? false,
        automaticallyLockInterval = json['automaticallyLockInterval'] ?? _defaultLockInterval,
        secureBackupWithPin = json['secureBackupWithPin'] ?? false,
        backupPhrase = "";

  Map<String, dynamic> toJson() =>
      {
        'automaticallyLockInterval': automaticallyLockInterval,
        'requiresPin': requiresPin,
        'secureBackupWithPin': secureBackupWithPin
      };
}
